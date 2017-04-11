---
layout: post
title:  "DifferentialEquations.jl API Changes"
date:   2017-4-7 1:30:00
categories:
---

# API Changes

This post is to detail the API changes that are happening in the DifferentialEquations.jl
ecosystem. Most of them should not be very disruptive, but are things that you
should take notice of.

## `save_timeseries` changed to `save_everystep`

Many users were confused about what the `save_timeseries` argument did, so it
was changed to `save_everystep`. Now it's clear that it means that every internal
solver step is counted for saving. This can still be controlled by `timeseries_steps`
to skip integer numbers of intervals.

## `saveat` => no `save_everystep`

Before, `save_everystep` always defaulted to true. However, this tripped up many
users who were interested in saving the output at specific timepoints: why would
the solver give me points I wasn't asking for when I was already saying what I
wanted?

To fix this, the default for `save_everystep` was changed to be whether `isempty(saveat)`.
The result is that

```julia
sol = solve(prob,alg,saveat=save_timepoints)
```

is equivalent to what used to be

```julia
sol = solve(prob,alg,saveat=save_timepoints,save_everystep=false)
```

Note that you can recover the previous default behavior by explicitly setting
`save_everystep=true`:

```julia
sol = solve(prob,alg,saveat=save_timepoints,save_everystep=true)
```

We believe that this default should be more sensible to most users.

## `saveat` using Numbers

A common usage for `saveat` is to get out an evenly-spaced grid. For example,
`0.0:0.1:1.0` if you want 10 evenly-spaced points. Actually, that has some floating
point issues, so we thought it would be better to help you out.

```julia
sol = solve(prob,alg,saveat=0.1)
```

will now make the solver save at `tspan[1]:0.1:tspan[2]` timepoints. This should
be a nice shorthand for a very standard operation.

## `save_idxs`

A new argument was added which allows you to choose which indices to save. So far
this is only implemented in the `*DiffEq` packages (OrdinaryDiffEq.jl, StochasticDiffEq.jl,
DelayDiffEq.jl), but can be made compatible with other solvers as well (please open
and issue if you would like to have this in Sundials.jl or other packages. Or a
PR! This isn't a difficult change!). For example:

```julia
sol = solve(prob,alg,saveat=0.1,save_idxs=1:2:5)
```

will save an array of three values (dependent variables 1, 3, and 5) at each
`0.1` points in time. Note this can be used without `saveat`.

## `save_start`

Another new output control. `save_start` notes whether the initial condition should
be appended to the start of the solution type. This defaults as true, and most of
the solver packages implement this option.

## Callbacks in problems

The problem types now can hold callbacks. This is to associate some behavior like
events with the problem instead of the integrator. They do not act differently,
and are just a `callback` keyword argument in the problem types.

# New Features

## EulerHeun and RKMil interpretation

The `EulerHeun` method is our first SDE method for Stratonovich differential equations.
We note that Ito vs Stratonovich is a difference in  the interpretation of the integral,
not in the SDE itself. Thus there is no switch for "choosing" Ito vs Stratonovich
(or whatever else), instead it's just noted in the docs for which interpretation
the integration technique converges.

For some methods, there are ways to make a different version compatible with different
interpreations. So for example, we have in development an `interpretation` syntax
for `RKMil`, where `RKMil(interpretation=:Stratonovich)` converges with first-order
in the Stratonovich sense (defaults to `:Ito`). We hope to extend our support as
time progresses.

## Non-Diagonal Noise

We finally accept a form of non-diagonal noise. For SDEs, you can give a
`noise_rate_prototype` which will be the array for the `du` slot in the SDE's
noise function `g`. This defaults to `nothing`, which will make `du` and array
whose geometry matches `u` and does diagonal noise, that is `du.*dW`. However,
when you specify `du`, it changes it do the standard form for noise: `du*dW`.
This allows for commutative and non-commutative noise by specifying the array
to be a matrix like `noise_rate_prototype=rand(n,m)` where `m` is the Ito dimension
(number of independent Brownian motions), and it will automatically generate `dW`
as a vector of size `m`.

Importantly, this works on any `AbstractMatrix`. So for example, if your reactions
are sparse on the vector `dW`, you can choose `noise_rate_prototype=sparse(A)`,
some sparse matrix `A` which has the correct set of non-zeros for your problem,
and then `du` will be that sparse matrix. Even special forms for the matrix,
like `Tridiagonal`, are accepted. This means you can specify this in a way that
is suitable to your problem yet retain efficiency by using specialized matrix
types.

Currently only `EM` and `EulerHeun` are compatible with non-diagonal noise,
but this area should be growing.

## NoiseProcess Improvements

A `NoiseProces` is how you create colored noise in the SDE and RODE problems.
In fact, it's general enough to create any noise process! The noise process just
needs a function which can use the `integrator` to generate the noise. For example,

```julia
noise_func(integrator) = randn()
noise_func(x::Tuple,integrator) = randn(x)
noise_func(rand_vec,integrator) = randn!(rand_vec)
```

are the functions used in defining `WHITE_NOISE`, the default. But you can change
this around however you please!

## RODEs

Random Ordinary Differential Equations (RODEs) are a rapidly growing area where,
for some stochsatic process `y(t)`, you have a differential equation:

```julia
u' = f(t,u,y)
```

It can be shown that, under certain assumptions, SDEs are a form of RODE. There is
a new problem type and our first integrator, `RandomEM()`, which is the random
Euler-Maruyama method. If no `NoiseProcess` is given, then `y(t)` defaults to
white noise, and this converges to the Ito interpretation of the random integral.

More methods to come. One thing which will help will be the release of Kloeden's
new book on methods for RODEs. This has the same compatibility throughout the
ecosystem as SDEs, so it works for things like parameter estimation. We hope this
exciting and one of a kind feature helps your research take new and interesting
directions!
