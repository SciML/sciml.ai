@def rss_pubdate = Date(2025,9,17)
@def rss = """Sundials.jl v5.0: Update to SUNDIALS v7 and Improved DAE Initialization"""
@def published = " 17 September 2025 "
@def title = "Sundials.jl v5.0: Update to SUNDIALS v7 and Improved DAE Initialization"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Sundials.jl v5.0: Update to SUNDIALS v7 and Improved DAE Initialization

We're excited to announce the release of **Sundials.jl v5.0**, a major update that brings significant improvements to differential-algebraic equation (DAE) solving, upgrades to the latest Sundials C library, and enhanced integration with the SciML ecosystem. This release includes important breaking changes designed to improve safety, clarity, and performance when solving DAEs.

## Why the Breaking Changes? How is this related to coming DifferentialEquations.jl v8 and OrdinaryDiffEq v7 breaking changes?

Sundials.jl is the first library in the set getting a major breaking change. If you aren't aware, check out the 
[the State of SciML extended edition](https://www.youtube.com/watch?v=SZZ0lT8DVRo) which discusses the major changes coming to the SciML differential equation solvers. The main things are:

1. Simplifying the DifferentialEquations.jl library's dependencies to only be ODEs
2. Simplifying OrdinaryDiffEq.jl's dependencies to just the standard default algorithms
3. Changing the default DAE initialization to `CheckInit`, i.e. don't change `u0` without the user opting into allowing things to change (except with
   ModelingToolkit.jl, because it strictly enforces equations vs guesses behavior)
4. No initialization ran by default after a callback, i.e. use the callback.initalizealg (which defaults to `CheckInit`) after a callback on a DAE

While the (1) and (2) are not so related, (3) and (4) are breaking changes because what used to just `solve(prob, IDA())` would now be 
`solve(prob, IDA(), initializealg = BrownFullBasicInit())` as otherwise your `du0` guess needs to be correct. Is `du0` respected or a guess?
Is `u0` respected or a guess? In the previous semanitcs it was a bit of "it depends". Thus we have been wanting to impose a change to `CheckInit`,
which means by default DAE consistency is checked and you get an error if the initial conditions are not consistent, but then it's easy to change to
different documented behaviors:

* `BrownFullBasicInit()`: treat the differential variables as known and change `u0` for the algebraic variables, and also change `du0` to be consistent
* `ShampineCollocationInit()`: treat all initial values as guesses and change `u0`/`du0` to be consistent to the DAE definition

Etc. With this, you never need to go "wait, but I set `u0[2] = 2.0...` but the solver then used `u0[2] = 4.0`!", with this change of semanitcs it will never
change values without you declaring that it's a changable guess (and ModelingToolkit.jl then keeps the same semantics, as that's the v10 semantics).  This led to 
hard-to-debug issues where simulations would run but produce physically meaningless results. It was the documented semantics, but if users didn't know this
detail, it can be very difficult for them to figure out why their initial conditions could be ignored. Thus we're prioritizing **correctness and clarity** over 
convenience. The new approach ensures users are aware of initialization requirements and can make informed decisions about their solving strategy.

However... how do we roll this out across the ecosystem?

It just so happened that other changes in the ecosystem made it possible to update the underlying SUNDIALS binary from v5.4 to v7, which itself is already a breaking
change requiring a major. Thus to keep things simple, we have decided to also update the Sundials.jl initialization to its "final form". DifferentialEquations.jl
and OrdinaryDiffEq.jl will soon follow, hopefully before the end of the year.

So with that said... let's get to the changes.

## Major Changes in v5.0

### 1. Safer DAE Initialization by Default

The most significant change affects all users of the IDA solver for DAE problems. The new default behavior validates initial conditions rather than automatically modifying them.

**Before (v4.x):** Automatic initialization could silently change the `u0` parts for the algebraic variables.
```julia
prob = DAEProblem(f, du0, u0, tspan, differential_vars=differential_vars)
sol = solve(prob, IDA())  # Might change `u0` before solving, specifically the algebraic variables by default
```

**After (v5.0):** Explicit initialization choice required
```julia
using DiffEqBase: BrownFullBasicInit

prob = DAEProblem(f, du0, u0, tspan, differential_vars=differential_vars)

sol = solve(prob, IDA()) # Solves with CheckInit, i.e. it fails if `(du0, u0, p, t)` is not consistent

# Option 1: Request automatic initialization of algebraic variables (recommended for most users)
# Automatically changes the part of `u0` for the algebraic variables and all of `du0` to get a consistent set
sol = solve(prob, IDA(), initializealg=BrownFullBasicInit()) 

# Option 2: Request automatic initialization of all variables
# Automatically changes `u0` and `du0` to get a consistent set
sol = solve(prob, IDA(), initializealg=ShampineCollocationInit())
```

### Available Initialization Algorithms

Sundials.jl v5.0 supports multiple initialization strategies through the `initializealg` parameter:

- **`DefaultInit()`**: Intelligently chooses the appropriate algorithm based on your problem
- **`BrownFullBasicInit()`**: Brown's algorithm for index-1 DAEs (requires differential_vars)
- **`ShampineCollocationInit()`**: Shampine's collocation method (works without differential_vars)
- **`CheckInit()`**: Only validates initial conditions without modification

### 2. Upgrade to Sundials v7 C Library

We've upgraded from Sundials v5 to v7, bringing improved performance and new features. This introduces breaking changes for users of the low-level C API:

**Key Change:** All Sundials objects now require a `SUNContext` for thread safety and better resource management.

If you're using the high-level DiffEq interface (`solve(prob, CVODE_BDF())`), **no changes are needed**. The context is managed automatically. However, low-level API users need to update their code:

```julia
# Old (v4.x)
mem_ptr = CVodeCreate(CV_BDF)

# New (v5.0)
ctx_ptr = Ref{SUNContext}(C_NULL)
SUNContext_Create(C_NULL, Base.unsafe_convert(Ptr{SUNContext}, ctx_ptr))
ctx = ctx_ptr[]
mem_ptr = CVodeCreate(CV_BDF, ctx)
# ... use solver ...
SUNContext_Free(ctx)
```

### 3. Enhanced ModelingToolkit Integration

IDA, CVODE and ARKODE now fully support the `initializealg` parameter, enabling seamless integration with ModelingToolkit's parameter initialization system. This is particularly important for large-scale models with complex initialization requirements.

```julia
# Automatic handling of ModelingToolkit initialization
sol = solve(prob, CVODE_BDF())  # Uses DefaultInit() which detects MTK requirements, i.e. OverrideInit()
```

## Migration Guide

### For Most Users

If you're using IDA for DAE problems, you'll need to explicitly specify an initialization algorithm:

1. **Have differential_vars?** Use `BrownFullBasicInit()`:
   ```julia
   sol = solve(prob, IDA(), initializealg=BrownFullBasicInit())
   ```

2. **No differential_vars?** Use `ShampineCollocationInit()`:
   ```julia
   sol = solve(prob, IDA(), initializealg=ShampineCollocationInit())
   ```

3. **Already have consistent initial conditions?** The default `CheckInit()` will validate them

### Error Messages Guide You

If you forget to update your code, you'll receive clear error messages explaining what's needed:

```
DAE initialization failed with CheckInit: Initial conditions do not satisfy the DAE constraints.

Suggestions:
1. Use an initialization algorithm: initializealg = BrownFullBasicInit()
2. Provide consistent initial conditions that satisfy f(du0, u0, p, t0) = 0
```

## Benefits of the New Approach

1. **Safety**: No more silent failures from incorrect automatic initialization
2. **Clarity**: Explicit initialization choices make code more maintainable
3. **Performance**: Skip unnecessary computations when you have consistent initial conditions
4. **Debugging**: Clear error messages when initialization fails
5. **Flexibility**: Choose the best initialization algorithm for your specific problem

## Looking Forward

While breaking changes are never easy, we believe these updates position Sundials.jl for a more robust and reliable future. The explicit initialization approach aligns with best practices in numerical computing: be explicit about your assumptions and requirements.

The upgrade to Sundials v7 also opens doors for future enhancements, including better GPU support and improved parallel solving capabilities that we plan to expose in future releases.

## Acknowledgments

We thank the entire SciML community for their feedback and patience as we worked through these important changes. Special thanks to the Sundials team at LLNL for their continued development of the underlying C library.

If you encounter any issues during migration, please don't hesitate to open an issue on the [Sundials.jl GitHub repository](https://github.com/SciML/Sundials.jl) or ask questions on the [Julia Discourse](https://discourse.julialang.org/) forums.
