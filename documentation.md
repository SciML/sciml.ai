@def title = "Scientific Machine Learning Software Documentation"

# SciML Scientific Machine Learning Documentation and Tutorials

The SciML organization is an opinionated collection of tools for
scientific machine learning and differential equation modeling. The
organization provides well-maintained tools which compose together
as a coherent ecosystem. The following are the relevant resources for
users interested in the functionality.

## SciML-Wide Documentation

- [The SciML Common Interface](https://devdocs.sciml.ai/latest/)
- [SciMLTutorials](https://github.com/SciML/SciMLTutorials.jl)
- [SciMLBenchmarks](https://github.com/SciML/SciMLBenchmarks.jl)

## Differential Equations

- [DifferentialEquations.jl](https://docs.sciml.ai/latest/)
- [diffeqpy: DifferentialEquations.jl from Python](https://github.com/SciML/diffeqpy)
- [diffeqr: DifferentialEquations.jl from R](https://github.com/SciML/diffeqr)

These resources cover:

- Discrete equations (function maps, discrete stochastic (Gillespie/Markov)
  simulations)
- Ordinary differential equations (ODEs)
- Split and Partitioned ODEs (Symplectic integrators, IMEX Methods)
- Stochastic ordinary differential equations (SODEs or SDEs)
- Random differential equations (RODEs or RDEs)
- Differential algebraic equations (DAEs)
- Delay differential equations (DDEs)
- Mixed discrete and continuous equations (Hybrid Equations, Jump Diffusions)
- (Stochastic) partial differential equations ((S)PDEs) (with both finite
  difference and finite element methods)

## Partial Differential Equation Modeling

- [DiffEqOperators.jl: Finite Difference Methods](https://github.com/SciML/DiffEqOperators.jl)
- [NeuralPDE.jl: Physics-Informed Neural Networks](https://github.com/SciML/NeuralPDE.jl)
- [FEniCS.jl: Finite Element Methods](https://github.com/SciML/FEniCS.jl)

## Nonlinear Systems

- [NonlinearSolve.jl: High-performance and differentiation-enabled Nonlinear Solvers](https://nonlinearsolve.sciml.ai/dev/)

## Optimization

- [GalacticOptim.jl: Differentiable local and global optimizers all in one interface](https://galacticoptim.sciml.ai/dev/)

## Estimation, Inference, and Model Discovery

- [DiffEqFlux.jl: Universal and neural differential equations](https://diffeqflux.sciml.ai/dev/)
- [NeuralPDE.jl: Physics-Informed Nueral Networks](https://github.com/SciML/NeuralPDE.jl)
- [DataDrivenDiffEq.jl: Koopman Operator and Symbolic Regression](https://datadriven.sciml.ai/dev/)
- [DiffEqParamEstim.jl: Easy parameter estimation by maximum likelihood and MAP of differential equations](https://diffeqparamestim.sciml.ai/dev/)
- [DiffEqBayes.jl: Easy Bayesian inference of differential equations](https://diffeqbayes.sciml.ai/dev/)
- [ReservoirComputing.jl: Reservoir computing methods like echo state networks](https://github.com/SciML/ReservoirComputing.jl)

Honorable mention to [Turing.jl](https://turing.ml/dev/), a probabilistic programming
language that composes with the SciML tools.

## Surrogate Acceleration

- [Surrogates.jl: Fast and differentiable surrogates](https://surrogates.sciml.ai/latest/)

## Modeling Languages and Domain-Specific Languages

- [ModelingToolkit.jl: A Composable Modeling and Simulation Environment](https://mtk.sciml.ai/dev/)
- [Catalyst.jl: Fast chemical reaction modeling](https://catalyst.sciml.ai/dev/)
- [ParameterizedFunctions.jl: Easy definition of differential equation functions](https://github.com/SciML/ParameterizedFunctions.jl)
- [NBodySimulator.jl: A differentiable N-body problem simulator for molecular dynamics and forcefield equations](https://github.com/SciML/NBodySimulator.jl)

## Modeling Tools and Primatives

- [MultiScaleArrays.jl](https://github.com/SciML/MultiScaleArrays.jl)
- [LabelledArrays.jl](https://github.com/SciML/LabelledArrays.jl)
- [RecursiveArrayTools.jl](https://github.com/SciML/RecursiveArrayTools.jl)

## Numerical Tools and Primatives

- [ExponentialUtilities.jl: Fast and GPU matrix exponentials](https://github.com/SciML/ExponentialUtilities.jl)
- [Quadrature.jl: Common interface for quadrature and numerical integration](https://github.com/SciML/Quadrature.jl)
- [QuasiMonteCarlo.jl: Quasi-Monte Carlo sampling routines](https://github.com/SciML/QuasiMonteCarlo.jl)
- [SparsityDetection.jl: Automated Jacobian and Hessian sparsity patterns](https://github.com/SciML/SparsityDetection.jl)
- [PoissonRandom.jl: Fast Poisson random numbers](https://github.com/SciML/PoissonRandom.jl)
- [AutoOffload.jl: Automatic GPU, TPU, FPGA, Xeon Phi, Multithreaded, Distributed, etc. offloading](https://github.com/SciML/AutoOffload.jl)

# Developer Documentation

Please see [the developer documentation](http://devdocs.sciml.ai/latest/)
for information on getting started with developing in the SciML organization.
Please see [Colprac](https://github.com/SciML/ColPrac) for the community
development practices.

# External Tutorials and Teaching Materials

- [MIT 18.337J/6.338J: Parallel Computing and Scientific Machine Learning](https://github.com/mitmath/18337)
- [MIT 6.S083/18.S190: Computational thinking with Julia + application to the COVID-19 pandemic](https://github.com/mitmath/6S083)
- [MIT 18.S096 Special Subject in Mathematics: Applications of Scientific Machine Learning](https://github.com/mitmath/18S096SciML)
- [Various implementations of the classical SIR model in Julia](https://github.com/epirecipes/sir-julia)
- [Programming for Mathematical Applications](https://robertsweeneyblanco.github.io/Programming_for_Mathematical_Applications/home.html)
