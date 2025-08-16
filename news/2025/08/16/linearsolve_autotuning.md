@def rss_pubdate = Date(2025,8,16)
@def rss = """LinearSolve.jl Autotuning: Community-Driven Algorithm Selection for Optimal Performance"""
@def published = " 16 August 2025 "
@def title = "LinearSolve.jl Autotuning: Community-Driven Algorithm Selection for Optimal Performance"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# LinearSolve.jl Autotuning: Community-Driven Algorithm Selection for Optimal Performance

Linear algebra operations form the computational backbone of scientific computing, yet choosing the optimal algorithm for a given problem and hardware configuration remains a persistent challenge. Today, we're excited to introduce **LinearSolveAutotune.jl**, a new community-driven autotuning system that automatically benchmarks and selects the best linear solver algorithms for your specific hardware configuration.

## The Challenge: One Size Doesn't Fit All

LinearSolve.jl provides a unified interface to over 20 different linear solving algorithms, from generic Julia implementations to highly optimized vendor libraries like Intel MKL, Apple Accelerate, and GPU-accelerated solvers. Each algorithm excels in different scenarios:

- **Small matrices (< 100×100)**: Pure Julia implementations like `RFLUFactorization` often outperform BLAS due to lower overhead
- **Medium matrices (100-1000×1000)**: Vendor-optimized libraries like Apple Accelerate and MKL shine
- **Large matrices (> 1000×1000)**: GPU acceleration through Metal or CUDA becomes dominant
- **Sparse matrices**: Specialized algorithms like KLU and UMFPACK are essential

The optimal choice depends on matrix size, sparsity, numerical type, and critically, your specific hardware. An M2 MacBook Pro has very different performance characteristics than an AMD Threadripper workstation with an NVIDIA GPU.

## Enter LinearSolveAutotune: Community-Powered Performance

LinearSolveAutotune addresses this challenge through a unique approach: **collaborative benchmarking with optional telemetry sharing**. Here's how it works:

### 1. Local Benchmarking

Run comprehensive benchmarks on your machine with a simple command:

```julia
using LinearSolve, LinearSolveAutotune

# Run benchmarks across different matrix sizes and types
results = autotune_setup()

# View performance summary
display(results)

# Generate performance visualization
plot(results)
```

The system automatically:
- Tests algorithms across matrix sizes from 5×5 to 15,000×15,000
- Benchmarks Float32, Float64, Complex, and BigFloat types
- Detects available hardware acceleration (GPUs, vendor libraries)
- Measures performance in GFLOPS for easy comparison

### 2. Smart Recommendations

Based on your benchmarks, LinearSolveAutotune generates tailored recommendations for each scenario:

```julia
# Example output from an Apple M2 system:
# ┌─────────────┬──────────────────────────────┐
# │ Size Range  │ Best Algorithm               │
# ├─────────────┼──────────────────────────────┤
# │ tiny (5-20) │ RFLUFactorization            │
# │ small       │ RFLUFactorization            │
# │ medium      │ AppleAccelerateLUFactorization │
# │ large       │ AppleAccelerateLUFactorization │
# │ huge        │ MetalLUFactorization         │
# └─────────────┴──────────────────────────────┘
```

### 3. Community Telemetry (Optional)

The real innovation lies in **opt-in community telemetry**. By sharing your benchmark results, you contribute to a growing database that helps improve algorithm selection heuristics for everyone:

```julia
# Share your results with the community
share_results(results)
```

This creates an automatic GitHub comment on our [results collection issue](https://github.com/SciML/LinearSolve.jl/issues/725) with:
- Your hardware configuration (CPU, GPU, available libraries)
- Performance measurements across all algorithms
- System-specific recommendations
- Beautiful performance visualizations

**Privacy First**: The telemetry system:
- Only shares benchmark performance data
- Never collects personal information
- Requires explicit opt-in via `share_results()`
- Uses GitHub authentication for transparency
- All shared data is publicly visible on GitHub

## Real-World Impact: Performance Gains in the Wild

The community has already contributed benchmarks from diverse hardware configurations, revealing fascinating insights:

### Apple Silicon Optimization
On Apple M2 processors, we discovered that Apple's Accelerate framework delivers exceptional performance for medium-sized matrices, achieving **750+ GFLOPS** for large Float32 matrices. However, for tiny matrices (< 20×20), the pure Julia `RFLUFactorization` is **3-5x faster** due to lower call overhead.

### GPU Acceleration Patterns
Metal acceleration on Apple Silicon shows interesting threshold behavior:
- Below 500×500: CPU algorithms dominate
- 500-5000×5000: Competitive performance
- Above 5000×5000: GPU delivers **2-3x speedup**, reaching over 1 TFLOP

### Complex Number Performance
For complex arithmetic, we found that specialized algorithms matter even more:
- `LUFactorization` outperforms vendor libraries by **2x** for ComplexF32
- Apple Accelerate struggles with complex numbers, making pure Julia implementations preferable

## Using the Results: Automatic Algorithm Selection

The beauty of LinearSolve.jl's autotuning system is that you don't need to manually specify algorithms. The benchmark results from the community directly improve the default heuristics, so you simply use:

```julia
using LinearSolve

# Create your linear problem
A = rand(100, 100)
b = rand(100)
prob = LinearProblem(A, b)

# Just solve - LinearSolve automatically picks the best algorithm!
sol = solve(prob)  # Uses optimized heuristics based on community benchmarks
```

The autotuning results you and others share help LinearSolve.jl make intelligent decisions about:
- When to use pure Julia implementations vs vendor libraries
- Matrix size thresholds for GPU acceleration
- Special handling for complex numbers and sparse matrices

By contributing your benchmark results with `share_results()`, you're directly improving the default algorithm selection for everyone. The more diverse hardware configurations we collect, the smarter the automatic selection becomes.

## Performance Visualization: A Picture Worth 1000 Benchmarks

LinearSolveAutotune generates comprehensive performance visualizations showing:

- **Algorithm comparison plots**: GFLOPS vs matrix size for each algorithm
- **Heatmaps**: Performance across different size ranges and types
- **System information**: Hardware details and available acceleration

Here's an example from recent community submissions showing the dramatic performance differences across algorithms:

```
Metal GPU vs CPU Performance (Apple M2)
┌────────────────────────────────────────────┐
│ 1000 ┤ ▁▁▁▁▁▂▂▃▄▅▆▇█ Metal GPU        │
│      │                                      │
│  500 ┤     ▅▆▇██████ Apple Accelerate     │
│      │   ▂▄████▅▃▂▁                        │
│  100 ┤ ▆████▃▁      Generic LU            │
│      │████▁                                │
│   10 ┤██            RF Factorization      │
│      │                                     │
│    1 └────────────────────────────────────┘
│       10   100   1000   10000              │
│            Matrix Size (n×n)               │
└────────────────────────────────────────────┘
```

## How the Telemetry System Works

The telemetry system is designed with transparency and user control at its core:

1. **Local Execution**: All benchmarks run locally on your machine
2. **Data Generation**: Results are formatted as markdown tables and plots
3. **Authentication**: Uses GitHub OAuth for secure, transparent submission
4. **Public Sharing**: Creates a comment on a public GitHub issue
5. **Community Analysis**: Results feed into improved algorithm selection heuristics

The collected data helps us:
- Identify performance patterns across different hardware
- Improve default algorithm selection
- Discover optimization opportunities
- Guide future development priorities

## Getting Started

Ready to optimize your linear algebra performance? Here's how to get started:

```julia
# Install the packages
using Pkg
Pkg.add(["LinearSolve", "LinearSolveAutotune"])

# Run comprehensive benchmarks
using LinearSolve, LinearSolveAutotune
results = autotune_setup(
    sizes = :all,           # Test all size categories
    types = [Float32, Float64, ComplexF64],
    quality = :high,        # Thorough benchmarking
    time_limit = 60.0      # Limit per-algorithm time
)

# Analyze your results
display(results)
plot(results)

# Optional: Share with the community
share_results(results)
```

## The Road Ahead

LinearSolveAutotune represents a new paradigm in scientific computing: **community-driven performance optimization**. By aggregating performance data across diverse hardware configurations, we can:

- Build better default heuristics that work well for everyone
- Identify performance regressions quickly
- Guide optimization efforts where they matter most
- Create hardware-specific algorithm recommendations

We envision expanding this approach to other SciML packages, creating a comprehensive performance knowledge base that benefits the entire Julia scientific computing ecosystem.

## Join the Community Effort

The success of LinearSolveAutotune depends on community participation. Whether you're running on a laptop, workstation, or HPC cluster, your benchmarks provide valuable data that helps improve performance for everyone.

Visit our [results collection issue](https://github.com/SciML/LinearSolve.jl/issues/725) to see community submissions, and consider running the autotuning suite on your hardware. Together, we're building a faster, smarter linear algebra ecosystem for Julia.

## Acknowledgments

LinearSolveAutotune was developed as part of the SciML ecosystem with contributions from the Julia community. Special thanks to all early adopters who have shared their benchmark results and helped refine the system.

---

*For more information, see the [LinearSolve.jl documentation](https://docs.sciml.ai/LinearSolve/stable/tutorials/autotune/) and join the discussion on [Julia Discourse](https://discourse.julialang.org/c/domain/models/21).*