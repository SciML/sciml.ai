@def rss_pubdate = Date(2019,2,2)
@def rss = """ DifferentialEquations.jl 6.0: Radau5, Hyperbolic PDEs, Dependency Reductions """
@def published = " 2 February 2019  "
@def title = " DifferentialEquations.jl 6.0: Radau5, Hyperbolic PDEs, Dependency Reductions "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

This marks the release of DifferentialEquations.jl v6.0.0. Here's a low down
of what has happened in the timeframe.

## Breaking Change: Dependency Reduction in DifferentialEquations.jl

The only big breaking change of v6.0.0 is the reduction of dependencies in
DifferentialEquations.jl. We decided that with the proliferation of modeling
and analysis tooling, it was bloating the dependencies to keep them all
reexported from DifferentialEquations.jl and thus they were excised. Packages
which were removed from the standard distribution are:

- ParameterizedFunctions.jl (`@ode_def`)
- DiffEqParamEstim.jl
- DiffEqSensitivity.jl
- DiffEqUncertainty.jl
- DiffEqBiological.jl

This had some good consequences. For one, SymEngine.jl is no longer a dependency
of DifferentialEquations.jl, meaning that it is now Python free! Python's Conda
package manager seems to have been the main cause of installation issues, so
hopefully everyone has a better time installing DifferentialEquations.jl.

This also means that Sundials.jl is the only remaining package with binaries that
is included in DifferentialEquations.jl. That will continue to be the case until
we improve our DAE solvers and match `CVODE_BDF` in the few remaining benchmarks
where it does well (with a Nordsieck BDF method of our own due to Yingbo Ma!).
To prepare for the removal of Sundials.jl from the base install of
DifferentialEquations.jl, we have decided to stop reexporting Sundials. This
means that Sundials will still be used (for now) in the default argument
handling, but **if you would like to explicitly set a method to use a Sundials
method like `CVODE_BDF` or `IDA`, you need to add `using Sundials`**. The
documentation has been updated to reflect this fact. We hope that during the
v6.0 timeframe our differential-algebraic equation methods will be sufficiently
developed so that we can remove Sundials.jl from the dependencies, and by
removing the reexport now this change can occur without breaking code in the
near future.

The breaking consequence is that if you use any of the functionality provided
by these packages, you now need to include the `using` statement. For example,
**if you use `@ode_def`, you need to do `using ParameterizedFunctions` before
that**. The documentation has been updated so that all of the pages which
explore this extra functionality explicitly mentions what `using` statement
needs to be done. We are still keeping the unified documentation and the unified
testing, since this is what we believe makes the JuliaDiffEq ecosystem so
easy to use and a powerful scientific tool.

In the end, some codes will need to be updated to add a few `using` statements,
but the vast majority of users will enjoy our march to a hassle-free pure-Julia
DifferentialEquations.jl installation.

## A Few Other Minor Breaking Changes

These ones are small enough or not harmful enough that the majority of users
will likely not notice them, but it's worth mentioning:

- `timeseries_steps` has been removed since no one used that option. Use `saveat`
  instead.
- `problem_new_parameters` was removed in favor of `remake`.
- Type parameters were added to `DEIntgrator`, making it
  `DEIntegrator{alg,iip,uType,tType}`. Existing codes which dispatch on
  DEIntegrator will still work without the type parameters, so this is not
  breaking in a user-facing way.
- `internalnorm` now takes `(u,t)`. The second argument can be used for
  properly dispatching on the time type (units, autodiff), or for scaling
  adaptivity over time. `internalnorm` has been added to the common
  interface documentation.

## Scaling Enhancements in DiffEqBiological.jl

Sam Isaacson (@isaacsas) has done some amazing work with jump equation methods
and DiffEqBiological.jl. One improvement is the `@min_reaction_network` macro
which allows for incrementally building the necessary functions from the system:

```julia
sir_model = @min_reaction_network SIR begin
           c1, s + i --> 2i
           c2, i --> r
       end c1 c2
addodes!(sir_model)
addsdes!(sir_model)
addjumps!(sir_model)
```

This in addition with some other structural changes has allowed the DSL to scale
to test problems of ~25,000 reactions (i.e. that's as large as we've tested so
far), making it suitable for large interaction networks.

## Fully Implicit Runge-Kutta (FIRK) Methods: Radau5

Yingbo Ma (@yingboma) has added a native implementation of Hairer's Radau5.
Unlike simple implementations, it utilizes the domain transformation of the
tableau into the complex plane for enhanced efficiency just like the original
Fortran code. This is our first foray into FIRK methods, where we will be
handling the other order Radaus, an adaptive order Radau, and all sorts of
other methods. These methods are especially good for high accuracy integration
of stiff ODEs, so we can't wait to test them when mixed with high precision
number types!

## ROCK4 and RKC

A new contributor, Deepesh Singh Thakur (@deeepeshthakur), has implemented the
`ROCK4` and `RKC` methods. These are higher order and more efficient versions
of the `ROCK2` method which we previously released. These methods are able to
solve semi-stiff ODEs without requiring a Jacobian or factorizations, meaning
that they can be much more efficient when only mild stiffness is present. Cases
where these methods are known to perform well are discretizations of parabolic
PDEs like Reaction-Diffusion equations. Watch for these in the benchmarks.

## Anderson Acceleration

New contributor Kanav Gupta (@kanav99) has implemented Anderson Acceleration
in the OrdinaryDiffEq.jl nonlinear solver handling. This is a kind of nonlinear
solver which is more stable and faster than functional iteration, but doesn't
require the factorization of the full Jacobian matrix like Newton's method. This
can result in speed improvements for many stiff integrators. We are investigating
the effects of this method, and will be porting it over to StochasticDiffEq.jl
and DelayDiffEq.jl.

## Hyperbolic PDE Method Extravaganza

Many new contributors have added methods which are useful for the integration
of hyperbolic PDE discretizations. Divyanshu Gupta (@dgan181), Saurabh Agarwal
(@saurabhkgp21), Arnav Tiwari (@arnav-t), and Deepesh Singh Thakur
(@deeepeshthakur) have all contributed methods which have high SSP coefficients
(PDE stability), low memory requirements, and/or low dispersion. We know some of
you reading these are especially interested in applications of these methods,
so please take a look at the updated ODE solver documentation for more
information.

## Integration with Neural Networks

DifferentialEquations.jl is now integrated with the Flux.jl platform with
DiffEqFlux.jl. For more information, please see our
[release blog post](https://sciml.ai/blog/2019/01/fluxdiffeq).

## Tons and Tons of Small Fixes

These last few months have been relatively quiet for the JuliaDiffEq blog and this
is why. The incorporation of neural networks, building a pharmacometrics library
PuMaS.jl, lots of physicists picking up DifferentialEquations.jl, etc. meant that
a lot of time was spent polishing up the more obscure type handling. Dealing with
complex numbers, dual numbers, tracked values, heterogenous units, etc. all got
overhauls and testing. There is still some work needed in some areas, such as
using stiff ODE solvers on static arrays, and these will continue to get
improvements.

# In development

And here's a quick view of the rest of our "in development" list. These are not
necessarily "prioritized", but it's the kinds of things we are looking to get
done.

- Ubiquitous within-method GPU parallelism for pure-Julia methods
- Better boundary condition handling in DiffEqOperators.jl
- More native implicit ODE (DAE) solvers
- Preconditioner choices for Sundials methods
- Easier interface for Newton-Krylov in native Julia methods
- More adaptive methods for SDEs
- Adaptivity in the MIRK BVP solvers
- LSODA integrator interface
- Fixed Leading Coefficient (FLC) form Nordsieck BDF integrators
- More FIRK, IMEX, extrapolation, and stabilized-explicit methods
- More comprehensive benchmarks
- Parameter estimation and global sensitivity improvements

# Google Summer of Code Projects

Are you a student who is interested in working on differential equations
software and modeling? If so, please get in touch with us since we many Google
Summer of Code projects available! [Take a look at our projects
list on the Julia webpage](https://sciml.ai/soc/projects/diffeq.html)
