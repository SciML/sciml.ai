---
layout: page
title: Home
navigation_weight: 1
sitemap:
    priority: 1.0
    changefreq: weekly
    lastmod: 2014-09-07T16:31:30+05:30
---
# JuliaDiffEq

JuliaDiffEq is a Github organization created to unify the packages for solving differential
equations in Julia. By providing a diverse set of tools with a common interface,
we provide a modular, easily-extendable, and highly
performant ecosystem for solving various forms of differential equations.

## Getting Started

To get started, check out the documentation for [DifferentialEquations.jl](https://juliadiffeq.github.io/DiffEqDocs.jl/dev/index.html)
which pulls all of the functionality into one convenient package. If you need help,
feel free to ask questions [in the chatroom](https://gitter.im/JuliaDiffEq/Lobby)
or [file an issue at the Github repository](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues).
We will be happy to help you get accustomed to our ecosystem.

## What We Offer

- **High performance tools**. Our tools include both wrappers to popular C/Fortran
  solvers and native Julia implementations. Our Julia implementations in many
  cases [benchmark as faster than the class Fortran methods!](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl)
- **The largest set of algorithms**. [From the ODE methods alone](https://juliadiffeq.github.io/DiffEqDocs.jl/dev/solvers/ode_solve.html),
  choose between methods such as the 14th Order Feagin methods, the recent Verner
  Efficient methods with high order interpolations, or the classic dopri methods.
  We offer all of the bells and whistles: high-order symplectic methods, 
  highly efficient Rosenbrock methods for stiff ODEs and DAEs, high-order adaptive 
  methods for stochastic differential equations, strong stability presurving (SSP)
  Runge-Kutta methods for Hyperbolic PDEs, etc. The included set dwarfs what is 
  presented by other ecosystems.
- **A clean user interface**. For the different types of equations, users define a Problem
  type, and call solve. The Solution type which solve creates then acts similarly
  for all types of equations, and includes conveniences like an array interface
  (`sol[i]` for the ith timepoint), an interpolation interface (`sol(t)` for the
  solution interpolated at time t), and a plotting interface (`plot(sol)`).
- **Compatibility with a wide array of Julia-defined number types**. Packages such as
  OrdinaryDiffEq.jl allow for solving differential equations with arbitrary precision
  numbers, unit-checking arithmetic, n-dimensional tensors, complex numbers, and more.
- **Interactivity and flexibility**. The "integrator interface" along with the callbacks
  and event handling frameworks are highly flexible, allowing one to solve complicated
  equations like hybrid dynamical systems involving both discrete and continuous variables,
  and stochastic jump equations, by extending the solvers as necessary.
- **Automatic symbolic enhancements**. [ParameterizedFunctions.jl](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl)
  provides an easy way to specify differential equations and will automatically
  symbolically calculate items such as Jacobians and inverted Jacobians which
  will further increase the speed of the methods.
- **Integration with the Julia Package Ecosystem**. JuliaDiffEq is highly tied
  to the Julia package ecosystem, using it to provide advanced plotting, automatic
  differentiation, iterative solvers, and much more.
- **Newest research in differential equations**. The various component solvers
  contain new algorithms to accelerate the solution to your problems. OrdinaryDiffEq.jl
  allows for specifying `CompositeAlgorithm`s with chosen switching behaviors.
  StochasticDiffEq.jl's solvers include very recent research tools including
  higher-order methods and highly efficient adaptive timestepping. DelayDiffEq.jl
  includes new methods for stiff equations and high accuracy.
- **Add-ons for high level functionality**. Easily perform parameter estimation,
  sensitivity analysis, bifurcation analysis, and much more.
- **Tools for algorithm development and research**. These tools make JuliaDiffEq
  not only be the easiest ecosystem to use, but also the easiest ecosystem for developers to target.
  Using the convergence analysis and benchmarking tools, algorithms can be tested
  against the full JuliaDiffEq suite for easy comparison.
