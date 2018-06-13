---
layout: post
title:  "DifferentialEquations.jl 4.6: Global Sensitivity Analysis, Variable Order Adams"
date:   2018-7-5 10:00:00
categories:
---

Tons of improvements due to Google Summer of Code. Here's what's happened.

## Global Sensitivty Analysis (Morris, Sobol)

GSoC student Vaibhav Dixit (@Vaibhavdixit02) added global sensitivity analysis
(GSA) methods to DiffEqSensitivity.jl. GSA quantifies the effects of the
parameters on the solution of the ODE. The implementation of these methods
are on any generic `f(p)`, so this may be refactored into an external non-DiffEq
library. The Morris method and the Sobol method, two of the most commonly used
GSA methods, are part of this implementation. Other methods, such as FAST,
eFAST, etc. are coming soon.

## Variable time step variable order Adams methods (VCABM)

GSoC student Shubham Maddhashiya (@sipah00) added a variable-coefficient form
implementation of the variable order variable time step Adams-Bashforth-Moulton
method. This implementation matches the classic DDEABM software of Shampine
which specializes in its ability to utilize the higher orders for larger time
steps and high efficiency on less stiff equations. Our benchmarks show efficiency
improvements over DDEABM, making it a good native Julia replacement to that
classic method for large non-stiff ODE systems.

# In development

A lot of the next developments will come from our GSoC students. Here's a list
of things we are aiming for:

- `SABDF2`, which is a strong order 0.5 adaptive BDF2 implementation for
  stochastic differential equations which is order 2 for small noise SDEs.
  This will be the first implicit adaptive integrator for small noise SDEs and
  will be a great choice for SPDEs.

- Yiannis Simillides (@ysimillides) keeps making improvements to FEniCS.jl. At
  this part a large portion (a majority?) of the tutorial works from Julia.
  Integration with native Julia tools like Makie.jl is in progress.

- Mikhail Vaganov (@Mikhail-Vaganov) is making good progress on his N-body
  modeling language. This will make it easy to utilize DiffEq as a backend
  for molecular dynamics simulation. Follow the progress in DiffEqPhysics.jl

And here's a quick view of the rest of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX methods
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface

# Projects

Are you a student who is interested in working on differential equations software
and modeling? If so, please get in touch with us since we may have some funding
after August for some student developers to contribute towards some related goals.
It's not guaranteed yet, but getting in touch never hurts!
