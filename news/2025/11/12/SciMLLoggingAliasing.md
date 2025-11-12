@def rss_pubdate = Date(2025,11,12)
@def rss = """Fine-Grained Control in SciML: Introducing SciMLLogging and Enhanced Aliasing"""
@def published = " 12 November 2025 "
@def title = "Fine-Grained Control in SciML: Introducing SciMLLogging and Enhanced Aliasing"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Fine-Grained Control in SciML: Introducing SciMLLogging and Enhanced Aliasing

The SciML ecosystem continues to evolve with tools that give you precise control over your scientific computing workflows. Two recent additions—SciMLLogging.jl and the enhanced aliasing specification system—address common pain points in large-scale simulations: managing output verbosity and optimizing memory usage. Together, they provide the granular control needed for production-grade scientific computing.

## SciMLLogging.jl: Verbosity Control Done Right

If you've ever found yourself drowning in solver output or wishing you could selectively silence certain warnings while keeping others, SciMLLogging.jl is your answer. This new package brings hierarchical, fine-grained logging control to the entire SciML ecosystem.

### Why SciMLLogging?

Traditional logging approaches often force an all-or-nothing choice: either see everything or see nothing. In complex scientific workflows—where you might want algorithm selection warnings but not iteration progress, or vice versa—this granularity matters. SciMLLogging.jl provides structured message handling that integrates seamlessly with Julia's native logging system while adding the specificity scientific computing demands.

### How It Works in LinearSolve.jl

Let's look at a concrete example from LinearSolve.jl. The package defines a `LinearVerbosity` struct organized into three main groups: error control, performance, and numerical diagnostics.

```julia
using LinearSolve, SciMLLogging

# Quick start: Use a preset configuration
verbose = LinearVerbosity(Standard())  # Balanced default
solve(prob, verbose = verbose)

# Or choose from other presets:
LinearVerbosity(None())      # All messages disabled
LinearVerbosity(Minimal())   # Only critical errors
LinearVerbosity(Detailed())  # Comprehensive debugging
LinearVerbosity(All())       # Maximum verbosity
```

The real power comes from fine-grained control over individual message categories:

```julia
# Control entire groups at once
verbose = LinearVerbosity(
    error_control = WarnLevel(),  # Show all error-related warnings
    numerical = InfoLevel(),       # Show numerical diagnostics
    performance = Silent()         # Hide performance messages
)

# Or control individual fields
verbose = LinearVerbosity(
    default_lu_fallback = WarnLevel(),     # Warn about factorization fallbacks
    blas_errors = ErrorLevel(),             # Show BLAS errors
    convergence_failure = WarnLevel(),      # Warn about convergence issues
    KrylovJL_verbosity = CustomLevel(1),   # Pass verbosity to Krylov.jl
    condition_number = InfoLevel()          # Show condition numbers
)

# Mix group and individual settings (individual overrides group)
verbose = LinearVerbosity(
    numerical = Silent(),              # Silence all numerical messages
    blas_errors = WarnLevel()          # Except BLAS errors
)
```

Here's what this looks like in practice with a rank-deficient system:

```julia
using LinearSolve

A = [1.0 0 0 0
     0 1 0 0
     0 0 1 0
     0 0 0 0]  # Singular matrix
b = rand(4)
prob = LinearProblem(A, b)

# With warnings enabled:
verbose = LinearVerbosity(default_lu_fallback = WarnLevel())
solve(prob, verbose = verbose)
# ┌ Warning: LU factorization failed, falling back to QR factorization.
# │ `A` is potentially rank-deficient.
# └ @ LinearSolve

# Change to InfoLevel for informational messages instead
verbose = LinearVerbosity(default_lu_fallback = InfoLevel())
solve(prob, verbose = verbose)
# [ Info: LU factorization failed, falling back to QR factorization.
#         `A` is potentially rank-deficient.
```

### Message Categories in LinearSolve.jl

LinearVerbosity organizes messages into semantically meaningful groups:

**Error Control Group:**
- `default_lu_fallback`: Notifications when falling back from specialized methods
- `blas_errors`: Critical BLAS/LAPACK errors
- `blas_invalid_args`: Argument validation failures

**Performance Group:**
- `no_right_preconditioning`: Messages about preconditioning choices

**Numerical Group:**
- `convergence_failure`: Iterative solver convergence issues
- `solver_failure`: General solver failures
- `max_iters`: Maximum iteration warnings
- `condition_number`: Matrix conditioning information
- `KrylovJL_verbosity`, `HYPRE_verbosity`, `pardiso_verbosity`: Pass-through verbosity to external solvers
- `blas_info`, `blas_success`: BLAS operation diagnostics

### For Package Developers

Package developers emit structured messages using the `@SciMLMessage` macro:

```julia
@SciMLMessage("LU factorization failed, falling back to QR factorization. " *
              "`A` is potentially rank-deficient.",
              verbose, :default_lu_fallback)

# Dynamic messages with computed values:
@SciMLMessage(verbose, :condition_number) do
    "Matrix condition number: $(cond(A)) for $(size(A)) matrix"
end
```

### Advanced Logger Configuration

SciMLLogging.jl includes `SciMLLogger` for routing messages to files:

```julia
logger = SciMLLogger(
    info_repl = true,
    warn_repl = true,
    warn_file = "solver_warnings.log"
)

with_logger(logger) do
    solve(prob, verbose = LinearVerbosity(Detailed()))
end
```

This captures all warnings to `solver_warnings.log` while displaying info and warnings in your REPL—perfect for auditing solver behavior in production systems or debugging long-running workflows.

## Aliasing Specification: Memory Optimization Made Explicit

While SciMLLogging gives you control over what you see, the aliasing specification system gives you control over how memory is managed. In large-scale simulations—especially those involving repeated solves in optimization loops or sensitivity analysis—memory allocation patterns can make or break performance.

### Understanding Aliasing

Aliasing in this context means allowing the solver to reuse (alias) input arrays rather than copying them. When you alias `u0`, for example, the solver might modify the array you passed in rather than allocating a fresh copy. This can significantly reduce memory pressure, but requires careful consideration of whether you need the original data intact.

### The Problem-Specific Approach

Every SciML problem type now has an associated `AbstractAliasSpecifier` that provides explicit control over which variables to alias. This problem-specific design ensures the API matches the semantics of each problem type:

```julia
using OrdinaryDiffEq

# For ODE problems:
solve(prob, Tsit5(), alias = ODEAliasSpecifier(alias_u0 = true))

# For linear systems:
solve(prob, KrylovJL_GMRES(), alias = LinearAliasSpecifier(
    alias_A = false,  # Keep A intact
    alias_b = true    # b can be modified
))

# For stochastic problems:
solve(prob, SRIW1(), alias = SDEAliasSpecifier(
    alias_u0 = true,
    alias_jumps = true
))
```

### Available Specifiers

The ecosystem includes tailored specifiers for each problem domain:

- **`LinearAliasSpecifier`**: Control aliasing for coefficient matrices and vectors
- **`ODEAliasSpecifier`**: Manage initial conditions, derivatives, and time stops
- **`SDEAliasSpecifier`**: Extends ODE options with jump process aliasing
- **`NonlinearAliasSpecifier`**: Optimize solution vector handling
- **`OptimizationAliasSpecifier`**, **`BVPAliasSpecifier`**, **`DDEAliasSpecifier`**, **`SDDEAliasSpecifier`**: Domain-specific controls for their respective problem types

### Smart Defaults

The aliasing system is designed with safety and convenience in mind. When you set a field to `nothing`, the solver uses its own optimized default behavior:

```julia
# Let the solver decide about u0, but explicitly prevent aliasing of p
solve(prob, alg, alias = ODEAliasSpecifier(alias_u0 = nothing, alias_p = false))
```

This flexibility means you can selectively optimize specific bottlenecks without micromanaging the entire solve process.

### When to Use Aliasing

Aliasing optimization becomes valuable in several scenarios:

1. **Optimization loops**: When solving the same problem structure repeatedly with different parameters
2. **Memory-constrained systems**: Large-scale problems where allocation overhead dominates
3. **Sensitivity analysis**: Multiple problem evaluations where intermediate results don't need preservation
4. **Ensemble simulations**: Parallel solves where each trajectory can safely modify inputs

### Best Practices

1. **Start with defaults**: Let solvers determine aliasing behavior initially, only optimizing after profiling
2. **Measure, don't assume**: Use `@time` and memory allocation tracking to verify improvements
3. **Beware of mutations**: If you need the original arrays later, don't alias them
4. **Profile your use case**: Performance impacts vary significantly based on problem size and structure

## The Bigger Picture

SciMLLogging.jl and the aliasing specification system exemplify a broader philosophy in the SciML ecosystem: providing powerful defaults while exposing expert-level control when needed. Beginners can ignore both and get excellent performance with sensible logging. Experts can fine-tune every aspect of their workflow for production deployments.

These additions also share a common design pattern: hierarchical, composable structures that integrate cleanly with the rest of SciML. Whether you're managing verbosity or memory, you use the same familiar keyword argument pattern that pervades the ecosystem.

## Getting Started

Both features are available now. SciMLLogging.jl is a standalone package:

```julia
using Pkg
Pkg.add("SciMLLogging")
```

The aliasing specification system is integrated directly into SciMLBase.jl, so if you're on the latest version, you already have it.

For detailed documentation:
- [SciMLLogging.jl repository](https://github.com/SciML/SciMLLogging.jl)
- [Aliasing specification docs](https://docs.sciml.ai/SciMLBase/dev/interfaces/Problems/#Aliasing-Specification)

We encourage you to experiment with these tools in your workflows. The granular control they provide can make the difference between a debugging nightmare and a smooth production deployment. As always, if you encounter issues or have suggestions, the SciML community is active on [GitHub Discussions](https://github.com/orgs/SciML/discussions) and [Discourse](https://discourse.julialang.org/).

Happy computing!

---

*Want to dive deeper? Check out the full [SciML documentation](https://docs.sciml.ai/) for comprehensive guides on integrating these features into your scientific workflows.*
