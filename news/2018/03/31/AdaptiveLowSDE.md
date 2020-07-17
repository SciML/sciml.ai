@def rss_pubdate = Date(2018,3,31 )
@def rss = """ DifferentialEquations.jl 4.2: Krylov Exponential Integrators, Non-Diagonal Adaptive SDEs, Tau-Leaping """
@def published = " 31 March 2018 "
@def title = " DifferentialEquations.jl 4.2: Krylov Exponential Integrators, Non-Diagonal Adaptive SDEs, Tau-Leaping "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

This is a jam packed release. A lot of new integration methods were developed
in the last month to address specific issues of community members. Some of these
methods are one of a kind!

## Krylov Exponential Integrators

Normally, to solve stiff ODEs you need to solve implicit equations at every
time step. However, when an equation is semilinear (`u' = Au + f(t,u)`)
then you can get away with solving a matrix exponential instead. If the system
is small enough, then you can solve for this matrix exponential once, store it,
and then utilize it each step. This is efficient, but is not always possible
since even if `A` is sparse, `exp(A)` can be dense.

To get around this issue, the ability to solve for matrix-vector products
`exp(gamma*A)*v` without forming the matrix exponential is required. This can
be done by Krylov subspace methods as seen in
[ExpoKit.jl](https://github.com/acroy/Expokit.jl) and
[Expmv.jl](https://github.com/marcusps/ExpmV.jl). Xingjian Guo (@MSeeker1340)
has developed routes in the exponential integrators of OrdinaryDiffEq.jl to
utilize these Krylov subspace methods and allow for solving large stiff semilinear
ODEs and allow for investigating adaptive time stepping exponential integrators.
[The methods all have a boolean option to turn this feature on](https://docs.juliadiffeq.org/latest/solvers/split_ode_solve).
For example:

```julia
LawsonEuler(krylov=true, m=50)
```

enables the sparse form.

## Adaptive Time Stepping in (Implicit) Euler(-Heun) for SDEs

This is a huge update to unpack. The issue with our offering before is that we
didn't have much for non-diagonal noise. This release upgrades the previous
methods to make them much nicer for this domain.

First of all, you may have noticed that implicit solvers are pretty much worthless
on highly stiff equations without adaptive time stepping. What happens is that
the Newton iterations diverge when your initial guess is too far, and you have to
change the time step to get around that! This made the `ImplicitEM`,
`ImplicitEulerHeun`, and `ImplicitRKMil` methods not perform so well on many
equations that one would have expected them to do better.

However, these methods have all been retrofitted with error estimators to have
adaptive time stepping. These error estimators are heuristics based off of the
next expansion coefficients and tend to work surprisingly well. Note that these
methods are semi-drift implicit so there are still equations that can trip them
(or any drift-impilict SDE integrator) up. However, for most of the stiff problems
people encounter these should be very useful. These can handle the whole range
of noise forms from diagonal and scalar to non-diagonal. These methods now
default to being adaptive.

The implicit methods weren't the only ones that got upgrades. These error
estimators were modified to not utilize the Jacobian so they could cheaply
be put to use on the `EM`, `EulerHeun`, `RKMil`, and `RKMilCommute` methods.
The `RKMil` and `RKMilCommute` methods required no extra caches for the adaptivity
so it was made the new default. For `EM` and `EulerHeun` this causes an increase
in cache size and thus the adaptive versions were created as new methods
`LambaEM` and `LambaEulerHeun`.

Thus DifferentialEquations.jl was not just the first openly available software
with high order adaptive algorithms for SDEs, but also the first with adaptive
algorithms for non-diagonal SDEs (and high order for commutative SDEs), both
stiff and non-stiff. Because defaults were changed on some of the methods,
this was a breaking change and go a major version update.

That said, there's still some tweaking to be done. From quick testing the adaptivity
parameters seem too conservative, and so some of the PI-control gains should be
adjusted. On some test problems this made it take 5x less steps, but the safety
of that technique needs to be investigated in more detail before making it default.
[The issue can be tracked here](https://github.com/JuliaDiffEq/StochasticDiffEq.jl/issues/62).

## Fixed Time Step Multistep ODE Methods

Multistep methods require fewer function evaluations than one-step methods like
Runge-Kutta and thus are more effective for large systems and when the derivative
function `f` gets costly.
[OrdinaryDiffEq.jl now has some fixed time step methods of this class](https://docs.juliadiffeq.org/latest/solvers/ode_solve)
and hopefully in the near future we will get our own adaptive time adaptive order
versions. Thank the new contributor Shubham Maddhashiya (@sipah00) for this
contribution and stay tuned.

## Optimized SSAStepper

Before, with pure-jump problems we recommended the `FunctionMap` algorithm for
the solver. However, the `FunctionMap` algorithm utilizes the full OrdinaryDiffEq.jl
integrator interface. In cases where the pure-jump problem doesn't have events,
this is overkill and adds some overhead. Thus for this specific case (pure-jumps
and no events), we created the `SSAStepper`. You can see it now
[featured in the tutorials](https://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example).
This stepper is highly efficient and benchmarks faster than other pure-Julia
SSA implementations. Thus it allows you to have full efficiency in the pure-jump
case while making it easy to bridge over to mixing ODEs/SDEs in via the same
interface.

## RegularJumps and Tau-Leaping

DifferentialEquations.jl's `ConstantRateJump` and `VariableRateJump` are highly
flexible allowing you to do lots of weird things like resizing after Poisson
jumps. However, in order to implement different kinds of solvers we realized
that we needed to pull back on the flexibility. But these solvers would be
highly specific to the existence of jumps, so it makes sense to create a new
jump type for them. This is the `RegularJump`. A `RegularJump` has a function
that computes the vector of all rates together, and computes the effect on
every system component due to each jump together (as a matrix). You can see
this [in the tau-leaping version of the jump problem tutorial](https://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example).
Right now there's just methods for pure `RegularJump` problems as shown in
[a new solver page](https://docs.juliadiffeq.org/latest/solvers/jump_solve),
but the plan is to add methods with high order regular stepping for jump
diffusions a la Platen, and other pure jump integrators like Binomial leaping.

## History Function Parameters

There was a breaking change to the delay differential equation interface.
David Widmann (@devmotion) noticed that the history functions did not get the
parameter update of the other functions. Now the history functions are of the
form `h(p,t)`, `h(out,p,t)`, etc. so they can depend on the parameters as well.
This is a breaking change and received a major version update.

## Event Handling Fixes

In this release the event handling was reformed to be more robust for small
step sizes. It should be more accurate at detecting events which are nearby the
step of a previous event.

# In development

This release is packaged with a bunch of goodies, but stay tuned for the next
release. Soon we will be releasing the first multi-paradigm automatic stiffness
detection and switching algorithms since LSODA (1983) (that we know of),
picking right up where the masters left it by incorporating more efficient
higher order methods. In addition there will be a large set of new SDE solvers
dropping within the next month.

Additionally, this is the main current "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX methods
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface
