---
layout: post
title:  "DifferentialEquations.jl v6.8.0: Advanced Stiff Differential Equation Solving"
date:   2019-11-7 12:00:00
categories:
---

This release covers the completion of another successful summer. We have now
completed a new round of tooling for solving large stiff and sparse differential
equations. Most of this is covered in the exciting....

## New Tutorial: Solving Stiff Equations for Advanced Users!

That is right, we now have a new tutorial added to the documentation on
[solving stiff differential equations](http://docs.juliadiffeq.org/latest/tutorials/advanced_ode_example.html).
This tutorial goes into depth, showing how to use our recent developments to
do things like automatically detect and optimize a solver with respect to
sparsity pattern, or automatically symbolically calculate a Jacobian from a
numerical code. This should serve as a great resource for the advanced users
who want to know how to get started with those finer details like sparsity
patterns and mass matrices.

## Automatic Colorization and Optimization for Structured Matrices

As showcased in the tutorial, if you have `jac_prototype` be a structured matrix,
then the `colorvec` is automatically computed, meaning that things like
`BandedMatrix` are now automatically optimized. The default linear solvers make
use of their special methods, meaning that DiffEq has full support for these
structured matrix objects in an optimal manner.

## Implicit Extrapolation and Parallel DIRK for Stiff ODEs

At the tail end of the summer, a set of implicit extrapolation methods were
completed. We plan to parallelize these over the next year, seeing what can
happen on small stiff ODEs if parallel W-factorizations are allowed.

## Automatic Conversion of Numerical to Symbolic Code with Modelingtoolkitize

This is just really cool and showcased in the new tutorial. If you give us a
function for numerically computing the ODE, we can now automatically convert
said function into a symbolic form in order to compute quantities like the
Jacobia and then build a Julia code for the generated Jacobian. Check out the
new tutorial if you're curious, because although it sounds crazy... this is
now a standard feature!

## GPU-Optimized Sparse (Colored) Automatic and Finite Differentiation

SparseDiffTools.jl and DiffEqDiffTools.jl were made GPU-optimized, meaning that
the stiff ODE solvers now do not have a rate-limiting step at the Jacobian
construction.

## DiffEqBiological.jl: Homotopy Continuation

DiffEqBiological got support for automatic bifurcation plot generation by
connecting with HomotopyContinuation.jl. See [the new tutorial](https://github.com/JuliaDiffEq/DiffEqBiological.jl#making-bifurcation-diagram)

## Greatly improved delay differential equation solving

David Widmann (@devmotion) greatly improved the delay differential equation
solver's implicit step handling, along with adding a bunch of tests to show
that it passes the special RADAR5 test suite!

## Color Differentiation Integration with Native Julia DE Solvers

The `ODEFunction`, `DDEFunction`, `SDEFunction`, `DAEFunction`, etc. constructors
now allow you to specify a color vector. This will reduce the number of `f`
calls required to compute a sparse Jacobian, giving a massive speedup to the
computation of a Jacobian and thus of an implicit differential equation solve.
The color vectors can be computed automatically using the SparseDiffTools.jl
library's `matrix_colors` function. Thank JSoC student Langwen Huang
 (@huanglangwen) for this contribution.

## Improved compile times

Compile times should be majorly improved now thanks to work from David
Widmann (@devmotion) and others.

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
- High Strong Order Methods for Non-Commutative Noise SDEs
- Stochastic delay differential equations
