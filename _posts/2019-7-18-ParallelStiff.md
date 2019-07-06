---
layout: post
title:  "DifferentialEquations.jl v6.7.0: GPU-based Ensembles and Automatic Sparsity"
date:   2019-7-5 12:00:00
categories:
---

Let's just jump right in! This time we have a bunch of new GPU tools and
sparsity handling.

## Parallelized Implicit Extrapolation of Stiff ODEs

## GPU-Optimized Sparse (Colored) Automatic Differentiation

## Surrogate optimization

## High Strong Order Methods for Non-Commutative Noise SDEs

## Color Differentiation Integration with Native Julia DE Solvers

The `ODEFunction`, `DDEFunction`, `SDEFunction`, `DAEFunction`, etc. constructors
now allow you to specify a color vector. This will reduce the number of `f`
calls required to compute a sparse Jacobian, giving a massive speedup to the
computation of a Jacobian and thus of an implicit differential equation solve.
The color vectors can be computed automatically using the SparseDiffTools.jl
library's `matrix_colors` function. Thank JSoC student Langwen Huang
 (@huanglangwen) for this contribution.

# JuliaCon Hackathon

Please come join the JuliaDiffEq developers at the JuliaCon 2019 Hackathon.
We have a wide range of projects setup to bring in newcommers and experienced
developers alike. These projects include:

- (Newcommer friendly!) Generating suites of test problems for differential
  equations. A list of sources [can be found at the DiffEqProblemLibrary issues](https://github.com/JuliaDiffEq/DiffEqProblemLibrary.jl/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
- (Newcommer friendly!) Make the [DiffEqBenchmarks](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl) more extensive (more methods, more problems)
- Work on solving your own differential equations! If possible, upstream them
  to the benchmarks.
- [Implement Runge-Kutta-Nystrom Integrators](https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl/issues/677)
- Better warning and error message behavior, [including this issue](https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl/issues/801).
- [High weak order Stochastic Runge-Kutta methods](https://github.com/JuliaDiffEq/StochasticDiffEq.jl/issues/182)
- [Implement Gradient/Jacobian/Hessian helper functions in ModelingToolkit](https://github.com/JuliaDiffEq/ModelingToolkit.jl/issues/109)
- [Finish ModelingToolkit automatic sparsity](https://github.com/JuliaDiffEq/ModelingToolkit.jl/issues/133)
- [Symbolic ODE adjoint equations in ModelingToolkit](https://github.com/JuliaDiffEq/ModelingToolkit.jl/issues/137).
- [(Experienced) Transition DiffEqBiological to ModelingToolkit](https://github.com/JuliaDiffEq/ModelingToolkit.jl/issues/143)

And many more. Also, we'll help you start developing whatever areas of DiffEq
you're interested in, so come find us and we'll get you going.

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
