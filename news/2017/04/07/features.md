@def rss_pubdate = Date(2017, 4, 7)
@def rss = """ DifferentialEquations.jl """
@def published = "7 April 2017"
@def title = "DifferentialEquations.jl v1.9.1"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


DifferentialEquations v1.9.1 is a feature update which, well, brings a lot of new
features. But before we get started, there is one thing to highlight:

# Planned API Changes

I first want to highlight upcoming API changes so that users can be aware.
These are changes that have been discussed for quite awhile. I would like
to make these changes before the JuliaCon workshop "sets in stone" the API.
Most of the changes are rather minor.

**NOTE: Please feel free to comment in the issues! APIs are for the users,
and so if there's anything you think would make things easier to use, now
is the time to say something!**

## Proposed Saving API Changes

[https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/132](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/132)
[https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/133](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/133)
[https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/139](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/139)

These changes detail changes in how one can specify timepoints to save. The summary
is:

- If you give `saveat` a scalar, it will save at the timepoints `tspan[1]:saveat_num:tspan[end]`.
- Using `saveat` will default `save_timeseries` to false, meaning that if you set
  `saveat`, it will only save at the points you requested. This will also turn off
  dense output. These can then manually be turned on via `save_timeseries=true,dense=true`.
  Note that these will still default to true when no `saveat` is given. The reasoning
  is that, if you choose `saveat` points, you likely only want those timepoints!
- `save_timeseries` will be renamed `save_everystep`. There have been lots of questions
  about what this argument means, and the name change should clarify it.
- `saveat_idxs`: Allows you to choose which components to save. This way you
  can save memory and simply save the components you want. Not every solver
  will be able to support this, but the `*DiffEq` methods will for sure.

## Proposed ParameterizedFunction Changes

There is a lot of bikeshedding for the future of the `@ode_def` DSL. For information,
please see:

[https://github.com/JuliaDiffEq/ParameterizedFunctions.jl/issues/17](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl/issues/17)

Essentially, the breaking change will be `x_t` instead of `dx` for writing the
derivative part (meaning derivative in time). This makes it easier to carry over
into things like PDEs and DAEs. While this is breaking, this should be a very
simple fix.

## Proposed Solution Indexing Change

There is a question as to whether we should keep the `sol[:,i]` as the way to
get the timeseries for the `i`th component, or change that to `sol[i,:]`. The reason
this was originally chosen was because it's stored as a vector of arrays, so it
naturally indexes like `sol[:][i]`. However, since indexing "within the same timepoint"
is faster, this convention breaks column-major ordering which is prevalent in Julia.
Thus with `sol[i,:]`, it would be more apparent that the faster indexing is the inner
indexing. The full proposal is here:

[https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/152](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/152)

While this is likely not going to be a huge internal change, it is a breaking
change which can get opinioned. Whatever the indexing choice is, this setup will
be made more generic for a wrapper of `VectorOfArray`s, making it "more standard"
throughout the diffeq ecosystem.

# New Features

Now, onto the new features!

## Two-stage Parameter Estimation Method

This change is by a new contributor, Ayush Pandey. The Two-stage method is a statistical
method for estimating the parameters of ODE systems. While restricted to ODEs, it's
a very robust method which can be used to get the general ballpark for
parameters even when the model is slightly wrong. Since it does not actually require
solving the ODEs, it is a very fast method as well. One very good use of this method
is to get an approximate answer, which can then be refined with the nonlinear
regression approaches.

This method will be added to the documentation in the near future. Many more
updates to parameter estimation are planned, such as likelihood and Bayesian
techniques.

## Parameter Interface

This is more of a development change, but I wanted to mention that the parameter
interface has been refined to work entirely off of dispatches. This means that
the development tools can query for the parameters of problems which even
have parameters on multiple different functions. A good example is an `SDEProblem`
which has parameters on both `f` and `g`.

A side effect is that now the parameter estimation tools are compatible with more
than just `ODEProblem` types: it's compatible with any `DEProblem`. This brings
me to my next point.

## Big Monte Carlo Updates

The changes to the Monte Carlo interface is large. To see how to use the newest
version of this interface, see the documentation page here:

[https://docs.juliadiffeq.org/latest/features/ensemble](https://docs.juliadiffeq.org/latest/features/ensemble)

The biggest part of this change is that now you can specify how the simulations
are reduced, instead of saving the solution object each time. Thus you can specify
an `output_func` and just save the last value of the 1st component, allowing you
to run millions of simulations without running out of memory.

In addition, the setup is now along the lines of creating a `MonteCarloProblem`
and calling `solve` on this problem. Because of this, a few things happen. First
of all, solving Monte Carlo problems is now naturally compatible with addons
of the common solve interface. But secondly, the dispatches on the parameter
interface can apply, meaning different parts of the `MonteCarloProblem` can
be parameterized. This means that parameter estimation routines can be run
to estimate parameters using Monte Carlo simulations! Optimize the mean-squared
error over many replicates of a stochastic problem, and estimate population parameters.

## Bifucation Analysis Provided By PyDSTool

PyDSTool.jl is a new wrapper for the Python library PyDSTool. While it can do
things like solve ODEs, those features are not of much use. However, with this
wrapper comes PyCont, a library for continuation (bifurcation plots). You
can see an example for making bifurcation plots here:

[https://docs.juliadiffeq.org/latest/analysis/bifurcation](https://docs.juliadiffeq.org/latest/analysis/bifurcation)

This is in its very early stages, but now that it is working all that's left
are API improvements! But note that it's currently disabled due to a Windows
bug with PyCall's latest release. This will be fixed very soon, and DifferentialEquations
will be patched in a way that makes PyDSTool.jl a standard tool in the ecosystem.

## Retcodes

Retcodes are hard to make sexy, but they are useful.

[https://docs.juliadiffeq.org/latest/basics/solution](https://docs.juliadiffeq.org/latest/basics/solution)

Now the solvers have a set way to tell you if the solver was successful, or why
it exited pre-maturely. This setup will grow overtime, but is already fully
functional.

## Callback Initialize

Callbacks are now allowed to have an `initialize` function which will be run before
a simulation begins. Thus if you need to initiate some random event at the start
of a simulation, or set some values in the callback using values from the problem,
callbacks can do this.

## Jump Improvements

The Gillespie-type jumping models have improved behavior. Before, the starting
random numbers would only be generated on construction of the jump type. This
lead to some weird behavior. But initiating a new first jump using the callback
initialization phase, every simulation will have a different first jump just
by calling `solve` another time.

## Function Plotting

Now you can choose a function to be called on the plotted points. This allows
you to easily do things like plot the norm of the solution over time. For more
information, please see the improved plotting docs:

[https://docs.juliadiffeq.org/latest/basics/plot](https://docs.juliadiffeq.org/latest/basics/plot)

## SplitODEProblem Types

The `SplitODEProblem` is the generic diffeq answer to IMEX problems. It was implemented
by a new contributor Om Prakash. These allow you give define an ODE by a tuple of
functions instead of a single function. Solvers can then use these components
separately. This is sufficient for specifying any PDE method, and so we will be
using this to implement PDE methods. Docs will be added when the solvers which
make use of this are created.

## SSPRK Method

This was implemented by a new contributor Hendrik Ranocha. These methods are
higher-order methods which are capable of solving the semi-discretizations
arising form hyperbolic partial differential equations which have some discontinuities.
You can find these algorithm choices in the docs:

[https://docs.juliadiffeq.org/latest/solvers/ode_solve](https://docs.juliadiffeq.org/latest/solvers/ode_solve)

## SplitCoupling

This was implemented by a new contributor Ethan Levien. Split coupling of jumps
allows the variance of Monte Carlo estimates to be reduced, allowing you to estimate
moments estimators with less runs. He is developing a more general approach which
will extend the Monte Carlo setup and do things like Multi-Level Monte Carlo.

Docs for this coming soon.

# Coming Soon: Google Summer of Code

Many Google Summer of Code (GSoC) applications went in for JuliaDiffEq. This
means there is a lot of potential GSoC activity over the summer with new contributors
(students) expanding the ecosystem. A post will detail what these project will
be about when more information is known. This will likely guide a good portion
of JuliaDiffEq summer activity.
