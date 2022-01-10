@def rss_pubdate = Date(2022,1,10)
@def rss = """DifferentialEquations.jl v7: New linear solver and preconditioner interface"""
@def published = " 10 January 2021 "
@def title = "DifferentialEquations.jl v7: New linear solver and preconditioner interface"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# DifferentialEquations.jl v7: New linear solver and preconditioner interface

An update is long overdue and this is a really nice one! DifferentialEquations.jl
v7 has been released, the first major version since 2019! We note that, as a
major version, this does indicate breaking API changes have been introduced.
That said, they are relatively minor and only involve the linear solver interface,
which is the main topic of this release post.

## LinearSolve.jl: A common interface for linear solvers



## Preconditioner Interface

## Greatly Improved Static Array Performance in OrdinaryDiffEq.jl

## Differential-Algebraic Equation (DAE) Solver Benchmarks

## New Documentation Tutorial on Code Optimization for DifferentialEquations

## Preconditioner Examples with Sundials.jl

## Greatly Improved Startup Times

## Integro-Differential Equations with NeuralPDE.jl

## Other and Upcoming Updates

There are many other updates to be aware of which we will highlight in future
news posts. As a quick overview:

- Massive improvements to ModelingToolkit.jl with mixed discrete+continuous
  system handling.
- GalacticOptim.jl received some major improvements and overhauled documentation
  over the last round. It now wraps nearly 100 optimization methods from 13
  libraries into its common interface.
- ExponentialUtilities.jl received a new `exponential!` method with greatly
  improved matrix exponential performance over Julia's Base.
- PreallocationTools.jl received many cosmetic updates to be easier to use.
- Many performance improvements to DiffEqSensitivity.jl and DiffEqFlux.jl
- The new library StructuralIdentifiability.jl for computing the structural
  identifiability of parameters in ODE models will be announced in the next
  round. A few issues are still being worked out over the next month.
- The new library MethodOfLines.jl for automating method of lines discretizations
  will be announced shortly. Currently it's in a beta mode.
- The new library ModelingToolkitStandardLibrary.jl has been created. This will
  in a beta mode for a bit longer as it fleshes out its offering.
- SymbolicNumericIntegration.jl was released and will be included in the next
  release notes.
- MinimallyDisruptiveCurves.jl was released and will be included in the next
  release notes.
