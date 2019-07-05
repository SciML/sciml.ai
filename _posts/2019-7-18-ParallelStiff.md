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

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
