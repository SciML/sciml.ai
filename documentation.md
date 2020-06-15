---
layout: page
title: Documentation
navigation_weight: 1
sitemap:
    priority: 1.0
    changefreq: yearly
    lastmod: 2014-09-07T16:31:30+05:30
---
# Documentation and Tutorials

The SciML organization is an opinionated collection of tools for
scientific machine learning and differential equation modeling. The
organization provides well-maintained tools which compose together
as a coherent ecosystem. The following are the relevant resources for
users interested in the functionality.

## Differential Equations

- [DifferentialEquations.jl documentation](https://docs.sciml.ai/latest/)
- [DiffEqTutorials](https://github.com/SciML/DiffEqTutorials.jl)
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

- [DiffEqOperators.jl (Finite Difference Methods)](https://github.com/SciML/DiffEqOperators.jl)
- [NeuralNetDiffEq.jl (Physics-Informed Neural Networks)](https://github.com/SciML/NeuralNetDiffEq.jl)
- [FEniCS.jl](https://github.com/SciML/FEniCS.jl)

## Scientific Machine Learning Model Discovery

- [DiffEqFlux.jl documentation](https://diffeqflux.sciml.ai/dev/)
- [NeuralNetDiffEq.jl](https://github.com/SciML/NeuralNetDiffEq.jl)
- [DataDrivenDiffEq.jl documentation](https://datadriven.sciml.ai/dev/)
- [ReservoirComputing.jl](https://github.com/SciML/ReservoirComputing.jl)

## Surrogate Acceleration and Optimization

- [Surrogates.jl documentation](https://surrogates.sciml.ai/latest/)

## Modeling Languages and Domain-Specific Languages

- [ModelingToolkit.jl documentation](https://mtk.sciml.ai/dev/)
- [DiffEqBiological.jl](https://github.com/SciML/DiffEqBiological.jl)
- [ParameterizedFunctions.jl](https://github.com/SciML/ParameterizedFunctions.jl)
- [NBodySimulator.jl](https://github.com/SciML/NBodySimulator.jl)

## Modeling Tools and Primatives

- [MultiScaleArrays.jl](https://github.com/SciML/MultiScaleArrays.jl)
- [LabelledArrays.jl](https://github.com/SciML/LabelledArrays.jl)
- [RecursiveArrayTools.jl](https://github.com/SciML/RecursiveArrayTools.jl)

## Numerical Tools and Primatives

- [ExponentialUtilities.jl: Fast and GPU matrix exponentials](https://github.com/SciML/ExponentialUtilities.jl)
- [Quadrature.jl: Common interface for quadrature and numerical integration](https://github.com/SciML/Quadrature.jl)
- [QuasiMonteCarlo.jl](https://github.com/SciML/QuasiMonteCarlo.jl0)
- [SparsityDetection.jl: Automated Jacobian and Hessian sparsity patterns](https://github.com/SciML/SparsityDetection.jl)
- [PoissonRandom.jl: Fast Poisson random numbers](https://github.com/SciML/PoissonRandom.jl)
- [AutoOffload.jl: Automatic GPU, TPU, FPGA, Xeon Phi, Multithreaded, Distributed, etc. offloading](https://github.com/SciML/AutoOffload.jl)

# Developer Documentation

Please see [the developer documentation](http://devdocs.sciml.ai/latest/)
for information on getting started with developing in the SciML organization.

# External Applications

There are many external libraries which connect and utilize SciML
utilities under the hood. The following an incomplete list of software
organizations providing domain modeling tools that are built upon
SciML:

- [CliMA: Climate Modeling Alliance](https://clima.caltech.edu/)
- [QuantumOptics](https://qojulia.org/)
- [New York Federal Reserve Bank](https://frbny-dsge.github.io/DSGE.jl/latest/)
- [Julia Robotics](https://juliarobotics.org/)
- [Pumas-AI: Pharmaceutical Modeling and Simulation](https://pumas.ai/)
- [Brazilian National Institute for Space Research (INPE)](https://github.com/JuliaSpace/SatelliteToolbox.jl)
- [CMU+MIT+Citrine: Accelerated Computational Electrochemical Systems Discovery (ACED)](https://www.cmu.edu/aced/)
