@def rss_pubdate = Date(2025,9,7)
@def rss = """New Mixed Precision Linear Solvers: Revolutionary Performance for Scientific Computing"""
@def published = " 7 September 2025 "
@def title = "New Mixed Precision Linear Solvers: Revolutionary Performance for Scientific Computing"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# New Mixed Precision Linear Solvers: Revolutionary Performance for Scientific Computing

The SciML ecosystem has achieved a major breakthrough with the introduction of comprehensive mixed precision linear solvers in LinearSolve.jl. This development, spanning multiple PRs from August 2025, fundamentally transforms performance possibilities for memory-bandwidth limited scientific computing applications, delivering up to **2x speedups** while maintaining accuracy for well-conditioned problems.

## Revolutionary Mixed Precision Linear Solvers

The centerpiece of these developments is a comprehensive suite of new mixed precision LU factorization methods introduced in **PR #746** and extended in **PR #753**. These solvers perform computations in Float32 precision while maintaining Float64 interfaces, providing significant performance improvements for memory-bandwidth limited problems.

### New Mixed Precision Factorization Methods

**Core Mixed Precision Solvers (PR #746):**
- `MKL32MixedLUFactorization`: CPU-based mixed precision using Intel MKL
- `AppleAccelerate32MixedLUFactorization`: CPU-based mixed precision using Apple Accelerate
- `CUDAOffload32MixedLUFactorization`: GPU-accelerated mixed precision for NVIDIA GPUs
- `MetalOffload32MixedLUFactorization`: GPU-accelerated mixed precision for Apple Metal

**Extended Mixed Precision Support (PR #753):**
- `OpenBLAS32MixedLUFactorization`: Mixed precision using OpenBLAS for broader hardware support
- `RF32MixedLUFactorization`: Mixed precision using RecursiveFactorization.jl, optimized for small to medium matrices

### Key Features and Benefits

These new solvers deliver:
- **Transparent precision conversion**: Automatically converts Float64/ComplexF64 to Float32/ComplexF32 for factorization
- **Up to 2x performance improvements** for large, well-conditioned matrices
- **Reduced memory usage** during factorization (critical for memory-bandwidth limited problems)
- **Hardware acceleration**: Leverages GPU offloading and optimized CPU libraries
- **Complex number support**: Handles both real and complex matrices seamlessly

## Using Mixed Precision Linear Solvers: Practical Examples

### Direct Linear System Solving

The new mixed precision solvers can be used directly for linear systems where memory bandwidth is a bottleneck:

```julia
using LinearSolve

# Create a large, well-conditioned linear system
A = rand(2000, 2000) + 5.0I  # Adding identity ensures good conditioning
b = rand(2000)
prob = LinearProblem(A, b)

# Solve with different mixed precision methods
# Intel MKL (if available)
sol_mkl = solve(prob, MKL32MixedLUFactorization())

# Apple Accelerate (macOS)
sol_apple = solve(prob, AppleAccelerate32MixedLUFactorization())

# OpenBLAS (cross-platform)
sol_openblas = solve(prob, OpenBLAS32MixedLUFactorization())

# RecursiveFactorization (pure Julia, optimized for small-medium matrices)
using RecursiveFactorization
sol_rf = solve(prob, RF32MixedLUFactorization())

# GPU acceleration (if hardware available)
sol_cuda = solve(prob, CUDAOffload32MixedLUFactorization())  # NVIDIA
sol_metal = solve(prob, MetalOffload32MixedLUFactorization()) # Apple Silicon
```

### Mixed Precision in ODE Solving

The real power of mixed precision linear solvers becomes apparent when used within ODE solvers for stiff problems. Here's how to leverage them in differential equation solving:

```julia
using OrdinaryDiffEq, LinearSolve

# Define a stiff ODE system (e.g., chemical kinetics)
function stiff_ode!(du, u, p, t)
    # Example: stiff chemical reaction system
    k1, k2, k3 = p
    du[1] = -k1*u[1] + k2*u[2]
    du[2] = k1*u[1] - k2*u[2] - k3*u[2]
    du[3] = k3*u[2]
end

# Problem setup
u0 = [1.0, 0.0, 0.0]
tspan = (0.0, 10.0)
p = [10.0, 5.0, 1.0]  # Stiff parameters
prob = ODEProblem(stiff_ode!, u0, tspan, p)

# Solve with mixed precision linear solver for the internal linear systems
# This is particularly effective for large systems where the Jacobian factorization
# dominates computational cost
sol = solve(prob, Rodas5P(linsolve=MKL32MixedLUFactorization()))

# Compare with different mixed precision choices
sol_openblas = solve(prob, Rodas5P(linsolve=OpenBLAS32MixedLUFactorization()))
sol_rf = solve(prob, Rodas5P(linsolve=RF32MixedLUFactorization()))
```

### Advanced Mixed Precision Configuration

For maximum performance, you can fine-tune mixed precision choices based on matrix properties:

```julia
# For smaller systems (< 500×500), RecursiveFactorization often excels
small_system_solver = RF32MixedLUFactorization()

# For larger systems, choose based on available hardware
if Sys.isapple()
    large_system_solver = AppleAccelerate32MixedLUFactorization()
elseif CUDA.functional()
    large_system_solver = CUDAOffload32MixedLUFactorization()
else
    large_system_solver = MKL32MixedLUFactorization()
end

# Use in ODE solving with adaptive choice
function solve_with_mixed_precision(prob, n_vars)
    if n_vars < 500
        linsolve = small_system_solver
    else
        linsolve = large_system_solver
    end
    
    solve(prob, Rodas5P(linsolve=linsolve))
end
```

## Enhanced Autotune Integration

**PR #730** and related improvements have revolutionized how LinearSolve.jl automatically selects optimal algorithms. The autotune system now includes mixed precision solvers and provides intelligent fallback mechanisms:

### Smart Algorithm Selection

```julia
using LinearSolve, LinearSolveAutotune

# Run comprehensive benchmarking including mixed precision options
benchmark_and_set_preferences!()

# After benchmarking, the default solver automatically uses the best available algorithm
A = rand(1000, 1000)
b = rand(1000)
prob = LinearProblem(A, b)

# This now automatically chooses the optimal solver (potentially mixed precision)
# based on your hardware and the autotuning results
sol = solve(prob)  # Could internally use MKL32MixedLUFactorization if it's fastest
```

### Availability Checking and Fallback

The enhanced autotune system (**PR #733**) now includes:
- **Availability checking**: Verifies algorithms are actually usable before selecting them
- **Dual preference system**: Stores both "best overall" and "best always-loaded" algorithms
- **Intelligent fallback**: Gracefully degrades when extensions aren't available

## Performance Impact

The mixed precision solvers show significant performance benefits:

- **Memory bandwidth limited problems**: Up to 2x speedup
- **Large well-conditioned matrices**: Substantial memory usage reduction
- **GPU offloading**: Leverages specialized hardware acceleration
- **Iterative algorithms**: Particularly beneficial where moderate precision is acceptable

## OpenBLAS Direct Support

**PR #745** added `OpenBLASLUFactorization` as a new high-performance option that directly calls OpenBLAS_jll, providing an excellent open-source alternative to MKL with identical interfaces.

## Getting Started

To explore these new mixed precision capabilities:

```julia
using Pkg
Pkg.add(["LinearSolve", "LinearSolveAutotune", "RecursiveFactorization"])

# Run autotuning to find the best solvers for your hardware
using LinearSolve, LinearSolveAutotune
benchmark_and_set_preferences!()

# Your subsequent LinearSolve.jl usage will automatically benefit from
# optimal algorithm selection, including mixed precision where beneficial
```

## Future Directions

This mixed precision foundation enables exciting future developments:
- **Adaptive precision**: Dynamic precision selection based on problem conditioning
- **Multi-level precision**: Different precisions for different stages of computation
- **Extended hardware support**: Integration with emerging accelerator architectures

The introduction of comprehensive mixed precision linear solvers represents a major step forward for the SciML ecosystem, delivering both immediate performance benefits and a foundation for future innovations in scientific computing.

---

*For detailed technical information and examples, visit the [SciML documentation](https://docs.sciml.ai/) and join discussions on [Julia Discourse](https://discourse.julialang.org/c/domain/models/21).*