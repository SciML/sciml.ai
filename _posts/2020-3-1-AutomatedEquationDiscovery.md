---
layout: post
title:  "DifferentialEquations.jl v6.12.0: Automated Equation Discovery and Native DAEs"
date:   2019-12-3 12:00:00
categories:
---

Oh boy this is a big release. It made it hard to contemplate what should go
into the main title: should it be the fact that we have fully native implicit
ODE (i.e. DAE) solvers, or the fact that **you can give us data and we can give
you back LaTeX for the equation that generated the data**? Both are title-worthy,
and both are in this release. Let's dig right into it.

## Automated Discovery of Differential Equations from Data with DataDrivenDiffEq.jl

Give us timeseries data, and we will give you a TeX'd equation for the differential
equations that generated the data. Driven by Julius Martensen (@AlCap23), the
new DataDrivenDiffEq.jl module makes this a reality. Automatically learn equations
with SInDy or develop linear approximations to differential equations directly
from data with Koopman operator approaches like Extended Dynamic Mode Decomposition
(eDMD). For more information on doing this, consult
[the new documentation page on structural estimation](https://docs.juliadiffeq.org/latest/analysis/structural_estimation/)

## Native DAE Solvers in OrdinaryDiffEq.jl

## High Strong Order Methods Non-Commutative Noise SDEs

# Next Directions

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Stochastic delay differential equations
