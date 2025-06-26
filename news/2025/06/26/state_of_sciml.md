@def rss_pubdate = Date(2025,5,23)
@def rss = """State of the SciML Open Source Software Ecosystem, 2025"""
@def published = " 26 June 2025 "
@def title = "State of the SciML Open Source Software Ecosystem, 2025"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# State of the SciML Open Source Software Ecosystem, 2025

*This blog post is a comprehensive summary of the presentation ["State of SciML"](https://www.youtube.com/watch?v=SZZ0lT8DVRo) given at JuliaCon 2024. The original slides can be found at [https://figshare.com/articles/presentation/State_of_SciML_JuliaCon2024_/26299429](https://figshare.com/articles/presentation/State_of_SciML_JuliaCon2024_/26299429).*

As we enter 2025, the SciML Open Source organization has evolved into the world's most comprehensive ecosystem for scientific machine learning and differential equation solving. This technical report provides a detailed overview of our current state, recent achievements, and roadmap for the future.

## What is the SciML Open Source Organization?

The SciML Open Source organization is a non-profit organization, part of the NumFOCUS affiliate libraries, which builds and supports the development of packages in Julia, Python, and R for scientific simulation and scientific machine learning.

### Current Scale and Impact

- **Over 100 GitHub repositories**, many containing 10+ packages themselves
- **Totals ~200 Julia packages**, all MIT open source licensed
- **20,000+ GitHub stars** across the package ecosystem
- **~100+ unique contributors monthly** (variable month to month)
- **~20 core maintainers** owning specific aspects of the project
- **~5-10 summer students and other trainees per year**

### Community Structure

Our community includes many maintainers from the ~20 folks associated with the MIT Julia Lab (and alumni). Multiple companies have spun off (PumasAI, JuliaHub, Neuroblox, etc.) which "house" maintainers with full-time jobs related to their contributions. We submit ~10 grant applications per year related to expanding the SciML organization, usually to MIT though sometimes facilitated through contributor commercial entities or to the non-profit itself.

**Scope Note:** This report covers approximately ¼ of the organization's work due to the breadth of our activities. We hope to start a recurring series that better tracks these updates.

## SciML Ecosystem Architecture

The SciML ecosystem is built around composable interfaces with comprehensive documentation for differentiable simulation. Our organization spans multiple interconnected areas:

**Domain-Specific Modeling Tools:** QuantumCumulants, OrbitalTrajectories, Catalyst, ModelingToolkitStandardLibrary, ModelingToolkit, Symbolics

**Analysis Capabilities:** GlobalSensitivity, EasyModelAnalysis, SciMLExpectation, StructuralIdentifiability, BifurcationKit

**Machine Learning Integration:** ReservoirComputing, Surrogates, QuasiMonteCarlo for sampling methods

**Core Equation Solving:** NonlinearSolve, Integrals, LinearSolve, StochasticDelayDiffEq, JumpProcesses, DifferentialEquations, DelayDiffEq, StochasticDiffEq, OrdinaryDiffEq

**Inverse Problems and Simulation:** DiffEqBayes, SciMLSensitivity, DiffEqParamEstim, DiffEqGPU, Sundials, MethodsofLines, DataDrivenDiffEq, NeuralPDE, DiffEqFlux

**Third-Party PDE Solvers Integration:** Trixi, Gridap, ApproxFun, VoronoiFVM

**Automatic Differentiation:** Enzyme, ReverseDiff, ForwardDiff

**External Ecosystem Connections:** Evolutionary, JuMP, BlackBoxOptim, MathOptInterface, Flux, Lux

*Comprehensive ecosystem diagram created by maintainers Torkel Lohman and Vaibhav Dixit*

## Common Interface for Julia Equation Solvers

SciML provides a unified interface across all major equation types:

```julia
# Linear Systems
LinearSolve.jl          # A(p)x = b

# Nonlinear Systems  
NonlinearSolve.jl       # f(u,p) = 0

# Differential Equations
DifferentialEquations.jl # u' = f(u,p,t)

# Integration
Integrals.jl            # ∫[lb to ub] f(t,p)dt

# Optimization
Optimization.jl         # minimize f(u,p)
                        # subject to g(u,p) ≤ 0, h(u,p) = 0
```

## Maturity Level Classification System

SciML practices open science, with all development and research done in the open. While some libraries are nearly 10 years old and battle-hardened by hundreds of thousands of researchers, others are brand-new research projects. We've established a maturity classification:

**High Maturity** - Battle-hardened libraries with well-defined interfaces, comprehensive error handling, extensive real-world testing, full documentation, and training materials.

**Medium Maturity** - Recently mature libraries with full feature sets, robust numerical testing against classical implementations, and well-documented core methods, but potentially lacking refined error messages or advanced documentation.

**Low Maturity** - Libraries in heavy development with major version updates planned. Core methods documented with tutorials, but extensive features may be under-documented with known edge cases.

**Research** - Effectively unreleased libraries under development for early adopters and contributors.

## Organization Timeline: From 2015 to 2025

### The Early Years (2015-2017)

**2015**: First versions of differential equation solvers written as MATLAB+C code, targeting Intel Xeon Phi accelerators

**2016**: First translation into Julia, established as the JuliaDiffEq organization with DifferentialEquations.jl

**2017**: First workshop at JuliaCon Berkeley, start of Pumas. Catalyst.jl (then DiffEqBiological.jl), ParameterizedFunctions.jl (early ModelingToolkit) created. SciMLBenchmarks established.

### Growth and Academic Integration (2018-2019)

**2018**: Analysis tools launched (global sensitivity analysis, SciMLExpectations, uncertainty quantification). Reverse-mode automatic differentiation and adjoint method integration. Tools spun out into widely-used Julia packages (RecursiveArrayTools.jl, FiniteDiff.jl, PreallocationTools.jl)

**2019**: Chris joins MIT Mathematics, growing the MIT Julia Lab. Universal differential equations and differentiable programming popularized. DiffEqFlux.jl released. PumasAI founded. ChainRules.jl integrated throughout SciML.

### Organizational Expansion (2020-2021)

**2020**: Renamed to SciML, extending beyond differential equations. SciML Book released from MIT 18.337. Non-differential equation solver packages started. Development practices refined through PumasAI regulatory compliance work.

**2021**: Chris becomes VP at JuliaHub, JuliaSim project starts. ModelingToolkit achieves hierarchical acausal model capability. Symbolics.jl spun out as full CAS. Early Enzyme integration.

### Maturation and Performance (2022-2023)

**2022**: Organization reworked for static compilability, reducing first-time-to-solve from 30 seconds to 0.1 seconds. Documentation and error messages improved. Lux.jl spun out. Interface definitions standardized.

**2023**: Global SciML documentation released. Core solver packages reach DifferentialEquations.jl completeness level. PDE tooling reaches relative maturity on structured grids. Focus restructured towards Lux.jl.

### Current State (2024-2025)

**2024**: SciML Small Grants program launched. Kernel-based GPU solvers released. EnzymeRules integration established. JuliaSim GUI released. Global allocation-free and anti-dynamism checking for AOT compilation.

**2025 Planned**: Symbolic-Numeric PDE tooling for unstructured grids. Better Trixi.jl/Ferrite.jl integration. Full Makie integration. Major Optimization.jl improvements including automated convex optimization. Enhanced embedded device and WebAssembly support.

## Numerical Solvers: The Foundation

### DifferentialEquations.jl: Battle-Tested Excellence

**Current Maturity Level: High**

DifferentialEquations.jl remains our cornerstone, providing unified interfaces for ODEs, SDEs, DDEs, DAEs, and hybrid systems.

#### Key Milestones

**2016**: Initial release with major features (event handling, type-generic, high-performance). High-order adaptive SDE algorithms.

**2017**: Split into separate solver packages (OrdinaryDiffEq.jl, StochasticDiffEq.jl, DelayDiffEq.jl, Sundials.jl). Core Julia solvers win non-stiff ODE benchmarks using new Tsit and Vern methods + PI adaptivity.

**2018-2019**: Large-scale stiff ODE functionality. SDIRK, IMEX, Radau, exponential integrators. AutoSwitch stiffness detection. Automatic sparsity support for large-scale PDEs.

**2021-2022**: FBDF and QNDF competitive with Sundials. Parallel extrapolation methods achieve top performance on <200 equation stiff ODEs. DAE initialization with specialized event handling.

**2023**: Kernel GPU methods outperform JAX and PyTorch by 20x-100x for GPU ensemble parallelization.

#### 2024 Achievements

- Major performance improvements for implicit methods on large equations
- NonlinearSolve.jl integration into core solvers
- OrdinaryDiffEq.jl restructuring for improved compile times
- Default ODE solver reworked for full type-stability with maintained dynamism

#### 2025 Roadmap

- New solvers research targeting 2x-6x non-stiff equation performance improvements
- NonlinearSolve.jl becomes default nonlinear solving method
- OrdinaryDiffEq v7 release with improved AOT compilation
- AllocCheck and DispatchDoctor/JET enforcement for runtime-free compilation
- DifferentiationInterface.jl integration with forward-mode Enzyme as default

### OrdinaryDiffEq.jl v7: Addressing Scale Challenges

A critical issue: OrdinaryDiffEq.jl has grown to ~10MB of code. Our solution:

**Modularization Strategy:**
- Split into solver sub-libraries not instantiated by default
- Example: `ImplicitEulerBarycentricExtrapolation` requires `using OrdinaryDiffEqImplicitExtrapolation` (**only breaking change**)
- Solver-specific dependencies for faster installation/loading
- Precompilation on specific sub-libraries
- Common algorithms (Tsit5, VernX) get dedicated sub-libraries
- Restructure: OrdinaryDiffEqCore.jl, OrdinaryDiffEqImplicitCore.jl, with OrdinaryDiffEq.jl as default collection

### Other Core Solver Packages

**Current Maturity Level: Transitioning Medium-High**

Our unified solver ecosystem includes LinearSolve.jl, NonlinearSolve.jl, Integrals.jl, and Optimization.jl.

#### Historical Development

**2016-2017**: Started with external dependencies (Roots.jl, NLsolve.jl), then developed bespoke internal systems.

**2019**: RecursiveFactorization.jl becomes fastest pure Julia LU factorization for matrices <200x200. Suitesparse KLU integration for sparse ODEs.

**2020-2021**: Individual packages established (Integrals.jl as Quadrature.jl, NonlinearSolve.jl, LinearSolve.jl). Organization scope expanded.

**2022-2023**: Packages matured with ChainRules integration for specialized automatic differentiation.

#### 2024 Progress

- NonlinearSolve.jl gained iteration functionality for DifferentialEquations.jl backend
- EnzymeRules interfaces added (Integrals.jl pending)
- SimpleX solvers made GPU kernel compilation compatible

#### 2025 Goals

- DifferentiationInterface.jl integration for improved sparsity handling
- ParU integration into LinearSolve.jl
- Higher-order nonlinear solvers research
- Static compilation guarantees across all solvers

### Optimization.jl: Advancing Toward Maturity

**Current Maturity Level: Low → Medium (2025 target)**

#### Evolution Timeline

**2017-2020**: From DiffEqParamEstim.jl targeting multiple packages, through DiffEqFlux.jl polyalgorithm, to GalacticOptim.jl unified interface.

**2021-2023**: Renamed to Optimization.jl. MathOptInterface.jl bindings for JuMP ecosystem. IPOPT support. ModelingToolkit integration. NonlinearSolve.jl integration for least squares. PRIMA derivative-free methods. Sparse Hessian and Enzyme support.

#### 2024 Achievements

- Automated structure analysis (DCP and DGCP) for convex optimization
- ModelingToolkit tearing optimizations for symbolic-numeric simplifications
- Augmented-Lagrangian with LBFGS-B implementation (no solver subpackages required)
- Interface stabilization with improved testing and error messages

#### 2025 Medium Maturity Goals

- Complete convex optimization interface leveraging MOI's set interface
- Multi-objective problems interface
- JuliaSimCompiler targeting for large-scale symbolic code generation
- Enhanced ML workflow support with minibatching and GPU compatibility
- SciML-native nonlinear optimizers based on LineSearch.jl and NonlinearSolve.jl
- ChainRules and EnzymeRules interfaces for differentiable optimization

## Symbolic Modeling Interfaces

### ModelingToolkit.jl Ecosystem: Symbolic-Numeric Integration

**Current Maturity Level: Low-Medium**

ModelingToolkit.jl serves as our acausal modeling framework for automatically parallelized scientific machine learning, featuring a computer algebra system for physics-informed machine learning and automated differential equation transformations.

#### Development History

**2016-2018**: From ParameterizedFunctions.jl with SymEngine backend, through DiffEqBiological with macro-based DSL, to first ModelingToolkit.jl versions trying multiple symbolic backends before building internal engine.

**2019-2020**: Solved staged-compilation issues with GeneralizedGenerated.jl/RuntimeGeneratedFunctions.jl. PDESystem added for MethodOfLines and NeuralPDE.jl. Became backend for Catalyst, Pumas, and other tools.

**2021**: Acausal model support with Pantelides algorithm for DAE index reduction, tearing, alias elimination. Chosen as JuliaSim backend. Symbolics.jl spun out. StructuralIdentifiability.jl created. SBML, CellML, BioNetGen import added.

**2022**: NonlinearSystem, OptimizationSystem, SDESystem support. General System type for automatic mathematical form detection. Partial state selection algorithms. ModelOrderReduction.jl prototypes. EasyModelAnalysis.jl created.

**2023**: JuliaSimCompiler released with loop regeneration optimizations. Direct LLVM and C compilation for embedded devices. Catalyst reaches high maturity.

#### 2024 Major Release - ModelingToolkit v9

- SymbolicIndexingInterface established and deployed organization-wide
- Initialization interface and clocking system for hybrid systems
- Neural network integration via array functions in symbolic interfaces
- JuliaSimCompiler optimizations for multibody systems
- BaseModelica import capabilities

#### 2025 Technical Priorities

- ModelOrderReduction.jl completion for symbolic-numeric PDE optimizations
- Unstructured grid PDE interface support with NeuralPDE.jl integration
- Ferrite.jl and Trixi.jl integration as PDE auto-discretizers
- Major JuliaSimCompiler performance improvements
- Advanced symbolic-numeric projects for enhanced performance

### Symbolics.jl: The CAS Foundation

**Current Maturity Level: Low**

#### Development Timeline

**2020**: Bespoke symbolic tooling developed in ModelingToolkit.jl after SymEngine, SymPy, and REDUCE couldn't meet SciML's performance and feature requirements.

**2021**: Symbolics.jl spun out as independent library. Rule-based simplifiers with sophisticated type system for automating commutative/distributive optimizations. Metadata system for lightweight symbolic variables.

**2022**: Unityper sum type representation rewrite reduced dynamism and improved performance. SymbolicNumericIntegration.jl created. Symbolic array machinery developed.

**2023**: Array function registration. Groebner.jl extensions and other CAS tooling connections for polynomial reductions. SymPy translation extensions.

#### 2024 Performance Revolution

- Major performance improvements via reduced dynamism
- Closed sum type representation optimization
- Eliminated default sorting overhead  
- Hash consing implementation

#### 2025/2026 Medium Maturity Goals

- Symbolic tensor calculus implementation
- Symbolic equation solvers (nonlinear equations, integrals, basic ODEs)
- Enhanced numerical method integration

## Machine Learning Integration

### SciML Differentiable Programming

**Current Maturity Level: Medium**

We've established ourselves as the leader in differentiable programming for scientific computing, with comprehensive adjoint method support and automatic differentiation.

#### Development History

**2018-2019**: DiffEqSensitivity.jl established with forward/adjoint differentiation for ODEs. Tracker.jl and ReverseDiff.jl integration for vector-Jacobian product optimizations.

**2020**: DiffEqFlux.jl released with concrete_solve interface automating adjoint method use when solvers detected in loss functions. Dispatching adjoint system for multiple optimization types created.

**2021**: DiffEqFlux.jl's bespoke interface removed as ChainRules support enabled "normal" ODE solver code automatic handling. Event handling and shadowing methods for chaotic systems. Early Enzyme integration and ReverseDiff tape-compilation for JIT optimizations.

**2022**: Renamed to SciMLSensitivity.jl with NonlinearProblem, SteadyStateProblem differentiation support. Documentation overhaul. Enzyme as behind-the-scenes default vjp choice.

**2023**: GaussAdjoint created for improved memory performance. Enhanced error handling and interface checking.

#### 2024 Milestone Achievement

- Published comprehensive review article: "Differentiable Programming for Differential Equations"
- EnzymeRules integration enabling automatic Enzyme to SciMLSensitivity.jl routing
- Enhanced performance and memory optimization

The review article provides comprehensive adjoint method analysis with detailed performance comparisons across ReverseDiffAdjoint, TrackerAdjoint, Forward sensitivity equations, Backsolve adjoint, Interpolating adjoint, Quadrature adjoint, and Gauss adjoint methods, comparing stability, performance complexity, and memory usage.

#### 2025 Priorities

- Documentation overhaul favoring Enzyme and DifferentiationInterface
- Asynchronous checkpointing for large-scale problems
- DAE and SDE adjoint performance improvements

### Deep Learning Libraries: The Lux.jl Revolution

**Current Maturity Level: Medium-High**

#### Strategic Migration from Flux.jl to Lux.jl

SciML completed a major transition, fully replacing Flux.jl with Lux.jl in all documentation and examples, delivering significant improvements in error messages, correctness testing, and performance.

#### Timeline of Innovation

**2018**: Flux.jl adoption as core deep learning library

**2020**: FastChain development for specialized SciML performance needs in DiffEqFlux.jl

**2021**: SimpleChains.jl creation by PumasAI for small neural networks in UDE applications. Outperforms JAX by 15x with multithreading for sufficiently small systems.

**2022**: Lux.jl and LuxDL organization established based on FastChain fully explicit function interface, extending to all NNlib/Flux layers.

**2023**: Lux.jl maturation and full Flux replacement in SciML documentation, leading to major improvements in error messages, correctness testing, and performance.

**2024**: Joint Lux.jl/Enzyme.jl development for neural network support.

#### 2024-2025 Integrations

- NeuralOperators.jl rewrite using Lux-based architectures
- Planned Lux.jl integration with Reactant.jl for automated kernel fusion

## What Was Intentionally Skipped

Due to time and scope constraints, many significant areas were not covered in this report:

**Analysis libraries** (GlobalSensitivity.jl, StructuralIdentifiability.jl, EasyModelAnalysis.jl)

**Uncertainty quantification libraries** (SciMLExpectations.jl, PolyChaos.jl)

**Jump processes** (JumpProcesses.jl, Catalyst.jl, integrations in StochasticDiffEq.jl for tau-leaping)

**SciML PDE solvers** (HighDimPDE.jl, NeuralPDE.jl, NeuralOperators.jl)

**SciML architecture tools** (Surrogates.jl, DiffEqFlux.jl, DeepEquilibriumNetworks.jl, etc.)

**Core numerical libraries** (DataInterpolations.jl, ExponentialUtilities.jl, QuasiMonteCarlo.jl, etc.)

**High level interfaces** (SymbolicIndexingInterface, TermInterface, ArrayInterface, SciMLOperators, etc.)

**Parallelism / GPUs**

Every library received only brief highlights for a year's worth of changes. Many connection and "partner libraries" (BifurcationKit.jl, ControlSystems.jl, DynamicalSystems.jl, etc.) that we work extensively with were not included.

**Coverage**: Approximately ¼ of the organization's state is represented here. Follow-up discussions will cover additional areas.

---

## Looking Forward

As we progress through 2025, SciML continues pushing the boundaries of scientific computing, combining Julia's performance with cutting-edge research in scientific machine learning, symbolic computation, and differentiable programming. Our commitment to open science ensures these advanced capabilities remain accessible to the global research community while maintaining the performance and reliability required for production use.

The SciML ecosystem has successfully demonstrated that high-performance scientific computing, modern machine learning, and user-friendly interfaces can coexist in a single, coherent framework. We remain at the forefront of computational science, driving innovation in scientific simulation and machine learning integration.