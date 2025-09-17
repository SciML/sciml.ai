@def rss_pubdate = Date(2025,9,17)
@def rss = """Sundials.jl v5.0: Major Update with Breaking Changes for Safer DAE Solving"""
@def published = " 17 September 2025 "
@def title = "Sundials.jl v5.0: Major Update with Breaking Changes for Safer DAE Solving"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Sundials.jl v5.0: Major Update with Breaking Changes for Safer DAE Solving

We're excited to announce the release of **Sundials.jl v5.0**, a major update that brings significant improvements to differential-algebraic equation (DAE) solving, upgrades to the latest Sundials C library, and enhanced integration with the SciML ecosystem. This release includes important breaking changes designed to improve safety, clarity, and performance when solving DAEs.

## Why the Breaking Changes?

After extensive experience with users encountering subtle bugs from automatic DAE initialization, we've made the difficult but necessary decision to change the default behavior. Previously, IDA would silently attempt to compute consistent initial conditions, which could sometimes produce incorrect results without any warning. This led to hard-to-debug issues where simulations would run but produce physically meaningless results.

With v5.0, we're prioritizing **correctness and clarity** over convenience. The new approach ensures users are aware of initialization requirements and can make informed decisions about their solving strategy.

## Major Changes in v5.0

### 1. Safer DAE Initialization by Default

The most significant change affects all users of the IDA solver for DAE problems. The new default behavior validates initial conditions rather than automatically modifying them.

**Before (v4.x):** Automatic initialization could silently produce incorrect results
```julia
prob = DAEProblem(f, du0, u0, tspan, differential_vars=differential_vars)
sol = solve(prob, IDA())  # Might silently compute wrong initial conditions
```

**After (v5.0):** Explicit initialization choice required
```julia
using DiffEqBase: BrownFullBasicInit

prob = DAEProblem(f, du0, u0, tspan, differential_vars=differential_vars)

# Option 1: Request automatic initialization (recommended for most users)
sol = solve(prob, IDA(), initializealg=BrownFullBasicInit())

# Option 2: Provide consistent initial conditions
# Ensure du0 and u0 satisfy f(du0, u0, p, t0) = 0
sol = solve(prob, IDA())  # Will validate and error if inconsistent
```

### Available Initialization Algorithms

Sundials.jl v5.0 supports multiple initialization strategies through the `initializealg` parameter:

- **`DefaultInit()`**: Intelligently chooses the appropriate algorithm based on your problem
- **`BrownFullBasicInit()`**: Brown's algorithm for index-1 DAEs (requires differential_vars)
- **`ShampineCollocationInit()`**: Shampine's collocation method (works without differential_vars)
- **`CheckInit()`**: Only validates initial conditions without modification

### 2. Upgrade to Sundials v7 C Library

We've upgraded from Sundials v6 to v7, bringing improved performance and new features. This introduces breaking changes for users of the low-level C API:

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

CVODE and ARKODE now fully support the `initializealg` parameter, enabling seamless integration with ModelingToolkit's parameter initialization system. This is particularly important for large-scale models with complex initialization requirements.

```julia
# Automatic handling of ModelingToolkit initialization
sol = solve(prob, CVODE_BDF())  # Uses DefaultInit() which detects MT requirements
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

## Getting Started

To upgrade to Sundials.jl v5.0:

```julia
using Pkg
Pkg.update("Sundials")
```

For detailed documentation and examples, visit the [Sundials.jl documentation](https://docs.sciml.ai/Sundials/stable/).

## Acknowledgments

We thank the entire SciML community for their feedback and patience as we worked through these important changes. Special thanks to the Sundials team at LLNL for their continued development of the underlying C library.

If you encounter any issues during migration, please don't hesitate to open an issue on the [Sundials.jl GitHub repository](https://github.com/SciML/Sundials.jl) or ask questions on the [Julia Discourse](https://discourse.julialang.org/) forums.

## Conclusion

Sundials.jl v5.0 represents a significant step forward in DAE solving within the Julia ecosystem. While the breaking changes require some code updates, they ultimately lead to more reliable, maintainable, and correct scientific computing code. We're confident these changes will benefit the community in the long run and look forward to seeing what you build with the improved solver capabilities.