@def rss_pubdate = Date(2018,4,9)
@def rss = """ DifferentialEquations.jl 4.3: Automatic Stiffness Detection and Switching """
@def published = "9 April 2018"
@def title = " DifferentialEquations.jl 4.3: Automatic Stiffness Detection and Switching "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Okay, this is a quick release. However, There's so much good stuff coming out
that I don't want them to overlap and steal each other's thunder! This release
has two long awaited features for increasing the ability to automatically solve
difficult differential equations with less user input.

## Automatic Stiffness Detection and Switching

In order to numerically solve a differential equation efficiently, you need to
use an explicit method for "non-stiff" problems and some more advanced form
(usually implicit) whenever there is "stiffness". These are not well-defined
properties and thus it makes it really hard to teach how this should be done.
However, the choice needs to be done because explicit methods will simply fail
on stiff equations, but implicit methods have extra steps which are very
costly, so they are inefficient if unnecessary. This is tedious to the user:
why can't the software automatically determine which algorithm is appropriate?

We can now. Thanks to Yingbo Ma (@YingboMa), stiffness detection and switching
algorithms are now part of OrdinaryDiffEq.jl and DelayDiffEq.jl. These algorithms
utilize a cheap stiffness estimate to be able to detect when an explicit method
is inefficient and automatically switch to an appropriate implicit method. Care
is taken to ensure that the resulting continuous equation is still continuously
differentiable (and a little bit more).

Benchmarks show that there is a very minimal (<5%) cost to enabling this, and
thus these methods are the new defaults. Therefore most users should be able
to automatically get appropriate methods without declaring stiffness. The
ultimate goal of making `solve(prob)` "the best choice" is thus fairly well
achieved.

These methods are available to users as the `Auto` algorithms, like
`AutoTsit5(Rodas5())` which does automatic switching between `Tsit5()` and
`Rodas5()`. These methods also apply to delay differential equations.
See the [ODE solver docs for details](https://docs.juliadiffeq.org/latest/solvers/ode_solve).

## New SSA Algorithms/Optimizations, Mass Action Jumps

One issue we had with our previous jump tooling is that it did not scale well
to large numbers of jumps. Sam (@isaacsas) and Alfonso Landeros (@alanderos91)
addressed this problem head on by creating a lot more jump problem tooling.
The key issue is that the `rate` and `affect!` functions are functions, and
each function in Julia is a separate type. The tuple unpacking scheme is super
fast for <10 types, but then slows down. What is the best way to keep the
generality but also scale well?

First of all, they recognized that most jumps are due to mass-action terms
which can be specialized. These terms don't need functions since we know the
functional form one would make.
[Thus now there's the `MassActionJump`](https://docs.juliadiffeq.org/latest/types/jump_types)
which can hold the stoichiometry matrix for the mass action terms. These can
hold all of the mass action terms, evaluate them efficiently, and reduce the
number of functions that have to be handled. It has been
[added to the jump tutorial](https://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example).

Next, [new SSAs were added](https://docs.juliadiffeq.org/latest/types/jump_types).
There is the First Reaction Method `FRM()` that can
be used as an aggregation. In addition, the SSAs can now utilize
FunctionWrappers.jl to efficiently scale to large vectors of functions. Thus
there are new methods like `DirectFW()` which utilize this strategy and will
be more efficient when one has >10 non mass-action terms.

Together this is looking quite beautiful. These methods can all use the
`SSAStepper()` for pure-jump problems, but also these methods all compose with
the ODE/SDE/DDE/DAE solvers to mix jumps and differential equations!

## Large Noise Stable Methods for SDEs

Implicitness in the SDE algorithms only tends to be on the deterministic term.
This means that large drift terms can be stable, but not necessarily large
noise terms. Even worse, you cannot simply make an algorithm implicit in the
noise term since then the mean of the steps is unbounded due to the inverse
of the normal distribution!

But there have been many recent developments for methods called step splitting
methods. These utilize a prediction via drift calculations and correct the
noise calculation in a semi-implicit manner. The result is increased stability
for large noise SDEs, usually without an additional cost. Given the effectiveness
of this research, step-splitting has been incorporated in different ways
throughout StochasticDiffEq.jl. These include:

1) [`EM` and `LambaEM`](https://docs.juliadiffeq.org/latest/solvers/sde_solve)
   have a choice to enable/disable step splitting. By default
   step splitting is enabled.

2) [The `ISSEM` and `ISSEulerHeun` methods](https://docs.juliadiffeq.org/latest/solvers/sde_solve)
   are implemented which are implicit
   methods with step splitting, giving good stability in both the drift and noise
   terms. Additionally, these methods allow non-diagonal noise and have adaptive
   time stepping.

Together, these algorithms can be much more efficient than the standard
implementations when the noise term is large. Once again, these methods combine
adaptivity which increases the amount of automation and the pool of methods which
can be solved.

## First-Differences in Parameter Estimation

Parameter inference is improved by adding first differences terms. Instead of
just checking the loss of the trajectory, this gives a loss on derivative
approximations. This improves the identifiability, and also makes more models
have fully observable parameters in the case of SDEs. Further improvements along
these lines are scheduled as well.

# In development

There should be another set of new SDE solvers dropping within the next week.
Additionally, there will be large improvements to the SSA choices for jump
equations, allowing for different SSAs and different SSA implementations which
are more efficient for large numbers of jumps. Here's a quick view of the rest
of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX methods
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface
