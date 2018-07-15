---
layout: post
title:  "DifferentialEquations.jl 4.7: v0.7, Jacobian Types, EPIRK"
date:   2018-7-15 10:00:00
categories:
---

Tons of improvements due to Google Summer of Code. Here's what's happened.

## v0.7 Compatibility

JuliaDiffEq is now considered to be on Julia v0.7. The most of the libraries
have had a compatibility update release and now the master branches are being
developed for v0.7. This means that all new features will be Julia v0.7-only,
but v0.6 versions should continue to work. A lot of help came from GSoC student
Yingbo Ma (@YingboMa).

## Jacobian Types: Sparse, Banded, etc.

## 5th (Stiff) Order EPIRK Methods

The EPRIK methods are a form of exponential integrator which works on
any first order ODE and utilizes an adaptive Krylov method for efficient
calculations of non-autonomous linear subproblems to approximate the solution.
These methods can handle large stiff equations like PDE discretizations due to
their stability properties, and the efficiency of the Krylov scheme has had
recent ODE solver literature suggest that these could be some of the most
efficient methods on large ODEs. this time around GSoC student Xingjian Guo
(@MSeeker1340) added the 5th order methods, the highest order (and potentially
most efficient) EPIRK methods which have been derived. We are the first ODE
solver ecosystem to incorporate EPIRK methods  into our suite, and so we will
be performing some extensive testing to see if these claims hold. If they do,
this would be a major efficiency gain to many potential DiffEq users.

## Functional initial conditions and timespans

This is a feature that has been slated to be added for a long time. Now the initial
condition to your differential equation problems do not have to just be constant
values. For example, you can give a function `u0(p,t0)` and this will be evaluated
using the parameters and starting time point in order to generate the `u0` as
necessary. Additionally, if `u0` returns a `Distributions.jl` distribution, a solution
will be taken by sampling from the initial distribution. By using this setup we
will be able to do things like track sensitivity to initial condition in local
sensitivity schemes. This has been a long requested feature and therefore we
are happy to have a solution which is able to apply this similarly to all of the
solvers.

The structures that this allows may be more important than the feature itself.
This was an often requested feature by library developers who wanted alternative
APIs. For example, this allows you to pass a single number for the timespan
and have it expand to `(0,X)`. `nothing` timespans are allowed and then a
user must pass a timespan at the `solve` command. Additionally, passing an
algorithm via `alg` will place it into the dispatching `solve(prob,alg;kwargs...)`
position automatically, helping package authors handle this common case where
it's lumped into the splatted kwargs passed down to an internal DiffEq call
(note it needs to be a positional algorithm for the dispatch mechanism to work,
so at least as of Julia v1.0 it cannot be a keyword argument in general but
this will allow it to act like one).

Additionally, this let's us place a global type-checking system. There are some
known type trip-ups which can occur. For example, using an adaptive ODE
algorithm is incompatible with time as integers. If you use an adaptive ODE
algorithm with initial conditions being dual numbers, you need time to be
in dual numbers as well. The infrastructure of this change allows us to throw
warnings in these cases to alert users to potential problems. By mixing this
with Requires.jl, we can alert problems due to interactions with 3rd party
packages as well, which will allow the informal knowledge about package ecosystem
interactions to get formally encoded and automatically utilized. We hope that
this will increase the usability of the software.

## Quasi-Constant Stepsize Variable Order BDF and NDF Integrators

GSoC student Shubham Maddhashiya (@sipah00)

## Stabilized-Explicit Methods

Stabilized explicit methods are explicit Runge-Kutta methods with high stage
numbers that are chained together to give a stable method for semi-stiff
differential equations. New contributor Yongfei Tan (@tyfff) implemented
our first stabilized explicit method, the `ROCK2` algorithm. Since these are
chained Runge-Kutta methods, no linear algebra is involved meaning that these
methods can be compatible with all of the features that the basic Runge-Kutta
methods are, giving us an easy avenue to support units, arbitrary array types,
etc. in a method for stiff ODEs. These methods are also low storage: instead
of storing the Jacobian O(n^2) (unless sparse Jacobians are specified), these
methods store O(n) by default, allowing them to be a nice default for large
stiff systems when no sparsity structure is defined (and a dense Jacobian would
not fit into memory). This is an exciting area!

# In development

A lot of the next developments will come from our GSoC students. Here's a list
of things we are aiming for:

- Variable coefficient IMEX BDF (SBDF) integrators. Both fixed and variable order.

- Fixed Leading Coefficient (FLC) form Nordsieck BDF integrators.

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
- LSODA integrator interface

# Projects

Are you a student who is interested in working on differential equations software
and modeling? If so, please get in touch with us since we may have some funding
after August for some student developers to contribute towards some related goals.
It's not guaranteed yet, but getting in touch never hurts!
