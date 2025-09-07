@def rss_pubdate = Date(2025,9,7)
@def rss = """SciML Summer 2025 Update: Mixed Precision Solvers, Neural ODE Extensions, and Ecosystem Improvements"""
@def published = " 7 September 2025 "
@def title = "SciML Summer 2025 Update: Mixed Precision Solvers, Neural ODE Extensions, and Ecosystem Improvements"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Summer 2025 Update: Mixed Precision Solvers, Neural ODE Extensions, and Ecosystem Improvements

The SciML ecosystem has seen significant developments over the summer months of 2025, with notable advances in mixed precision linear solving, neural differential equations, GPU support, and package consolidation. This update covers the major new features and improvements from July through September 2025.

## LinearSolve.jl: New Mixed Precision Capabilities

The most significant development has been the introduction of comprehensive mixed precision linear solvers in LinearSolve.jl. This represents a substantial expansion of performance options for scientific computing applications.

### New Mixed Precision Factorization Methods

**Core Mixed Precision Solvers (PR #746):**
- `MKL32MixedLUFactorization`: CPU-based mixed precision using Intel MKL
- `AppleAccelerate32MixedLUFactorization`: CPU-based mixed precision using Apple Accelerate
- `CUDAOffload32MixedLUFactorization`: GPU-accelerated mixed precision for NVIDIA GPUs
- `MetalOffload32MixedLUFactorization`: GPU-accelerated mixed precision for Apple Metal

**Extended Mixed Precision Support (PR #753):**
- `OpenBLAS32MixedLUFactorization`: Mixed precision using OpenBLAS for broader hardware support
- `RF32MixedLUFactorization`: Mixed precision using RecursiveFactorization.jl, optimized for small to medium matrices

**OpenBLAS Direct Support (PR #745):**
- `OpenBLASLUFactorization`: High-performance option that directly calls OpenBLAS_jll, providing an open-source alternative to MKL

### Performance Benefits

These solvers provide:
- **Up to 2x speedup** for memory-bandwidth limited problems
- **Reduced memory usage** during factorization 
- **Hardware acceleration** leveraging GPU offloading and optimized CPU libraries
- **Complex number support** for both real and complex matrices
- **Automatic precision conversion** (Float64/ComplexF64 → Float32/ComplexF32 for computation → Float64/ComplexF64 for results)

### Enhanced Autotune Integration

**Smart Algorithm Selection (PR #730, #733):**
The autotune system now includes mixed precision solvers with intelligent fallback mechanisms:
- **Availability checking**: Verifies algorithms are usable before selecting them
- **Dual preference system**: Stores both "best overall" and "best always-loaded" algorithms  
- **Intelligent fallback**: Gracefully degrades when extensions aren't available

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

## DiffEqFlux.jl: Multidimensional Neural ODE Support

### Extended Multiple Shooting (PR #974)

A significant enhancement to neural differential equations has been the extension of the `multiple_shoot` loss function to support multidimensional NeuralODEs. Previously limited to vector-valued systems, the multiple shooting method now works with:

- **Multidimensional tensors**: State `u` and right-hand sides can be tensor-valued
- **Image-based neural ODEs**: Applications involving spatial-temporal dynamics
- **Higher-dimensional systems**: Complex multiphysics applications

```julia
# Now supports multidimensional NeuralODEs
neural_ode_2d = NeuralODE(Chain(Conv((3,3), 1=>8, tanh), 
                                Conv((3,3), 8=>1, tanh)), 
                          (0.0f0, 1.0f0), Tsit5())

# Multiple shooting works seamlessly with tensor-valued states
loss_multiple_shoot(neural_ode_2d, data_tensor)
```

## NeuralPDE.jl: Enhanced GPU Compatibility

### GPU-Compatible Training (PR #955)

NeuralPDE.jl received important GPU support improvements:

**Initial States Option**: Added `initial_states` option to `Phi` and `PhysicsInformedNN` to enable training models where states must be on the same device as parameters.

**Parameter Handling**: Fixed equation parameter handling to use scalars instead of single-element arrays, resolving GPU compatibility issues.

**ModelingToolkit v10 Compatibility**: Updated imports for compatibility with ModelingToolkit v10.

These changes enable GPU-accelerated training of physics-informed neural networks and neural differential equation models.

## Optimization.jl: Package Consolidation

### OptimizationBase Migration (PR #993)

A major structural improvement was the migration of OptimizationBase.jl as a sublibrary within Optimization.jl:

**Benefits:**
- **Repository consolidation**: Reduces maintenance overhead
- **Simplified dependency management**: OptimizationBase now embedded rather than external
- **Consistent versioning**: Packages released together

**Implementation:**
- Complete source code moved to `lib/OptimizationBase/` 
- All dependencies integrated into main Project.toml
- CI configuration updated for sublibrary testing
- Zero breaking changes to existing APIs

### Sophia Optimizer Improvements (PR #1000)

Fixed compatibility issues between the Sophia optimizer and ComponentArrays when using DifferentiationInterface/Enzyme autodiff. The fix ensures proper shadow type generation for automatic differentiation.

## System Reliability Improvements

### Copy Method Enhancements

**OrdinaryDiffEq.jl - WOperator Copy (PR #2865):**
Added missing `Base.copy` method for `WOperator` types, enabling proper copying of Jacobian operators in stiff ODE solvers.

**NonlinearSolve.jl - Jacobian Operator Copy (PR #691):**
Implemented copy methods for Jacobian operators, improving memory management in iterative nonlinear solvers.

These improvements enhance the robustness of solver caching and memory management across the ecosystem.

## Getting Started with New Features

To explore the new capabilities:

```julia
using Pkg
Pkg.add(["LinearSolve", "LinearSolveAutotune", "DiffEqFlux", "NeuralPDE", "Optimization"])

# Test mixed precision linear solving
using LinearSolve
A = rand(1000, 1000) + 5.0I
b = rand(1000)
prob = LinearProblem(A, b)
sol = solve(prob, MKL32MixedLUFactorization())

# Multidimensional neural ODE
using DiffEqFlux, Flux
dudt = Chain(Conv((3,3), 2=>10, relu), Conv((3,3), 10=>2))
neural_ode = NeuralODE(dudt, (0.0f0, 1.0f0), Tsit5())
```

## Looking Forward

These summer developments strengthen the SciML ecosystem's foundation across several dimensions:

- **Performance**: Mixed precision solvers provide significant speedups for appropriate problems
- **Capability**: Multidimensional neural ODEs enable new application areas
- **Usability**: GPU compatibility improvements lower barriers to accelerated computing
- **Maintainability**: Package consolidation reduces ecosystem complexity

The focus on both algorithmic advances and practical usability improvements reflects the ecosystem's maturation and commitment to serving diverse scientific computing needs.

---

*For detailed technical information and examples, visit the [SciML documentation](https://docs.sciml.ai/) and join discussions on [Julia Discourse](https://discourse.julialang.org/c/domain/models/21).*