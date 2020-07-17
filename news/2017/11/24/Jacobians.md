@def rss_pubdate = Date(2017,11,24 )
@def rss = """ DifferentialEquations.jl 3.1: Jacobian Passing """
@def published = "24 November 2017  "
@def title = " DifferentialEquations.jl 3.1: Jacobian Passing "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


The DifferentialEquations.jl 3.0 release had most of the big features and was
[featured in a separate blog post](https://www.stochasticlifestyle.com/differentialequations-jl-3-0-roadmap-4-0/).
Now in this release we had a few big incremental developments. We expanded
the capabilities of our wrapped libraries and completed one of the most
requested features: passing Jacobians into the IDA and DASKR DAE solvers.
Let's just get started there:

## Jacobian interface for DAEs

First of all, we needed a common Jacobian interface for `DAEProblem` types.
`DAEProblem`s are different than ODEs because the solver needs to know how
to handle the `du` terms, since `G(t,u,du)=0` may have nonlinear usage of the
derivatives. However, all of the nonlinear solvers use the form

```julia
dG/du + gamma*dG/d(du)
```

where `gamma` is dependent on `dt`, and so we can use that form for DAEs.
This matches the definition used by older packages, so in a sec we'll mention
that! [Defines the interface.](https://docs.juliadiffeq.org/latest/features/performance_overloads)

## Improved bindings and jacobian passing for Sundials.jl and DASKR.jl

Now Sundials accepts the Jacobians into its `CVODE_Adams`, `CVODE_BDF`, and
`IDA` algorithms. `daskr` also makes use of the jacobians. By passing these
functions you can thus speed up the algorithms. In addition, the linear solver
choices for `daskr` have been made available in the common interface. This gives
us access to another banded and Krylov method for DAEs.

## New callbacks in the callback library

There are many new callbacks in the callback library. These include the
`IterativeCallback` where you give it a method for how to choose the next
timepoint for an event, and an effect to do at the event. This allows you
to easily cause discontinuous changes at time series t1, t2, t3, ... where the
next timepoints require knowing the previous. The `PeriodicCallback` makes it
easy to have an event every `dt`. The `SavingCallback` makes it easy to save
some function of the solution at each step, or via `saveat` and other similar
controls.

## Complex support in stiff solvers

The stiff solvers all can now make use of DiffEqDiffTools by making `autodiff=false`.
DiffEqDiffTools.jl is compatible with complex numbers, and thus all of these stiff
solvers can solve problems where analytical Jacobians are not given via numerical
differentiation.

## Non-diagonal additive noise and high order scalar noise SDE support

The high order SDE solvers used to only support diagonal noise. However, there
are additional cases where they work as well, and this support has been added.
The strong order 1.5 method for additive noise, `SRA1`, can now handle non-diagonal
additive noise. Additionally, `SRA1`, `SRA`, `SRI`, and `SRIW1` all support
scalar noise as well (i.e. single random variable for multiple SDEs).

## Integrator reinit interface

Many times you have to re-solve the same equation repeatedly. In these cases,
you may want to re-use the same integration cache, and then modify parameters
or just re-run with a new initial condition. We have now added a function
`reinit` to the integrator interface that allows one to reset the integrator
to a new initial condition, along with options for wiping the current state.

# In development

Note that some projects have been sectioned off as
[possible GSoC projects](https://sciml.ai/soc/projects/diffeq.html).
These would also do well as new contributor projects if anyone's interested, and
so these are not considered in the "in development" list as we are leaving these
open for newcomers/students.

Putting those aside, this is the main current "in development" list:

- IMEX Methods
- Native Julia Radau
- Anderson acceleration of unconstrained DDE steps
- Improved jump methods (tau-leaping)
