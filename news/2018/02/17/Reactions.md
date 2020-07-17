@def rss_pubdate = Date(2018,2,17)
@def rss = """ DifferentialEquations.jl 4.1: New ReactionDSL and KLU Sundials """
@def published = "17 February 2018"
@def title = " DifferentialEquations.jl 4.1: New ReactionDSL and KLU Sundials "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Alright, that syntax change was painful but now everything seems to have
calmed down. We thank everyone for sticking with us and helping file issues
as necessary. It seems most people have done the syntax update and now we're
moving on. In this release we are back to our usual and focused on feature
updates. There are changes, but we can once again be deprecating any of our
changes so that's much easier on users.

Let's get to it!

## New Reaction DSL

[The new reaction DSL](https://docs.juliadiffeq.org/latest/models/biological)
is much more comprehensive than our old version. It's now:

- All macro-based
- Supports parameters
- Outputs ODEs, SDEs, and jump problems
- Allows regulation terms (Hill functions, user-defined functions)
- Can perform symbolic manipulations to speed up code
- Correctly compute coefficients for higher order reactants

It looks like:

```julia
rn = @reaction_network rType begin
  p1, X + Y --> XY               
  p2, XY --> Z            
end p1 p2
```

Basically, this fixes all of the issues users reported with the old DSL. The old
`Reaction(...)` calls throw a warning telling users to update to this
new DSL. A function-based DSL can be something in the future but with the
current setup it's hard to imagine how that would work. This covers the vast
majority of systems biology and systems pharmacology models, but puts a nice
syntax on it that also allows backend optimization. Thank @Gaussia and @korsbo
for their contribution!

## Sundials KLU

KLU is a method for sparse factorization. While before Sundials could handle
large sparse matrices through Krylov methods like `:GMRES`, for "smaller"
sparse matrices these methods can be less efficient than performing a factorization
since that factorization can be re-used in the ODE solver context. Thus this
choice can help speed up many applications which require large sparse Jacobians!
It requires that the user defines a function for the Jacobian, and that the
user specifies the sparse structure, but under those limitations it is a great
algorithm for speeding up solving large sparse equations. The developers of
Modia.jl had requested this functionality as well, so I hope this can help
them along! Thank @tshort for contributing the build script that made this possible.

## FunctionMap Changes

`Discrete()` has been deprecated for `FunctionMap()`. Not only was it redundant,
but it was also throwing warnings because it overlapped with `Discrete` from
Distributions.jl. The `DiscreteProblem` defaults to using the identity map,
so now `FunctionMap()` does a type-check for the default function and skips
any computation if the user doesn't pass `f`, making it functionally equivalent
to `Discrete()`. If you use `Discrete` you'll be giving a warning to make this
change, and there's nothing else to do here.

## DynamicHMC.jl Backend for Bayesian Estimation

The new Bayesian estimation package DynamicHMC.jl was added as a backend to
DiffEqBayes.jl. This contribution by @tpapp and @Vaibhavdixit02 has initial
tests that show
[DynamicHMC.jl + DifferentialEquations.jl](https://nbviewer.jupyter.org/github/JuliaDiffEq/DiffEqBenchmarks.jl/blob/master/ParameterEstimation/DiffEqBayesLorenz.ipynb)
is a combination that can be orders of magnitude faster than Stan.jl (though
additional testing which takes into account accuracy differences will be
needed for a more precise determination). Still, it's as simple to use as the
other Bayesian functions (see
[the example](https://docs.juliadiffeq.org/latest/analysis/parameter_estimation))
and so give it a try if you're up for it.

## Livestream Tutorial

A livestreamed tutorial on DifferentialEquations.jl was given on the JuliaLang
Youtube channel. It walks through using the ODE solvers, choosing the right
algorithms (the simple way), optimizing your code, and using event handling.

[![Video Tutorial](https://user-images.githubusercontent.com/1814174/36342812-bdfd0606-13b8-11e8-9eff-ff219de909e5.PNG)](https://youtu.be/KPEqYtEd-zY)

## Problem remake function

A function `remake(prob;kwargs)` has been added. What it does is replaces one
part of the problem. For example, `remake(prob,tspan = (0.0,3.0))` returns a
new problem which swaps out the tspan. This is nice helper function by @tkf
which allows keeping the problem types small and immutable (essential for
parallelism) but makes it easy to "modify".

## Predictor-Corrector (Stochastic) Euler

We have a new method by @onoderat for SDEs which is the Predictor-Corrector Euler
(PCE) method. This methods works on non-diagonal SDEs and
[can be more much more efficient than EM](https://github.com/JuliaDiffEq/StochasticDiffEq.jl/pull/53).
It does require the definition of a separate function `ggprime` (which will be
defined in the
[documentation](https://docs.juliadiffeq.org/latest/solvers/sde_solve))
and we will be working to define function versions that will autodifferentiate
and numerical differentiate (also symbolically build) this function.

## New Job: MIT Applied Math Instructorship

I (Chris Rackauckas) accepted a postdoctoral position as an applied mathematics
instructor in the MIT Department of Mathematics. This position is very friendly
to open-source Julia development. While I will continue to bring in new
contributors to "lower the bus number", I think it's good to inform everyone
that, as the lead developer of JuliaDiffEq, I will have a position for the next
few years that will allow me to have this software and its algorithms as my
primary research focus.

# Upcoming Events

## Teaching Video Series

I (Chris Rackauckas) will be starting a teaching series on numerical differential
equations. It will be hosted from
[my personal Youtube channel](https://www.youtube.com/channel/UCugBGdUbn6PeH03iPZtr-JQ).
It will go over topics like the differences between methods for stiff ODEs,
when they are applicable (and why), using toolboxes to discretize PDEs, SDE
models, etc. Users of DifferentialEquations.jl can use this as a reference for
more in depth explanations of how the theory of the methods apply to the practice
of solving models (efficiently).

# In development

Please take a look at [possible GSoC projects](https://sciml.ai/soc/projects/diffeq.html).
Please get in touch with us if you're interested in working on numerical
differential equation solvers!

Putting those aside, this is the main current "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX
- Improved jump methods (tau-leaping)
- LSODA integrator interface
