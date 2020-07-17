@def rss_pubdate = Date(2017,8 ,13 )
@def rss = """ SDIRK Methods """
@def published = " 13 August 2017 "
@def title = " SDIRK Methods "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


This has been a very productive summer! Let me start by saying that a relative
newcomer to the JuliaDiffEq team, David Widmann, has been doing some impressive
work that has really expanded the internal capabilities of the ordinary and
delay differential equation solvers. Much of the code has been streamlined
due to his efforts which has helped increase our productivity, along with helping
us identify and solve potential areas of floating point inaccuracies. In addition,
in this release we are starting to roll out some of the results of the Google
Summer of Code projects. Together, there's some really exciting stuff!

## SDIRK Methods

In this update we made another big step forward in stiff solvers by adding SDIRK
methods. SDIRK methods are singly-diagonal implicit Runge-Kutta methods for
stiff ODEs. Being singly-diagonal, they require just a single matrix factorization.
The solvers then exploit this fact to allow reusing the factorizing between
steps and thus gaining efficiency. The result is some highly efficient methods
for quasi-constant Jacobians.

To highlight some of the new methods, the new `TRBDF2` scheme works surprisingly
well in many areas. Although only second order, it has very good "stage prediction"
which allows the nonlinear solver to converge in just a few steps even with reused
Jacobians, making it extremely fast on the right problems. In problems where the
Jacobian is expensive but is relatively constant, this method are the new champion.
This was an area that Rosenbrock methods did not do as well before, and thus
`CVODE_BDF` helps the crown in this domain. At the higher order end of the spectrum,
methods like `Kvaerno5` and `KenCarp4` have similar results in the slow changing
Jacobian domain but are efficient at achieving high accuracy.

Thus, with the  introduction of these SDIRK methods, we have been hard pressed
to find problems where `CVODE_BDF` is not heavily surpassed by one of the
OrdinaryDiffEq.jl methods. Sundials has now been relegated to the "lowish accuracy
huge PDEs" niche. However, we will soon have an answer to that in the form of
IMEX methods which will be explained below. In addition, most of the wrapped
Fortran methods don't have a niche at all. The one wrapped method that we see
as really filling a niche that we do not hit is `radau`. If you need to solve
stiff equations with error `<1e-7`, `radau` is still the method to go to.

One piece of information to note is that `ImplicitEuler` and `Trapezoid` were
revamped as part of this release. They are now considered SDIRK methods and
use the same quasi-Newton method. Their old implementation which allowed
user-defined nonlinear solvers is now kept as `GenericImplicitEuler` and
`GenericTrapezoid`. However, in most cases the new versions tend to have
massive performance increases.

## Two-Stage Method for Parameter Estimation

This comes from the parameter estimation Google Summer of Code project. The
two-stage method is a method which finds optimal parameters for a differential
equation from timeseries data. By using smoothed regressions, it's able to get
approximate parameter values without having to repeatedly solve the ODE and thus
is very efficient. This method thus can be a good first stage in an estimation
routine to help you pinpoint the general region of parameter space to then
finish exploring with the more direct methods.

## Regularization in Parameter Estimation

Regularization is used to make it easier to converge to a slightly biased solution.
Not much more to say than you can now pass any penalty function from
PenaltyFunctions.jl to add it to the loss functions in the parameter estimation
routines. This should help the routines converge much better when there are
large numbers of possibly underdetermined parameters.

## Broadcast: GPU Compatibility

We have internal broadcasting a lot of places. Not all, but lots. We identified
where issues are (12+ broadcasts leads to a performance regression, so we marked
all of these and filed an issue in the Julia language repository) and upgraded
everything that didn't cause performance regressions. The result? Methods which
now fully broadcast can handle `AbstractArray`s very well. How well? Take for
example GPUArrays.jl. These make arrays on the GPU of course. However, you do
not want to index them since getting single values from the GPU is expensive.
But broadcasted operations are performed in GPU kernels and so they are very
fast if used on large enough problems. Also, BLAS operations like matrix
multiplication are performed on the GPU, so they are fine.
[Quick tests shows this works](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues/176#issuecomment-320821901).

Now what can this do? If you put a few arrays into an `ArrayPartition`, then
you can define equations which are just broadcasting between these GPUArrays
without ever indexing any of them. I've used this to defined a system of
reaction-diffusion PDEs and then, when I solve it with `BS3`, can confirm that
Julia compiles a bunch of GPU kernels and solves it using this method fully on
the GPU. Many of the more intense methods like Rosenbrock will also work on the
GPU is an appropriate linear solver is given. Yes, you're reading that right:
Julia is building and compiling high order stiff solvers on the GPU
for us just by having the user pass in a GPUArray as the initial condition.
It's pretty beautiful and will be tied into our PDE story in a bit.

## Dynamical ODE Problems

With the release of the symplectic methods last time, many people got excited
about solving second order ODEs. However, the interface was in a woeful
"developer state". That changed this time around. Now we have simple problem
constructors like `SecondOrderODEProblem` in a revamped documentation page to
make these specialized solvers just as accessible as the standard ODE solvers.

## Runge-Kutta Nystrom Methods

Runge-Kutta Nystrom methods are methods which are efficient for 2nd order ODEs.
They are not symplectic, but make up for that fact by being extremely efficient.
We have included some 4th and 5th order methods, along with some two-step
Runge-Kutta Nystrom methods which improve the efficiency by using one point
in the history vector. We will be adding 6th order (with dense output) and
12th order methods shortly. For 2nd order ODEs, this should be much more
efficient than transforming to 1st order ODEs.

## DAE Compatibility with Rosenbrock Methods

The Rosenbrock methods finished their development with tests of the ability to
handle mass matrices. While these can only handle constant mass matrices, these
methods are now 3/4/5 order stiffly accurate and can solve DAEs. Being fully
Julia defined, they can handle things like arbitrary precision (and recompile
onto the GPU!) which make them unique in the class of efficient methods for
DAEs. The DAE solver page was revamped to acknowledge these new capabilities.

## MuladdMacro.jl

MuladdMacro.jl is a new library that exports the `@muladd` macro. This has been
heavily used internally in JuliaDiffEq because it takes expressions like
`a = b*c + d*e + f*g` and converts that into nested FMA expressions so that
it's highly efficient and more robust to floating point errors. This functionality
has been refactored out to an independent library for everyone else to use.
Enjoy!

## Major Improvements to DelayDiffEq.jl

Oh boy, a lot of improvements to the internals of DelayDiffEq.jl occured. There
should be some performance improvements, but actually these changes will mostly
lead to a very awesome next release. That said, we do have some things related
to delay differential equations to note in this release. The new `OrwenZen`
Runge-Kutta methods are "continuous optimized", meaning their interpolation
error is optimally low. Tests against the other Runge-Kutta methods show that
these methods do great on delay differential equations. DelayDiffEq.jl now
respects the vast majority of the common interface, so `saveat` and other commands
work correctly (even though it needs full density for the delay equation solver,
it works this all out internally). This means that it can be used with parameter
estimation and other addon routines.

In addition, `RK4` added residual error adaptivity which bounds the error over
the stepping interval. When used directly on a DDE, this is equivalent to the
MATLAB `ddesd` delay differential equation solver. Thus technically, we have
state-dependent delay equation solvers now! We will be fleshing out this interface,
better testing it, and adding options to make it more robust, but feel free to
abuse the interface to make this work if needed.

## HamiltonianProblems

In DiffEqPhysics.jl we have new functionality which allows one to define a
Hamiltonian and have that automatically create the equations of motion. Coming
soon is similar capabilities for defining N-body problems from potential fields.

## ddebdf and ddeabm

New methods from ODEInterface.jl have been wrapped. These are the Shampine
Adams and BDF methods. Give them a try!

# Near Future

With Google Summer of Code coming to a close next month, we will be releasing
a lot of the results. Here's some things you can expect soon.

## Waiting to be released

We have a ton of stuff which is actually "done", but just needs some user
interface touchups and documentation. These are:

### IIF, low order Exponential RK methods

Exponential RK methods are another class of solvers for stiff ODEs, especially
those which arise from parabolic PDEs. These are implemented using the new
DiffEqOperator interface, but will get some touchups before the final release.

### Shooting Method and MIRK4 BVP Solvers

We have BVP solvers! They work. We will continue to improve them, like adding
adaptivity and sparse Jacobian support. However, these will quite soon get
documented and released.

### Lazy Finite Difference Operators

This is essentially done. Once again, touchups, docs and its released.

## In Development

### IMEX Methods

IMEX methods allow you to solve stiff equations much faster by allowing you to
specify part of the equation as nonstiff. Many of the SDIRK methods that were
implemented have embeddings which allow for this kind of IMEX solving. Along
with some new methods, our next release should allow you to have the IMEX
capabilities of Sundials' ARKODE solvers. These should be very good new
methods for PDEs.

### Native Julia Radau

As noted above, there is still one spot where we cannot beat `radau`: high accuracy
stiff ODE / DAE solving. That's why I am hoping in our next release to have a
native Julia version of (adaptive order) Radau IIA methods. Hopefully, like we
have seen with the other methods, we will be able to use Julia tricks to be
best in class in performance here while adding genericness, which would be nice
because a Radau method with arbitrary precision support would be a fantastic
method for high accuracy DAE solving. This is high on the priority list.
