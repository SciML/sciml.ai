@def rss_pubdate = Date(2025, 10, 10)
@def rss = """SciML Developer Chat Episode 1: Trimming, Base Splits, and Symbolics Precompilation"""
@def published = "10 October 2025"
@def title = "SciML Developer Chat Episode 1: Trimming, Base Splits, and Symbolics Precompilation"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>, <a href="https://github.com/oscardssmith">Oscar Smith</a>, <a href="https://github.com/AayushSabharwal">Aayush Sabharwal</a>"""

# SciML Developer Chat Episode 1: Trimming, Base Splits, and Symbolics Precompilation

Welcome to the inaugural SciML Developer Chat! This is a new format we're trying out to share what's happening behind the scenes in SciML development. Rather than waiting for formal blog posts or annual JuliaCon talks, we're pulling developers together for casual discussions about ongoing work.

You can watch the full video here:

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/0yQ4aZ-ABhY?si=5LIR8gayIkvxyM6Z" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
~~~

(This is an AI-assisted summary of the discussion)

In this first episode, Chris Rackauckas, Oscar Smith, and Ayush Sabharwal discuss four major development efforts currently underway in the SciML ecosystem. Let's dive into each topic.

## Trimming Support Throughout SciML

One of the most exciting recent developments has been getting SciML to work with Julia's static compilation and trimming capabilities. This effort kicked off at the JuliaCon hackathon when Romeo showed up and said, "I want to get JuliaC and trimming working on SciML." What started as a prototype that required specific development branches and exact algorithm choices has evolved into robust, well-tested support.

### What is Trimming?

Trimming refers to Julia's ability to create statically compiled binaries that only include the code paths actually used by your program. This is crucial for deployment scenarios where you want minimal binary sizes and don't want to ship the entire Julia runtime.

### The Technical Challenges

Making SciML trimmable required changes throughout the stack:

**Base Julia Changes**: Gabriel and Cody worked on making various parts of Base compatible with trimming, particularly around error paths. In regular Julia, dynamic behavior on error paths is acceptable since errors are rare. For trimming, these needed to be either made static or configured to abort on error.

**LinearSolve.jl**: This was one of the biggest challenges. The library now uses `@static` annotations extensively to satisfy trimming constraints. The key rule: you must be able to determine statically which algorithm you're using. Dynamic algorithm selection (like checking `CUDA.functional()` at runtime) breaks trimming because it might try to compile code for systems you don't have.

The solution involved creating functions that are always false by default, then overwriting them via extensions when CUDA is actually loaded. This way, if you're not building with CUDA, the code remains static and trimmable.

**CPUSummary.jl**: This required a major redesign. Previously, it would `eval` in CPU properties at init time (cache sizes, core counts, etc.). Now it uses Preferences.jl, making everything static at compile time. The trade-off: binaries are no longer relocatable to different CPU architectures. Your binary will be optimized for the CPU you built it on, not the one you're running it on. This is acceptable for most deployment scenarios but something to be aware of.

### Current Status

As of now:
- Explicit solvers (Tsit5, Vern7) work out of the box
- Semi-implicit solvers (Rosenbrocks) work with the linearsolve changes
- NonlinearSolve.jl has comprehensive trim tests
- One remaining piece: getting the full robust default algorithm stack to trim

Oscar demonstrated that Rosenbrock solvers now trim successfully, though initialization algorithms need attention. The initialization does use nonlinear solve, so we need the full robust nonlinear solver stack to be trimmable.

### Testing Strategy

Romeo put together an impressive test infrastructure in NonlinearSolve.jl that actually runs `juliac`, builds a binary, and tests it in a separate process. This is the gold standard, though it's time-intensive to set up in every repo. We're exploring using JET for static analysis as an alternative, though it has had some false positive issues that were recently resolved in Julia 1.12.

The plan is to create a downstream integration test where SciMLBase calls NonlinearSolve.jl's trim test, then write a similar test for ODE solvers.

## Base Splitting Refactors

If you've noticed some version instability in SciML packages recently, this is why. We've been restructuring the entire dependency graph to create a cleaner, more modular architecture.

### The Old Architecture Problem

In the early days of DifferentialEquations.jl (around 2016), we made some architectural choices that made sense at the time but became problematic as the ecosystem grew:

1. **SteadyStateDiffEq as a special case**: Steady state problems are essentially nonlinear problems (ODEs run to infinity), so `AbstractNonlinearProblem` inherited from `AbstractDiffEqProblem`. This meant NonlinearSolve.jl depended on DiffEqBase.jl.

2. **Circular dependency issues**: The nonlinear solvers used in ODE solver callbacks couldn't come from NonlinearSolve.jl because that would create a circular dependency. So we had duplicate nonlinear solver implementations.

3. **Shared code duplication**: All the keyword argument checking, type promotion, and compatibility checking was duplicated across problem types.

### The New Architecture

We've restructured to create a cleaner hierarchy:

```
                    SciMLBase.jl
                         |
        +----------------+----------------+
        |                |                |
   DiffEqBase      NonlinearSolveBase  OptimizationBase
        |                |                |
   OrdinaryDiffEq   NonlinearSolve   Optimization.jl
```

**SciMLBase.jl** sits at the bottom with functionality shared by ALL SciML solvers:
- Element type checking and promotion
- Distribution handling
- U0 compatibility validation
- Parameter promotion

**Specialized base packages** (DiffEqBase, NonlinearSolveBase, OptimizationBase) contain code shared within each solver family.

**Solver libraries** depend only on their respective base packages.

### Benefits

1. **No more circular dependencies**: NonlinearSolve.jl can be used independently of differential equation solvers
2. **Correct error messages**: Nonlinear solvers no longer throw error messages about ODE function syntax
3. **Reduced compilation times**: You don't pull in Fortran dependencies from Optimization.jl when you just want to use OptimizationOptimisers.jl
4. **Cleaner symbolic indexing**: No more weird cases where nonlinear problems inherit time-dependence from being subtypes of DE problems

### What Users See

There were some versions that didn't precompile during this transition - that's what all the version bumps were about. We had the same function defined in two base packages temporarily during the migration.

The good news: this is now complete except for possibly merging DiffEqBase into OrdinaryDiffEqCore. Since Sundials.jl v5 now uses the same initialization interface as OrdinaryDiffEq, there's less need for a separate base package. However, this change might be more annoying than it's worth, so we're still discussing it.

### Future Work

We may create even more specialized base packages:
- **LinearSolveBase.jl**: A minimal version that builds without MKL, even though we default to using MKL
- **SciMLSensitivityBase.jl**: A minimal version without Enzyme, even though we default to using Enzyme

This would enable building binaries without these heavy dependencies when needed, while still defaulting to them for normal use.

## SymbolicUtils v4.0 Rewrite

This is perhaps the most ambitious change discussed in the episode. Ayush has been leading a complete rewrite of SymbolicUtils.jl, the foundation of ModelingToolkit.jl's symbolic manipulation capabilities.

### The Motivation

If you've ever loaded ModelingToolkit and tried to simplify an ODE system, you've noticed it takes a while on the first call, even though we precompile what we can. The root cause: nothing in symbolic manipulation was type stable. Everything eventually gave up and fell back to `Any`.

### The Technical Challenge

Symbolic computing requires different internal representations for optimal performance:

- **Polynomials**: Should use "add muls" - dictionaries where keys are terms and values are coefficients. This makes associative/commutative rules trivial to apply (x + y + z == y + x + z is just dictionary equality).

- **General expressions**: Tree representation with operation and arguments.

- **Arrays**: Need special handling with Einstein summation notation.

But if your tree nodes can be any of these types, you end up with `Array{Any}` for the arguments, destroying type stability.

### The Solution: Sum Types

SymbolicUtils v4.0 introduces a Moshi sum type (similar to Rust enums or OCaml variants).

This is one type with a union of different internal representations. Arrays of `BasicSymbolic` are type stable, even if they contain a mix of terms, polynomials, and constants. Runtime checks determine which variant you have, but the type itself is stable.

### Major Breaking Changes

**1. No Type Parameters for Value Types**

Previously: `BasicSymbolic{Real}`, `Symbolic{Vector{Real}}`

Now: Just `BasicSymbolic`. The value type is stored as metadata but not in the type parameter.

Why: Functions can return scalars or arrays depending on their arguments. You can't store argument types in a type-stable way if the return type depends on runtime values.

**2. Symbolic Constants**

Previously: `x - x` would return `0` (an integer)

Now: `x - x` returns a blue `const(0)` (a symbolic constant)

This ensures that any operation on symbolics returns a symbolic. This is the basis of type stability - you can statically infer that adding two symbolics gives a symbolic, not potentially a number or array.

If you actually want a number, you must explicitly request it (e.g., with `val=true` in substitute).

### Array Support Improvements

The rewrite includes first-class support for arrays:

- **Undefined sizes**: Symbolic arrays can have unknown dimensions. Code generation will loop over `axes(x, 1)` and `axes(x, 2)`.

- **O(1) discretization**: PDE discretization code can be generated that works for any discretization size. Change your grid resolution, use the same compiled code.

- **Array operations**: Full primitive array algebra with potential for future loop fusion optimizations.

This is particularly important for MethodOfLines.jl, which should see dramatic compile time improvements once fully integrated.

### Performance Implications

The type stability enables precompilation of symbolic workflows. Simplifying an ODE system should become nearly instantaneous instead of taking 30+ seconds on the first call.

Ayush has optimized specific algorithms that are commonly used. Making 100% of Symbolics.jl type stable will take several more months, but the critical paths are done.

### Migration Path

SymbolicUtils v4.0 is released. Symbolics.jl is almost updated. ModelingToolkit.jl integration is ongoing. Some scalarization analysis still needs work to avoid breaking up array operations unnecessarily.

Daria is working on integrating Bumper.jl and Reactant.jl so generated code with array operations will be non-allocating and fast by default.

## DifferentialEquations.jl v8 Breaking Changes

The final topic covered the upcoming breaking changes to DifferentialEquations.jl and OrdinaryDiffEq.jl.

### The Core Problem

DifferentialEquations.jl was designed as a batteries-included package that depends on everything. This made sense when the ecosystem was small, but now:

- Almost nobody solves stochastic equations, boundary value problems, AND DAEs in the same session
- People want to use sub-libraries independently
- The default algorithm having dependencies on everything means pulling in unnecessary code

### The Solution: Restructuring

**DifferentialEquations.jl v8** will become focused specifically on ODEs. It will:
- Contain only the 6-10 solvers that 99.9% of people use
- Load quickly
- Not depend on every solver package

For other problem types, use the specific packages:
- `StochasticDiffEq.jl` for SDEs
- `DelayDiffEq.jl` for DDEs  
- `BoundaryValueDiffEq.jl` for BVPs
- `SteadyStateDiffEq.jl` for steady states

Documentation at https://docs.sciml.ai/DiffEqDocs/stable/ has already been updated to guide users to the appropriate package.

**OrdinaryDiffEq.jl v7** will be split so additional solvers are in separate packages:
- Core solvers in OrdinaryDiffEq.jl
- Specialized solvers (Feagin, extrapolation methods, etc.) in extension packages

### Other Breaking Changes

**1. Preconditioner Interface**

Preconditioners now go as arguments to your `linsolve` parameter, not as separate solver arguments. This makes it easier to:
- Switch out solvers
- Save and reuse built preconditioners  
- Use simple preconditioners like AMG without custom code

**2. Check Initialization by Default**

For DAE problems, the solver will now check that your initial conditions are consistent by default (like Sundials.jl v5 already does). You must explicitly tell it if you want it to modify your initial conditions.

This prevents confusing interactions with callbacks where inconsistent initial conditions silently changed.

**3. Trimming-Compatible Default Controllers**

Various bits of the controller interface that were runtime dynamic will become type-level static to support trimming.

### Open Questions

**Should we default to Enzyme instead of ForwardDiff?**

Decision: **No**. The experience with Julia 1.11 showed that Enzyme support can lag for months on new Julia releases. We can't have OrdinaryDiffEq not working on new Julia versions for 6 months. ForwardDiff always works day one.

Users can easily switch to Enzyme when needed, but the default needs to be maximally robust.

**Can we delete OrdinaryDiffEq's internal nonlinear solvers?**

This is the big question mark. Oscar is working to make NonlinearSolve.jl fast enough for the specific use case inside ODE solvers. If successful, we can:
- Delete a lot of OrdinaryDiffEq's code
- Get better nonlinear convergence (trust region methods, line searches)
- Allow larger time steps
- Have one less internal implementation to maintain

The challenge: ODE solvers need very specific hooks and performance characteristics. We're optimizing NonlinearSolve.jl to meet these needs over the next 1-2 months.

This might not technically be a breaking change (how nonlinear solving is done internally isn't part of the API), but it's sweeping enough that bundling it with v7 makes sense.

**Will we switch to DifferentiationInterface.jl?**

Possibly. Oscar is considering changes to how you specify derivatives (Jacobians, W operators, VJPs, JVPs). The current interface isn't quite right, and DifferentiationInterface.jl provides a nice audited standard.

This could be the actual breaking part of the nonlinear solve integration, more than the solver change itself.

### DAE Solvers

An open GSOC project: finish DFBDF to be better than IDA from Sundials. Current status:
- DFBDF is often faster than IDA
- Missing: collocation polynomial interpolation (currently uses Hermite polynomials, less stable)
- Has callback support (added earlier this year)

However, for most users, the recommendation remains: use mass matrix ODE formulations instead of DAE problems. Every benchmark shows they're faster and more robust. ModelingToolkit.jl defaults to this approach.

### Merging Repositories

StochasticDiffEq.jl and DelayDiffEq.jl will likely be merged into OrdinaryDiffEq.jl. They reuse so much of the same code (everything except their specific time steppers) that keeping them separate has become a maintenance burden.

They use internal OrdinaryDiffEq code that has "no interface and is horrible," so merging them enables cleaning this up.

BoundaryValueDiffEq.jl will likely stay separate - it's different enough to warrant its own package.

## Timeline

These changes are happening now:
- **SymbolicUtils v4.0**: Released
- **Symbolics.jl update**: Nearly complete  
- **NonlinearSolveBase/OptimizationBase**: Complete
- **Trimming support**: Most infrastructure done, testing ongoing
- **OrdinaryDiffEq v7 / DifferentialEquations.jl v8**: Target next 1-2 months

This is a lot of breaking changes at once, but consolidating them means:
- One migration period instead of multiple
- Aligned ecosystem upgrades
- Taking advantage of the break to fix multiple pain points at once

## Conclusion

These changes represent months of work from many contributors:
- **Romeo**: Trimming prototype and test infrastructure
- **Gabriel and Cody**: Base Julia trimming support  
- **Max**: LoopVectorization.jl 1.12 compatibility
- **Jaden**: Optimization.jl base split work
- **Aayush**: SymbolicUtils v4.0 rewrite
- **Oscar**: Numerics, preconditioner interface, nonlinear solve optimization
- **Chris**: Architecture and coordination

The result will be:
- Faster precompilation across the ecosystem
- Cleaner dependency graphs
- Static compilation support
- Type-stable symbolic manipulation
- More modular, maintainable code

We hope you enjoyed this first SciML Developer Chat! If you'd like to see more of these casual development discussions, let us know. Future episodes could cover:
- Catalyst.jl developments with Torkel
- The new VerbosityChain logging system with Jaden  
- Other behind-the-scenes work in SciML

The goal is to share what's happening without the overhead of formal blog posts or waiting for JuliaCon. Think of it as the lazy way to share more information - and we mean that in the best possible way!

And as always, if you have questions or want to contribute, join us on the [Julia Slack](https://julialang.org/slack/) or [GitHub](https://github.com/SciML).
