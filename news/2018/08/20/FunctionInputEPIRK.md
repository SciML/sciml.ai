@def rss_pubdate = Date(2018,8,20)
@def rss = """ DifferentialEquations.jl 5.0: v1.0, Jacobian Types, EPIRK """
@def published = " 20 August 2018 "
@def title = " DifferentialEquations.jl 5.0: v1.0, Jacobian Types, EPIRK "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

This marks the release of DifferentialEquations.jl. There will be an accompanying
summary blog post which goes into more detail about our current state and sets
the focus for the organization's v6.0 release. However, for now I would like
to describe some of the large-scale changes which have been included in this
release. Much thanks goes to the Google Summer of Code students who heavily
contributed to these advances.

## v0.7 and v1.0 Compatibility

JuliaDiffEq is now considered to be on Julia v1.0. The libraries
have had a compatibility update releases and now the master branches are being
developed for v1.0. This means that all new features will be Julia v1.0-only,
but v0.6 versions should continue to work. A lot of help came from GSoC student
Yingbo Ma (@YingboMa).

The following is a list of user-facing breaking changes:

- The performance overloads are now changed. Instead of defining overloads like
  `f(::Type{Val{:jac}},J,u,p,t)` for Jacobains, instead you define an
  `ODEFunction(f,jac=f_jac)` where `f_jac` is the function `f_jac(J,u,p,t)`.
  The same overloads all exist but now are passed to build the `ODEFunction`
  which is then used by the solver. Things like `SDEFunction`, `DDEFunction`,
  etc. all work analogously.
  [These are documented in the `Jacobians and DiffEqFunctions` page of the documentation.](https://docs.juliadiffeq.org/latest/features/performance_overloads)
  Mass matrices have also moved to the DiffEqFunction types.

- `saveat` now only includes the end points if the end points are in the array
  of `saveat` time points. Before, if `tspan=(0.0,1.0)` and `saveat=[0.5]` it
  would have saved at `[0.0,0.5,1.0]`. Now it saves at `[0.5]`. `saveat=0.5`
  still expands to the array `saveat=[0.0,0.5,1.0]` and thus works the same.

All other breaking changes are internal changes to the solver structures to
support new features.

## Jacobian Types: Sparse, Banded, Matrix-Free, etc.

The whole ecosystem now has a way to utilize non-dense matrix types by providing
a `jac_prototype` to the appropriate `AbstractDiffEqFunction` (example:
`ODEFunction`). This is a type which the solvers will use internally. For
example, if you pass a sparse matrix than a sparse Jacobian with that sparsity
structure is what will be used. Matrix types from other packages work: if you
pass a `BandedMatrix` from BandedMatrices.jl then internally the solvers can
utilize banded matrix solvers. Also, if you pass a lazy operator type which has
`mul!` defined, then this matrix-free representation of the Jacobian is what
will be used in algorithms like `gmres`. Thus any AbstractMatrix or
AbstractDiffEqOperator can now be used as the Jacobian type. Specific solvers
will throw an error if they do not support that matrix type. OrdinaryDiffEq.jl
and StochasticDiffEq.jl support any Julia matrix type while Sundials.jl supports
dense, sparse, and banded matrices. More widespread support for more matrix
types can now be the subject of easy development since this interface is all
setup thanks to GSoC student Xingjian Guo (@MSeeker1340).

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

## Adaptive Exponential-Rosenbrock methods

Like the EPIRK methods, the Exponential-Rosenbrock methods are exponential
integrators which work directly on first order ODEs and utilize the Krylov
methods to be efficient solvers for stiff equations. However, the methods allow
time stepping adaptivity unlike the EPIRK methods, meaning that not `dt` needs
to be given and these can be standard DiffEq-wide defaults due to their
minimal necessary user input. More testing will be required to show if these
methods should replace any of the default implicit methods as default methods
given by `solve`. This again is the work of the wonderful GSoC student Xingjian
Guo (@MSeeker1340)

## Quasi-Constant Stepsize Variable Order BDF and NDF Integrators

GSoC student Shubham Maddhashiya (@sipah00) has completed the implementation of
the variable order quasi-constant time step NDF and BDF integrators. This is the
implementation of multistep methods which is better known as GEAR, LSODE,
or `ode15s` where a variable time step BDF method is constructed by
interpolation to a new step size grid. This is done with the accuracy-increasing
kappa's of Shampine to allow for larger step sizes. This is a full-Julia
implementation in OrdinaryDiffEq.jl, so it will allow the use of arbitrary
Julia types like arbitrary precision and complex numbers, though some of the
extra features do need tests. And these still need some extensive benchmarking.
But they are implemented and these finishing touches are much simpler to do
over time.

This is an interesting moment for us because this is the last main feature you
would expect in any other integrator library, making the native Julia solvers of
DifferentialEquations.jl a true superset of the ODE libraries like MATLAB ODE
suite, SciPy, etc.

## IMEX BDF Integrators

The SBDF integrators are IMEX (implicit-explicit) methods which decrease the
computational cost on the BDF integrator by allowing non-stiff portions of the
equation to be integrated explicitly. GSoC student Shubham Maddhashiya (@sipah00)
has contributed both implementations of the SBDF methods. These methods are
described in the literature as core for handling large PDEs, yet this is the
first set of open source implementations.

## Functional initial conditions and timespans

This is a feature that has been slated to be added for a long time. Now the initial
condition to your differential equation problems do not have to just be constant
values. For example, you can give a function `u0(p,t0)` and this will be evaluated
using the parameters and starting time point in order to generate the `u0` as
necessary. Additionally, if `u0` returns a `Distributions.jl` distribution, a
solution will be taken by sampling from the initial distribution. By using this
setup we will be able to do things like track sensitivity to initial condition
in local sensitivity schemes. This has been a long requested feature and
therefore we are happy to have a solution which is able to apply this similarly
to all of the solvers.

The structures that this allows may be more important than the feature itself.
This was an often requested feature by library developers who wanted alternative
APIs. For example, this allows you to pass a single number for the timespan
and have it expand to `(0,X)`. `nothing` timespans are allowed and then a
user must pass a timespan at the `solve` command. Additionally, passing an
algorithm via `alg` will place it into the dispatching
`solve(prob,alg;kwargs...)` position automatically, helping package authors
handle this common case where it's lumped into the splatted kwargs passed down
to an internal DiffEq call (note it needs to be a positional algorithm for the
dispatch mechanism to work, so at least as of Julia v1.0 it cannot be a keyword
argument in general but this will allow it to act like one).

Additionally, this let's us place a global type-checking system. There are some
known type trip-ups which can occur. For example, using an adaptive ODE
algorithm is incompatible with time as integers. If you use an adaptive ODE
algorithm with initial conditions being dual numbers, you need time to be
in dual numbers as well. The infrastructure of this change allows us to throw
warnings in these cases to alert users to potential problems. By mixing this
with Requires.jl, we can alert problems due to interactions with 3rd party
packages as well, which will allow the informal knowledge about package
ecosystem interactions to get formally encoded and automatically utilized. We
hope that this will increase the usability of the software.

## An N-Body Problem Solver Package for Astrodynamics and Molecular Dynamics

[NBodySimulator.jl](https://github.com/JuliaDiffEq/NBodySimulator.jl)
was built by GSoC student Mikhail Vaganov (@Mikhail-Vaganov).
It was a large endeavor and it includes tooling to easily create N-body
problems with different potential functions (gravitational, electric, etc.)
along with all of the pieces analysis methods for calculating temperature,
pressure, etc. There will be a separate blog post introducing this cool
and I don't want to steal its thunder so that's all we'll post for now!

## Stabilized-Explicit Methods

Stabilized explicit methods are explicit Runge-Kutta methods with high stage
numbers that are chained together to give a stable method for semi-stiff
differential equations. New contributor Yongfei Tan (@tyfff) with the help of
Yingbo Ma (@YingboMa) implemented our first stabilized explicit method, the
`ROCK2` algorithm. Since these are chained Runge-Kutta methods, no linear
algebra is involved meaning that these methods can be compatible with all of the
features that the basic Runge-Kutta methods are, giving us an easy avenue to
support units, arbitrary array types, etc. in a method for stiff ODEs. These
methods are also low storage: instead of storing the Jacobian O(n^2) (unless
sparse Jacobians are specified), these methods store O(n) by default, allowing
them to be a nice default for large stiff systems when no sparsity structure is
defined (and a dense Jacobian would not fit into memory). This is an exciting
area!

# In development

And here's a quick view of the rest of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- LSODA integrator interface
- Fixed Leading Coefficient (FLC) form Nordsieck BDF integrators.

# Projects

Are you a student who is interested in working on differential equations
software and modeling? If so, please get in touch with us since we may have
some funding after August for some student developers to contribute towards
some related goals. It's not guaranteed yet, but getting in touch never hurts!
