---
layout: post
title:  "DifferentialEquations.jl v6.9.0: Automated Equation Discovery, SciPy/R Bindings, and Implicit GPU"
date:   2019-11-30 12:00:00
categories:
---

## Automated Discovery of Differential Equations from Data with DataDrivenDiffEq.jl

## SciPy and deSolve (R) Common Interface Bindings for Ease of Translation

## Automated GPU-based Parameter Parallelism Support for Stiff ODEs and Event Handling

## Stiff ODE Linear Solver Performance Improvements

## More Precise Package Maintenance: Strict Versioning and Bounds

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
- High Strong Order Methods for Non-Commutative Noise SDEs
- Stochastic delay differential equations
