@def rss_pubdate = Date(2017,9,9 )
@def rss = """ Stiff SDE and DDE Solvers """
@def published = " 9 September 2017 "
@def title = " Stiff SDE and DDE Solvers "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


The end of the summer cycle means that many things, including Google Summer of
Code projects, are being released. A large part of the current focus has been to
develop tools to make solving PDEs easier, and also creating efficient tools
for generalized stiff differential equations. I think we can claim to be one of
the first libraries to include methods for stiff SDEs, one of the first for stiff
DDEs, and one of the first to include higher order adaptive Runge-Kutta Nystrom
schemes. And that's not even looking at a lot of the more unique stuff in this
release. Take a look.

## Solvers for Stiff Stochastic Differential Equations (SDEs and SDAEs)

Stiff stochastic differential equations are a very difficult problem. Using
the tooling built for ODEs we were able to build efficient drift-implicit
low order methods. These use the same Jacobian-reusage quasi-Newton handling as
the ODEs so the same efficiency carried over. This is only the start of a more
encompassing research project on my end, but there is a theta method which
implements a drift L-stable Implicit Euler-Maruyama, a drift-implicit Trapezoid
and drift-implicit midpoint method. Each of these also have appropriate Milstein
correction versions to be strong order 1.0 when the noise is diagonal or
commutative (commutative noise addressed later). Higher order and adaptive
methods coming soon.

## Solvers for Stiff Delay Differential Equations (DDEs and DADEs)

The stiff methods from OrdinaryDiffEq.jl are now compatible with the delay
equation methods. But there's more to it than that. Technically a stiff solver
(with mass matrices for a differential-algebraic equation) in `MethodOfSteps`
just works but it wasn't fully efficient. The issue is that the stiff methods
weren't aware of the possibility of repetitions. Delay differential equations
have to extrapolate and use fixed-point iteration in order to take timesteps
larger than the smallest delay. The ODE methods which DelayDiffEq.jl wraps
are now aware of this and will reuse the factorized Jacobians when steps are
repeated. The result is that `MethodOfSteps` extensions of many of the Rosenbrock
and SDIRK methods become very efficient solvers for stiff DDEs. More work will
come by improving the fixed-point iteration scheme (making it Anderson accelerated
for speed and better convergence properties), but the basics are here and ready
to be used.

## State-Dependent Delay Equation Solvers

State-dependent delay equations are delay differential equations where the delays
are dependent on the independent and dependent variables. For example, it could
be a differential equation where `u' = u(t-u^2)`. We now have two means to solve
such problems.

One is through a residual control on `RK4()`. This setup is now found in
the docs and is tested, and it is similar to the `ddesd` algorithm of MATLAB.
While it will only solve state-dependent delay equations with low accuracy, this
method is sufficient for roughly solving the equations "to plotting accuracy"
and can be a relatively cheap means for doing so. We hope to add more residual
control RK methods to fill this out.

Additionally, we have added full discontinuity tracking for state-dependent delays.
This automatically detects all discontinuities from the user-specified delays
and will accurately hit these points "exactly". We have verified on test equations
that this indeed gets to floating point accuracy and thus should be used in
cases where accuracy is needed. Additionally, this form can handle "neutral".
What this means is that in your history function you can use `h(t-τ,Val{1})` to
get not the value in the past, but the derivative in the past (the number of
derivatives you can get is dependent on the interpolant). Using order tracking
for the discontinuities we can properly prorogate issues arriving from this type
of interaction as well, which means that the full power of the interpolation is
allowed if you set `neutral=true` in the problem type. You can use this to
implement things like integral equations using the history function.

## Boundary Value Problem (BVP) Solvers

BVPs are ODEs where you specify boundary constraints like "u at the end must be
5". We are now releasing BoundaryValueDiffEq.jl which includes methods for solving
such equations. Currently we have a `Shooting` scheme which utilizes any of the
common interface IVP solvers to be an efficient method for BVPs which are not
sensitive to the boundary conditions, along with a `GeneralMIRK4` scheme which
uses a fully implicit Runge-Kutta method with trust region Newton solvers to be
a robust method for small systems and sufficiently large timesteps, and a `MIRK4`
scheme which is built to utilize sparse Jacobians for handling large BVPs with
smaller timesteps efficiently. Note that `Shooting` and `GeneralMIRK4` can
also handle a more general form of multi-point BVPs. For example, they can
specify conditions on interior points, and `Shooting` actually has access to the
full solution type which means that "boundary values" can be things like
"the maximum of the equation over the whole interval must be 5". `MIRK4` is
specifically for two-point boundary value problems, and will soon include
adaptivity like the MATLAB method `bvp4c`.

## Higher order methods for Stratonovich Equations

Milstein methods now have the option for `interpretation=:Stratonovich` which
will make them solve the Stratonovich form of the SDE instead of the Ito form.
This means that there are many strong order 1.0 methods for Stratonovich
equations now (including stiff solvers).

## Commutative Noise Handling in Milstein

The new Milstein method `RKMilCommute`, is a strong order 1.0 method for both
Ito and Stratonovich (through the `interpretation` argument) SDEs with a special
form of non-diagonal noise. This is a very efficient form of non-diagonal noise
which shows up in many real-world models. A full non-diagonal Milstein method
is coming soon, but it will not be able to reach the efficiency of this special
form. See the documentation for details on the commutative noise requirement.

## Domain Callbacks

The callback library has added some new callbacks. One of the more interesting
ones are the domain callbacks which use interpolations and extrapolations
to help the solvers efficiency preserve domain constraints like positivity of
the dependent variable. Check out the docs for details. `isoutofdomain` will
remain the standard since it doesn't require any regularity outside of the
domain, but this new version is blazing fast when applicable so please check
it out!

## Higher Order Dense and Adaptive Runge-Kutta Nystrom Solvers

Symplectic methods preserve energy when solving 2nd order ODEs. What if you don't
need long-time preservation and just want accuracy? That's where Runge-Kutta Nystrom
methods come in. Last time we released the first few, but they were low order
methods. Now we have all of the big guns. 6th order adaptive method with 6th
order interpolation, 8th order adaptive method, 12th order adaptive method,
two-step methods, etc. See the Dynamical ODE Solvers docs for more details.
These should be more efficient than using first order ODE solvers on transformed
second order ODEs.

## Exponential Integrators

They are finally here. Only low order exponential Runge-Kutta and Implicit
Integrating Factor (IIF) methods, but they and their machinery now exist
and are released. They require that the problem be specified as a `SplitODEProblem`
where the first part is a linear operator, and it will use the linear operator
directly in order to exactly integrate that part. This is good for discretizations
of semilinear PDEs. We will be continuing to improve this area over the coming
year.

Right now the existing methods are made for problems where the system is small
enough that the dense `exp(dt*A)` can be created and cached. For large PDEs
we will need an efficient `expmv!` method. These will be created and released
as separate versions of these algorithms (ex: `IIF2` vs `IIF2Krylov`). However,
this is currently blocked because we need to implement the `expmv!` algorithms
which is the subject of a new project in development.

## New Tooling Package: DiffEqDiffTools.jl

During a bunch of benchmarking members of JuliaDiffEq (@dextorious) noticed
that Calculus.jl is not suitable for our Jacobian needs. This member created
finite differencing methods which are efficient for the kinds of equations
found in JuliaDiffEq, giving an almost 100x speedup over the previous finite
differencing method. Although this only serves as the fallback when
`autodiff=false`, these methods will be a major win for our stiff solvers.
Included is also complex-mode finite differentiation which is able to numerically
differentiate at almost machine epsilon accuracy like autodifferentiation, giving
not only efficient but also accurate fallbacks when autodifferentiation is not
appropriate. These methods can directly handle things like `BandedMatrix` from
BandedMatrices.jl and GPUArrays, meaning that they will form the backbone of
our coming sparse Jacobian support. In addition, these methods should soon
support building Jacobians for problems defined with complex numbers, fixing
the problem we've had that no stiff solvers work without analytical Jacobians
on problems with complex numbers since ForwardDiff.jl does not support them.

## FEniCS.jl

With this release we are also releasing a wrapper to the FEniCS finite element
library. While there is still a lot more to do, the current wrapper gives you
the tools to run the basic FEniCS tutorials using pure Julia code, and allows
you to extract the assembled matrices in order to use them in further computations
in Julia. This is just the start of a more comprehensive finite element support
via FEniCS wrappers, and we hope to build some PDE solver tools which make
use of this.

## Lazy Derivative Operators: DiffEqOperators.jl

Take a PDE. Look at the derivatives it has. Say "I want the discretized finite
difference operators for those derivatives, and make them 4th order". Get back
linear operators and define the ODE from those. That's a standard approach
for solving partial differentiation equations, but in many cases this get can
be tedious since handling boundary conditions and finding out the higher
order discretization is not easy.

DiffEqOperators.jl's derivative operators do just this. You ask for the 4th order
discretization of the 4th derivative, and it spits back a matrix-free linear
operator that performs that calculation upon multiplication, and does so in a
multithreaded way (and has non-allocating dispatches). You can even use this to
easily build banded, sparse, and dense matrices corresponding to the discretized
operators making it easy to blend new tooling with older methods. In addition,
this includes matrix-free implementations of operators for the upwind schemes.
This makes it easy to implement 4th order upwind schemes for hyperbolic PDEs
without having to derive the full discretization, and these operators, being
matrix-free, are able to update their directions each step efficiently. These
operators all allow for specifying time-dependent boundary conditions and can
be used with tooling like IterativeSolvers.jl. This makes finite difference
discretizations a breeze.

## SSP Limiters

In addition to adding many more strong-stability preserving methods, these methods
now have the possibility for the user to pass in a `limiter` function to ensure
that properties like positivity are preserved at each step of the integrator.
Needless to say, this is very helpful for solving hyperbolic PDEs with larger
timesteps. In addition we now document the SSP coefficients so users can more
easily set maximal timesteps to match what's necessary via the CFL constraints.

# In Development

Note that some projects have been sectioned off as
[possible GSoC projects](https://sciml.ai/soc/projects/diffeq.html).
These would also do well as new contributor projects if anyone's interested, and
so these are not considered in the "in development" list as we are leaving these
open for newcomers/students.

Putting those aside, this is the main current "in development" list:

- IMEX Methods
- Methods for efficient `expmv!`
- Native Julia Radau
- Anderson acceleration of unconstrained DDE steps
- Improved jump methods (tau-leaping)
