---
layout: post
title:  "DifferentialEquations.jl v1.8.0"
date:   2017-2-9 17:00:00
categories:
---

DifferentialEquations.jl v1.8.0 is a new release for the JuliaDiffEq ecosystem.
As promised, the API is stable and there should be no breaking changes. The tag
PRs have been opened and it will takes a couple days/weeks for this to be available.
For an early preview, see [the latest documentation](http://docs.juliadiffeq.org/latest/).
When the release is available, a new version of the documentation will be tagged.

This tag includes many new features, including:

* Jump Equations

Jump equations like Gillespie models and jump diffusions can now be solved via
DifferentialEquations.jl solvers which are compatible with the callback interface.
A tutorial [for solving discrete stochastic simulations](http://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example.html)
has been added. It's already a very powerful interface which
allows you to define equations which depend on a very general form of jump callbacks
(i.e. mix differential equations and discrete equations). You can even have the
jump rates dependent on the continuous solution values from the differential equations,
which is shown in the new [jump diffusion tutorial](http://docs.juliadiffeq.org/latest/tutorials/jump_diffusion.html).
For more information on
defining jump equations, [see the manual page](http://docs.juliadiffeq.org/latest/types/jump_types.html)

* Multi-scale Models

Multi-scale models are a very interesting type of model which is being tackled by
modern science. We want to solve equations where we have tissues which have cells
which have proteins, all in the same model. However, these equations are naturally
extremely stiff and adaptive, and require the best methods available. Previously,
software ecosystems had to be designed around a specific model, and the methods
had to be re-implemented any (likely not) optimized for that exact model.

However, the release of MultiScaleArrays.jl allows you to build such complicated
hierarchical models with easy ways to loop at specific levels and change sizes,
but have it all be compatible with DifferentialEquations.jl. Thus you can build
these multiscale models and directly use the full force of native Julia
DifferentialEquations.jl solvers to solve this model, giving you easy access to
stiff methods with adaptive timestepping and event handling, and all of the other
features of DifferentialEquations.jl that you know and love. This cuts out the solver
development part of the complex modeling phase, allowing you to focus on the science
and get the most optimized numerical methods for free!

* Solver Compatibility Chart

A really nice documentation addition. Use
[this page](http://docs.juliadiffeq.org/latest/basics/compatibility_chart.html)
to determine what features are available for a given solver. All of the associated
packages are represented.

* Improved Event/Callback Handling in OrdinaryDiffEq.jl and DelayDiffEq.jl

The heuristic for handling floating point errors in the rootfinding technique
is greatly improved, and how to handle difficult cases is now in the documentation.
Thus you should find it to be much more robust.

* Enhanced Interpolations Interface

The interpolations interface now has an inplace form, lets you choose to interpolate
only specified indices, and lets you choose which derivative to receive. See
[the documentation](http://docs.juliadiffeq.org/latest/basics/solution.html#Interpolations-1)
for more details.

* Various Speed Improvements

All of the internal calculations in StochasticDiffEq.jl were sped up, along with
many of the routines from OrdinaryDiffEq.jl. All of the internal interpolations
use the new interpolations interface's inplace form which allows them to only
allocate when saving. StochasticDiffEq.jl also got an upgrade in its adaptive
algorithm to a new PI-controller based algorithm for stochastic equations which
gives a nice speedup as well. The `*DiffEq.jl` methods got outfitted with a
bunch of FMA (`muladd`) and SIMD goodies as well, and the interpolations
now use a binary search for the timepoint. The profiles show that these are
now operations very close (if not at) optimal now (except for the implicit
and Rosenbrock methods), and thus will likely be mostly untouched from here
on out. The implicit and Rosenbrock methods will the getting more speed updates
to reduce allocations even further.

* Linear Solver Choices in OrdinaryDiffEq.jl

The OrdinaryDiffEq.jl methods now expose the common interface for choosing
linear solvers via factorization types, which allows you to replace the `\`
within the methods with whichever routines/packages you want. See
[the documentation for more details](http://docs.juliadiffeq.org/latest/features/linear_nonlinear.html)

* Integrator interface and Event/Callbacks in StochasticDiffEq.jl

StochasticDiffEq.jl is now on-par with OrdinaryDiffEq.jl and DelayDiffEq.jl. A
novel algorithm which uses the unique RSwM algorithms was used to give the first
available stochastic differential equation solvers with an event interface which
holds in the strong sense, and the full integrator interface for flexibility.
Terminate equations on events, grow the size of the equations, etc. all like the
ODEs.

* Composite Algorithms for StochasticDiffEq.jl

Like in the OrdinaryDiffEq.jl and DelayDiffEq.jl cases, use this to build
your own algorithms which switch when stiffness is encountered.

* MathProgBase interface for DiffEqParamEstim.jl for Global Optimization

The optimization functions provided by DiffEqParamEstim.jl now lets you autodifferentiate
through them, and allows for the MathProgBase interface. Thus it can directly be used with
other packages like JuMP. See the extended documentation
[for an example which uses global optimization techniques from NLopt](http://docs.juliadiffeq.org/latest/analysis/parameter_estimation.html#More-Algorithms-(Global-Optimization)-via-MathProgBase-Solvers-1)

* Data Arrays

A `DEDataArray` allows one to carry discrete variables along with their equation,
which affect the differential equation, and can be changed through callbacks.
However, unlike using a parameter in a `ParameterizedFunction`, this data is
saved throughout the run, letting you retrieve the values. For more information,
[see the documentation page](http://docs.juliadiffeq.org/latest/features/data_arrays.html).

* Biological Models

The new DiffEqBiological.jl component of the JuliaDiffEq ecosystem allows you to
easily build biological models by defining reaction equations. The
[discrete simulation tutorial](http://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example.html)
shows this functionality in action. For more information, see
[the biological models page](http://docs.juliadiffeq.org/latest/models/biological.html).
Currently, the reactions can only be used to form discrete (Gillespie-type) equations.
However, there are plans to allow these to build more general models as well.
Of course, all of this can be done with the other components of DifferentialEquations.jl,
but this makes it easier to design and solve models related to this domain.

* Financial Models

The new DiffEqFinancial.jl component of the JuliaDiffEq ecosystem allows you
to easily define and solve common differential equations arising in financial
applications. Solve equations like the Heston model or the Black-Scholes equations
by just giving a constructor a few constants or functions. For more information,
see [the financial models page](http://docs.juliadiffeq.org/latest/models/financial.html).
In the future, discretizations of common PDEs and models with jump diffusions will be added.

-------------

## Future Directions

- Automatic conversion/promotion of problems to expand the reach of each solver.
- More problem types: more DAEs, IMEX, 2nd order ODEs, Partitioned ODEs, and symplectic problems.
- [DiffEqDiffTools.jl](https://github.com/JuliaDiffEq/DiffEqDiffTools.jl) for more efficient usage of Jacobians.
- Internals changes to allow for `Fun` types in OrdinaryDiffEq.jl methods.
- Multi-level Monte Carlo methods, to require less simulations for the same accuracy.
- Integrator interface for Sundials and DASKR

For more details on these changes,
[see this blog post](http://www.stochasticlifestyle.com/6-months-differentialequations-jl-going/).
None of these changes are expected to break user codes.
