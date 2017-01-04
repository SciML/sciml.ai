---
layout: page
title: Packages
navigation_weight: 1
sitemap:
    priority: 1.0
    changefreq: weekly
    lastmod: 2014-09-07T16:31:30+05:30
---

# The Packages

The packages can be split are split categories. The core metapackage which uses
the functionality together is DifferentialEquations.jl. The following documentation
shows how the various components can be used together in DifferentialEquations.jl.
The component solvers are the packages which provide the functionality for actually
solving differential equations, and the add-ons utilize the common solution interface
to provide higher level functionality. Packages for easily specifying
more domain-specific models are included to enhance the scope of the ecosystem.
Lastly, developer tools help researchers create and test high performance algorithms
to add to the ecosystem.

### MetaPackage: DifferentialEquations.jl

[DifferentialEquations.jl](https://github.com/JuliaDiffEq/DifferentialEquations.jl)
is a metapackage which brings together the various parts
of the ecosystem into one cohesive and ready to use powerhouse of differential
equation solving. Using DifferentialEquations.jl, one can perform high level
analysis like parameter estimation and sensitivty analysis, while retaining the
ability to swap out different ODE solvers between different packages.
Offering high-performance native Julia implementations and the well-known
C/Fortran algorithms like Sundials or the Hairer algorithms (through ODEInterface.jl),
the mixture of flexibility and performance is unparalleled. This is combined with
[benchmark-based](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl) algorithms
for choosing default methods and common user interface for handling the solutions
across different domains, easing the user experience while not comprimising performance.

### Documentation Packages

- [DiffEqDocs.jl](http://www.juliadiffeq.org/latest/). The documentation
  for the common interface as provided by DifferentialEquations.jl.
- [DiffEqDevDocs.jl](http://www.juliadiffeq.org/latest/). The
  developer documentation, explaining how to create new components to the diffeq ecoystem.
- [DiffEqTutorials.jl](https://github.com/JuliaDiffEq/DiffEqTutorials.jl). Jupyter
  notebook tutorials explaining how to use various features in the ecosystem.
- [DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl). Benchmarks
  showing the performance differences between the implementations.
- [juliadiffeq.github.com](https://github.com/JuliaDiffEq/juliadiffeq.github.com).
  The JuliaDiffEq website.

### Component Solvers

The solver component packages provide the functionality for solving
differential equations.

- [OrdinaryDiffEq.jl](https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl).
  These Julia implementations offer the largest amount of Julia-specific options,
  while the benchmarks show that these are some of the fastest ODE solver implementations.
- [Sundials.jl](https://github.com/JuliaDiffEq/Sundials.jl). This wrapper to the
  Sundials package of ODE and DAE solvers allows users to use the famous multistep methods.
- [ODE.jl](https://github.com/JuliaDiffEq/ODE.jl). This is a suite of ODE solvers
  inspired by MATLAB.
- [StochasticDiffEq.jl](https://github.com/JuliaDiffEq/StochasticDiffEq.jl). This
  is a suite of stochastic differential equation (SDE) solvers based off of recent
  research to offer highly efficient adaptive timestepping and high strong order methods.
- [DASSL.jl](https://github.com/JuliaDiffEq/DASSL.jl) This is a Julia
  implementation of the famous DASSL DAE solver.
- [DASKR.jl](https://github.com/JuliaDiffEq/DASKR.jl) This is a wrapper to the
  well-known DASKR differential algebraic equatoin (DAE) solver.
- [FiniteElementDiffEq.jl](https://github.com/JuliaDiffEq/FiniteElementDiffEq.jl).
  This package has tools for describing linear finite element meshes and for solving
  Poisson and Heat equation problems.
- [StokesDiffEq.jl](https://github.com/JuliaDiffEq/StokesDiffEq.jl). This package
  has tools for solving the Stationary Stokes Equation.
- [MATLABDiffEq.jl](https://github.com/JuliaDiffEq/MATLABDiffEq.jl). This package has
  bindings for using MATLAB's ODE solvers through the common interface via MATLAB.jl.
  It's restricted to solving ParameterizedFunctions and is mostly for benchmarking.
- [ODEInterfaceDiffEq.jl](https://github.com/JuliaDiffEq/ODEInterfaceDiffEq). This
  package extends ODEInterface.jl to have the common JuliaDiffEq interface.
  This allows one to use classic FORTRAN algorithms like `dopri5` and
  `radau`.

Optionally, the following non-JuliaDiffEq packages can be used through the
JuliaDiffEq common interface:

- [LSODA.jl](https://github.com/rveltz/LSODA.jl). This package wraps the popular
  LSODA algorithm with automatic switching between nonstiff and stiff solvers.

### Add-On Functionality

These packages provide add-on functionality to the differential equation solvers.

- [ParameterizedFunctions.jl](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl).
  ParameterizedFunctions.jl provides an easy way to specify differential equations
  which will auto-compute various enhancements (Jacobians, inverse Jacobians) to
  speed up the differential equations solvers. In addition, it provides a way of
  defining functions with explicit parameters, which gives a way for parameter
  analyses like parameter estimation to be possible.
- [DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl).
  This package links the JuliaDiffEq common interface to the various optimzation
  and machine learning packages in order to provide methods for performing
  parameter estimation.
- [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl).
  This package adds sensitivity analysis to the JuliaDiffEq common interface.
- [DiffEqBifurcate.jl](https://github.com/JuliaDiffEq/DiffEqBifurcate.jl). This
  package adds bifurcation analysis to functions defined as a ParameterizedFunction.
  The core functionality is provided by [PyDSTool.jl](https://github.com/JuliaDiffEq/PyDSTool.jl).
  This is a work in progress.
- [DiffEqUncertainty.jl](https://github.com/JuliaDiffEq/DiffEqUncertainty.jl).
  This component provides uncertainty analysis tools to the JuliDiffEq common interface.
  This is a work in progress.
- [DiffEqOptimalControl.jl](https://github.com/JuliaDiffEq/DiffEqOptimalControl.jl).
  This component provides methods for translating optimal control problems to
  relevant differential equations to be solved by the component solvers. This
  is a work in progress.

### Models Packages

- [FinancialModels.jl](https://github.com/JuliaDiffEq/FinancialModels.jl). This
  package provides an easy way to define the common stochastic differential equations
  found in mathematical finance.
- [MultiScaleModels.jl](https://github.com/JuliaDiffEq/MultiScaleModels.jl). This
  package provides a performant way to define differential equations with a
  changing heirarchical structure. For example, one can define a differential equation
  on the proteins of various cells (of different types), where the proteins change
  continuously (and stochastically) and the cell numbers change discretely.

### Developer Packages

- [DiffEqBase.jl](https://github.com/JuliaDiffEq/DiffEqBase.jl). This package provides
  the core structure of JuliaDiffEq, allowing the packages to offer a standardized
  interface while reducing the dependencies of the components.
- [DiffEqPDEBase.jl](https://github.com/JuliaDiffEq/DiffEqBase.jl). This package provides
  the core structure of the PDE solvers for JuliaDiffEq. It contains the type
  definitions associated with PDEs, the tools for finite element meshes, and
  other utilities which are used to build solvers.
- [DiffEqDevTools.jl](https://github.com/JuliaDiffEq/DiffEqDevTools.jl). This package
  offers various methods for performing convergence analysis, benchmarking, and
  testing of the component solvers. Also included are tableau analysis tools like
  recipes for stability region plots.
- [DiffEqProblemLibrary.jl](https://github.com/JuliaDiffEq/DiffEqProblemLibrary.jl).
  This package provides a set of premade problems for testing the component solvers.
