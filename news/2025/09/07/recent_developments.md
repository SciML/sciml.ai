@def rss_pubdate = Date(2025,9,7)
@def rss = """Mixed Precision Linear Solvers and Enhanced BLAS Integration in LinearSolve.jl"""
@def published = " 7 September 2025 "
@def title = "Mixed Precision Linear Solvers and Enhanced BLAS Integration in LinearSolve.jl"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Mixed Precision Linear Solvers and Enhanced BLAS Integration in LinearSolve.jl

LinearSolve.jl has received a major expansion of its solver capabilities over the summer of 2025, with the introduction of comprehensive mixed precision linear solvers and enhanced BLAS library integration. These developments provide significant performance improvements for memory-bandwidth limited problems while expanding hardware support across different platforms.

## Mixed Precision Linear Solvers

The centerpiece of these developments is a comprehensive suite of mixed precision LU factorization methods that perform computations in Float32 precision while maintaining Float64 interfaces. This approach provides significant performance benefits for well-conditioned, memory-bandwidth limited problems.

### New Mixed Precision Factorization Methods

**Core Mixed Precision Solvers (PR #746):**
- `MKL32MixedLUFactorization`: CPU-based mixed precision using Intel MKL
- `AppleAccelerate32MixedLUFactorization`: CPU-based mixed precision using Apple Accelerate
- `CUDAOffload32MixedLUFactorization`: GPU-accelerated mixed precision for NVIDIA GPUs
- `MetalOffload32MixedLUFactorization`: GPU-accelerated mixed precision for Apple Metal

**Extended Mixed Precision Support (PR #753):**
- `OpenBLAS32MixedLUFactorization`: Mixed precision using OpenBLAS for cross-platform support
- `RF32MixedLUFactorization`: Mixed precision using RecursiveFactorization.jl, optimized for small to medium matrices

### How Mixed Precision Works

All mixed precision solvers follow the same pattern:
1. **Input**: Accept Float64/ComplexF64 matrices and vectors
2. **Conversion**: Automatically convert to Float32/ComplexF32 for factorization
3. **Computation**: Perform LU factorization in reduced precision
4. **Solution**: Convert results back to original precision (Float64/ComplexF64)

This approach reduces memory bandwidth requirements and can provide up to **2x speedups** for large, well-conditioned matrices while maintaining reasonable accuracy (typically within 1e-5 relative error).

## Enhanced BLAS Library Integration

Alongside mixed precision capabilities, LinearSolve.jl has significantly expanded its direct BLAS library support, providing users with more high-performance options.

### OpenBLAS Direct Integration (PR #745)

**OpenBLASLUFactorization**: A new high-performance solver that directly calls OpenBLAS_jll routines without going through libblastrampoline:

- **Optimal performance**: Direct calls to OpenBLAS for maximum efficiency
- **Cross-platform**: Works on all platforms where OpenBLAS is available
- **Open source alternative**: Provides MKL-like performance without proprietary dependencies
- **Pre-allocated workspace**: Avoids allocations during solving

```julia
using LinearSolve

A = rand(1000, 1000)
b = rand(1000)
prob = LinearProblem(A, b)

# Direct OpenBLAS usage
sol = solve(prob, OpenBLASLUFactorization())
```

### BLIS Integration Enhancement (PR #733)

**BLISLUFactorization** has been integrated into the default algorithm selection system:

- **Automatic availability**: Included in autotune benchmarking when BLIS is available
- **Smart selection**: Can be automatically chosen as optimal solver for specific hardware
- **Fallback support**: Graceful degradation when BLIS extension isn't loaded

## Enhanced Autotune Integration

The autotune system has been significantly enhanced to incorporate the new mixed precision and BLAS solvers with intelligent algorithm selection.

### Smart Algorithm Selection (PR #730, #733)

**Availability Checking**: The system now verifies that algorithms are actually usable before selecting them:
- Checks if required libraries (MKL, OpenBLAS, BLIS) are available
- Verifies GPU functionality for CUDA/Metal solvers
- Gracefully falls back to always-available methods when extensions aren't loaded

**Dual Preference System**: Autotune can now store both:
- `best_algorithm_{type}_{size}`: Overall fastest algorithm (may require extensions)
- `best_always_loaded_{type}_{size}`: Fastest among always-available methods

**Intelligent Fallback Chain**:
1. Try best overall algorithm → if available, use it
2. Fall back to best always-loaded → if available, use it  
3. Fall back to existing heuristics → guaranteed available

This ensures optimal performance when extensions are available while maintaining robustness when they're not.

### Algorithm Integration

All new solvers are now integrated into the default algorithm selection:

```julia
using LinearSolve, LinearSolveAutotune

# Benchmark includes all new mixed precision and BLAS methods
benchmark_and_set_preferences!()

# Default solver automatically uses best available algorithm
A = rand(1000, 1000)  
b = rand(1000)
prob = LinearProblem(A, b)
sol = solve(prob)  # May internally use OpenBLAS32MixedLUFactorization, BLISLUFactorization, etc.
```

## Practical Examples

### Direct Linear System Solving

```julia
using LinearSolve

# Create a large, well-conditioned linear system
A = rand(2000, 2000) + 5.0I  # Well-conditioned matrix
b = rand(2000)
prob = LinearProblem(A, b)

# Mixed precision solvers - up to 2x speedup for memory-bandwidth limited problems
sol_mkl = solve(prob, MKL32MixedLUFactorization())                    # Intel MKL
sol_apple = solve(prob, AppleAccelerate32MixedLUFactorization())      # Apple Accelerate  
sol_openblas = solve(prob, OpenBLAS32MixedLUFactorization())          # OpenBLAS
sol_rf = solve(prob, RF32MixedLUFactorization())                      # RecursiveFactorization

# GPU acceleration (if available)
sol_cuda = solve(prob, CUDAOffload32MixedLUFactorization())           # NVIDIA
sol_metal = solve(prob, MetalOffload32MixedLUFactorization())         # Apple Silicon

# Direct BLAS integration
sol_openblas_direct = solve(prob, OpenBLASLUFactorization())          # Direct OpenBLAS calls
```

### Mixed Precision in ODE Solving

Mixed precision linear solvers are particularly effective in ODE solvers for stiff problems where Jacobian factorization dominates computational cost:

```julia
using OrdinaryDiffEq, LinearSolve

# Stiff ODE system
function stiff_ode!(du, u, p, t)
    k1, k2, k3 = p
    du[1] = -k1*u[1] + k2*u[2]
    du[2] = k1*u[1] - k2*u[2] - k3*u[2]
    du[3] = k3*u[2]
end

u0 = [1.0, 0.0, 0.0]
prob = ODEProblem(stiff_ode!, u0, (0.0, 10.0), [10.0, 5.0, 1.0])

# Use mixed precision for internal linear systems
sol = solve(prob, Rodas5P(linsolve=MKL32MixedLUFactorization()))
```

### Hardware-Adaptive Algorithm Selection

```julia
# Choose solver based on available hardware and matrix size
function choose_solver(matrix_size)
    if matrix_size < 500
        RF32MixedLUFactorization()  # Optimized for small-medium matrices
    elseif Sys.isapple()
        AppleAccelerate32MixedLUFactorization()
    elseif CUDA.functional()
        CUDAOffload32MixedLUFactorization()
    else
        OpenBLAS32MixedLUFactorization()  # Cross-platform fallback
    end
end

solver = choose_solver(size(A, 1))
sol = solve(prob, solver)
```

## Performance Characteristics

### Mixed Precision Benefits

- **Memory bandwidth limited problems**: Up to 2x speedup
- **Large matrices**: Significant memory usage reduction during factorization
- **Well-conditioned systems**: Maintains accuracy within 1e-5 relative error
- **Complex number support**: Works with both real and complex matrices

### OpenBLAS/BLIS Integration Benefits

- **Cross-platform performance**: High-performance computing without proprietary dependencies
- **Direct library calls**: Bypasses intermediate layers for optimal efficiency  
- **Automatic selection**: Integrated into autotune benchmarking system
- **Fallback support**: Graceful degradation when libraries aren't available

## Getting Started

```julia
using Pkg
Pkg.add(["LinearSolve", "LinearSolveAutotune"])

# Run comprehensive benchmarking
using LinearSolve, LinearSolveAutotune
benchmark_and_set_preferences!()  # Includes all new mixed precision and BLAS methods

# Automatic optimal solver selection
A = rand(1000, 1000) + I
b = rand(1000)
prob = LinearProblem(A, b)
sol = solve(prob)  # Uses best available solver based on benchmarking
```

## Looking Forward

The introduction of mixed precision linear solvers and enhanced BLAS integration represents a significant expansion of LinearSolve.jl's capabilities:

- **Performance**: New algorithmic approaches for memory-bandwidth limited problems
- **Hardware support**: Broader platform coverage with OpenBLAS and BLIS integration
- **Usability**: Intelligent algorithm selection reduces user burden
- **Ecosystem integration**: Seamless integration with ODE solvers and other SciML packages

These developments provide both immediate performance benefits and establish a foundation for future mixed precision innovations across the SciML ecosystem.

---

*For detailed technical information and examples, visit the [SciML documentation](https://docs.sciml.ai/) and join discussions on [Julia Discourse](https://discourse.julialang.org/c/domain/models/21).*