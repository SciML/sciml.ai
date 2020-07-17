@def rss_pubdate = Date(2017,4 ,30 )
@def rss = """ DifferentialEquations.jl 2.0. """
@def published = "30 April 2017  "
@def title = " DifferentialEquations.jl 2.0 "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


This marks the release of ecosystem version 2.0. All of the issues got looked
over. All (yes all!) of the API suggestions that were recorded in issues in
JuliaDiffEq packages have been addressed! Below are the API changes that have occurred.
This marks a really good moment for the JuliaDiffEq ecosystem because it means all
of the long-standing planned API changes are complete. Of course new things may come
up, but there are no more planned changes to core functionality. This means that we can simply
work on new features in the future (and of course field bug reports as they come).
A blog post detailing our full 2.0 achievements plus our 3.0 goals will come out at
our one year anniversary. But for now I want to address what the API changes are,
and the new features of this latest update.

The main changes in 2.0 is that this finishes a lot of the fundamental design of
DiffEq. Many new problems were added, and the existing problems were modified
to accommodate a much larger domain of problems. This leaves the next developments
in the ecosystem to be fleshing out the algorithms for solving all of the problem
types.

# API Changes

This post is to detail the API changes that are happening in the DifferentialEquations.jl
ecosystem. Most of them should not be very disruptive, but are things that you
should take notice of.

## Solution indexing change

The solution object now indexing has been changed to match Julian APIs better.
The linear index `sol[i]` returning the value at the `i`th timepoint is the same.
However, the "matrix indexing" has been flipped. Now, the `j`th component at
timepoint `i` is given as `sol[j,i]` whereas before it was `sol[i,j]`. This means that
`sol[j,i]==sol[i][j]`. The reason for this is that in our setup "columns" are timepoints,
not across time. Given Julia's column-major format, this gave the wrong impression
about contiguousness of the array.

Now, the `DESolution` type is simply a subtype of the new `AbstractVectorOfArray`
type in RecursiveArrayTools.jl. That means that, in addition to this change,
many other features were added that make the solution type act more like an
array.

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


## ParameterizedFunctions

Although there was discussions about changing the `@ode_def` macro syntax, I ultimately
decided against it. Instead, I polished up the edges of ParameterizedFunctions
and added to the documentation how you can do all of the things which users
had issues about. Some of the functionality in there is new. There was a large
change and an upgrade in the version of SymEngine that is used, so now more
functions can be differentiated. Importantly, no `@eval`s are used anymore, and
this means that in the future all of DifferentialEquations.jl can be statically
compiled. But now this means that DifferentialEquations.jl can be precompiled.

As for where this is going next, ParameterizedFunctions is going to maintenance and
bugfix mode. It seems everything that can be done in that architecture is done.
All of the new cool ideas will become an `@diffeq` DSL in DiffEqDSL.jl. You
can read the following issues for the plan:

[https://github.com/JuliaDiffEq/DiffEqDSL.jl/issues/1](https://github.com/JuliaDiffEq/DiffEqDSL.jl/issues/1)
[https://github.com/JuliaDiffEq/ParameterizedFunctions.jl/issues/17](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl/issues/17)

It will be exciting, but will be separate from the current macro and thus you
have no reason to expect breakage.

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

A `NoiseProcess` is how you create colored noise in the SDE and RODE problems.
In fact, it's general enough to create any noise process! For example,

```julia
WienerProcess(t0,W0,Z0=nothing)
WienerProcess!(t0,W0,Z0=nothing)
```

are used to build a `WienerProcess` either in its inplace form or in its out-of-place
form. The resulting type `W` is designed to use the RSwM adaptivity algorithms to
allow for very fast generation of the processes. In addition, the process is a
condition function `W(t)` which will automatically interpolate at the necessary
points. This allowed for the creation of a wrapper

```julia
NoiseWrapper(W::NoiseProcess)
```

that lets you re-use the same noise process in a different stochastic simulation.
In addition, you can also create spatial colored noise easily by passing in a constant
covariance matrix:

```julia
CorrelatedWienerProcess(Γ,t0,W0,Z0=nothing)
CorrelatedWienerProcess!(Γ,t0,W0,Z0=nothing)
```

The noise processes now have their own package DiffEqNoiseProcess.jl and the
interface is documented so that way the creation of new types of noise processes
can be done as needed.

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

## Steady State Calcuations

In many cases you want an easy way to calculate the steady states of a differential
equation, that is the state `u` such that

```julia
0 = f(u)
```

The new library DiffEqSteadyState.jl has solvers which make this simple. You can
generate a new steady state problem from an `f` and an inital guess:

```julia
SteadyStateProblem(f,u0,mass_matrix=I)
```

or directly convert an `ODEProblem` into a `SteadyStateProblem`:

```julia
SteadyStateProblem(prob::ODEProblem)
```

This can then be solved using the new libraries solve function dispatch. Right now
only `SSRootfind` is implemented, which will solve for the steady states using
a rootfinding algorithm. However, we plan to implement accelerated methods specific
for differential equations (and partial differential equations) that will speed
up these calculations. In fact, a new algorithm for stochastic steady states
may be coming as a new publication, with an implmentation here...

## Complex Plotting

This new update adds the recipe library DimensionalPlotRecipes.jl to the fray.
This allows for complex numbers to be directly plotted, and many other controls
are provided. We plan to extend this to work with Quaternions and allow for automatic
dimensional reduction for high dimensional plots. Documentation for this can be
found at the library's README and is now linked to in the DiffEq plotting section.

## Monte Carlo Parallelism Types

The Monte Carlo functionality now has support for different parallelism types,
so you can tell it to parallelize using threading, pmap, `@parallel`, or no
parallelism at all. Additionally, there is a `split_threads` option which will
use threading separately on each process, allowing one to using threading on every
node of a cluster for maximum performance.

## "Refined Problem Types"

This update introduces "refined problem types". These are problem types which give
the solver additional information. For example, a `SplitODEProblem` is of the form:

```julia
du = f1(t,u) + f2(t,u) + ... + fn(t,u)
```

and the solvers can use the information from this split problem to have more
optimized algorithms. Additionally, a partitioned form

```julia
du1 = f1(t,u1,u2,...,uN)
du2 = f2(t,u1,u2,...,uN)
...
dun = fn(t,u1,u2,...,un)
```

which can be used for things like symplectic algorithms. The underlying machinery
is the new type `ArrayPartition` in RecursiveArrayTools.jl and allows for heterogeneous
types to be used with type-stable broadcasting. Notably, this means that second
order problems:

```julia
u'' = f(t,u,u')
```

can be solved with the proper units without loss of efficiency (once broadcast
is used internally). Thus there are problem types for these new problems, including
a helper type for `SecondOrderODEProblem`.

While there are not many algorithms implemented which use all of this yet, the machinery
is all in place in OrdinaryDiffEq.jl, DelayDiffEq.jl, and StochasticDiffEq.jl, so
implementing new algorithms which solve these types of problems is now easy. This
will be the basis of some PDE algorithms as well.

## Mass Matrices

Mass matrices were added to the appropriate problem types. Most of the solvers
don't support using them yet, but now all of the solvers have a way of recieving
a user-defined mass matrix. Updates will come which will then make use of this functionality.

## linsolve/nlsolve Choice

Now one can explicitly choose the linear solver and nonlinear solver functions
for each of the `*DiffEq` solvers. [This documentation page](https://docs.juliadiffeq.org/latest/features/linear_nonlinear)
explains how to do this. This means you can tell the linear solving to occur on
the GPU, or using PETSc, etc., and replace the nonlinear solver code with one of
your own choosing.

## Full v0.6 Compatibility

DifferentialEquations.jl is now compatible with Julia's v0.6. Additionally, the
deprecation warnings have all been cleaned up (except for the deprecation warnings
from the dependencies NLsolve.jl and IterativeSolvers.jl... go bug them to merge
my PRs and tag a new version if you want those depwarns gone :)). This means that
you should feel free to start using DifferentialEquations on v0.6 without a hitch.

But there is one caveat to mention. Plots.jl is not v0.6 compatible right now, and
so you should stay on v0.5 until plotting is ready if that's a functionality that
you need.

# Near Future Changes

These are changes which didn't quite make the 2.0 release, but will be coming soon
after.

## Full Precompilation

Before, DifferentialEquations.jl could not be precompiled because anything related
to ParameterizedFunctions.jl could not precompiled. This was due to the dynamic
use of SymEngine.jl. However, SymEngine will release an update which makes this no
longer necessary, and thus all of this can now be precompiled. The result is that
the entirety of DiffEq will be precompile friendly. Not only that, it will be
statically compliable.

## Experimental: DiffEqIO

IO functionality has been experimentally added through IterableTables.jl. This
allows one to easily save solution types to DataFrames, CSVs, and more. This will
be added to the documentation when it's out of the experimental phase.

## Extensive PDE Tools

This will be detailed in the follow-up post on the state of the ecosystem.
