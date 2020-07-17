@def rss_pubdate = Date(2017, 5, 18)
@def rss = """ Filling In The Interop Packages and Rosenbrock... """
@def published = "18 May 2017 "
@def title = " Filling In The Interop Packages and Rosenbrock "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


In the [2.0 state of the ecosystem post](https://www.stochasticlifestyle.com/differentialequations-jl-2-0-state-ecosystem/)
it was noted that, now that we have a clearly laid out and expansive common API,
the next goal is to fill it in. This set of releases tackles the lowest hanging
fruits in that battle. Specifically, the interop packages were setup to be as
complete in their interfaces as possible, and the existing methods which could
expand were expanded. Time for specifics.

### Revamped ODE and SDE Tutorials

All of the docs have been undergoing a pretty thorough review to make sure that
every feature is documented. But the tutorials are there to give a simple introduction.
After having many different users provide feedback, we have revamped the ODE
and SDE tutorials to more effectively drive users to writing clear and efficient
code. If there are any concerns, please open and issue or come chat in the
Gitter chatroom. Docs can always be improved!

### ODEInterfaceDiffEq: Jacobians and Mass Matrices

ODEInterfaceDiffEq.jl is a great interop package with its `radau` being
a very fast stiff solver. Now the JuliaDiffEq way of defining the Jacobian
and mass matrix is used by this package to speed up your calculations
even more.

### Interpolations All Around: Hermites and Linear

This is a big update. For the packages which had no interpolations before
yet had a cheap way to save the derivative (Sundials and DASKR), a free
Hermite interpolation was added. This gives these packages a 3rd Order
interpolation without extra work.

For all packages which do not have interpolations, and anytime `dense=false`
on a package with interpolations, it now happens that the solution object
still has an interpolation. The solution object is outfitted with a fallback
to a linear interpolation in this case, since this requires no information
other than the values at the two time points and the locations in time.
This means that every solution can be interpolated, though in some cases
(ODE.jl, ODEInterface.jl, LSODA.jl, and `dense=false`. Note `dense=false`
occurs when `saveat` is set by default, but can be flipped on as needed)
the interpolation is only 1st order (linear). Still, this makes it easy
for the user to make the choice in a pinch.

But 3rd order interpolations on Sundials and DASKR is a big win. Since these
normally fluctuate between order 2-4, this almost has the same order as the
solution time points itself, and thus is a very reliable result.

### Derivative Interpolation

For the methods of OrdinaryDiffEq.jl, `Val{1}` in the interpolant now makes it
return the interpolant derivative. Since these are hardcoded directly from the
interpolation coefficients, these are fast calculations which avoid the standard
numerical issues of finite differencing. In addition, linear interpolations
now will return the constant derivative estimate in the interval, and Hermite
interpolations have both the 1st, 2nd, and 3rd derivative estimates. Other
derivatives will keep being added, and the interpolants will get derivatives up
to the order of interpolation in the future. It's not difficult, but it's tedious
work, so thank @gabrielgellner!

### Default Algorithm Updates

A major update which is slightly hidden to users is a re-work of the default
algorithms. The default algorithm choices underwent a major update, and now
things like ODE solver choices are much more sophisticated, taking into account
the existence of callbacks and mass matrices, the user's tolerance levels, etc.
This should improve the "automatic" experience of DifferentialEquations.jl.

### Warnings on Incompatibility

One huge ecosystem update is that, now that everything is pretty much set,
we decided to warn users when interface options are ignored. For example,
Sundials cannot use the advanced adaptive `beta1` argument. So if you use
a Sundials algorithm and set this option, it will give you a warning. The
setup is: `warn` when the solution will still be true but something is
ignored, but error when it's false. So if an algorithm doesn't support
mass matrices, solving it by ignoring mass matrices would be solving the
wrong equation, and thus it `error`s in this case.

In addition, if you are using a method for stiff equations, explicitly
set a Jacobian/t-gradient, and the solver cannot use this Jacobian/t-gradient,
then you will receive a warning that your Jacobian/t-gradient overload
was ignored. This should help users better orient themselves to what
is interface-compatible. In addition, this warning leads users to the
[compatibility chart](https://docs.juliadiffeq.org/latest/basics/compatibility_chart).

In any case, these warnings can be turned off by setting `verbose=false`.
We hope that these warnings help you know in advance what options have
a real effect on each and every solver method.

### Monte Carlo Analysis Tools

The result of many user requests, there now exists a full suite of analysis
tools for analyzing the results of your Monte Carlo experiments.
[The improved docs](https://docs.juliadiffeq.org/latest/features/monte_carlo)
detail how to use the functionality for getting means, medians, variances,
covariances, etc. and plotting the timeseries of these values.

### Comprehensive Noise Processes

Noise processes reached their pinnacle design state! If you're interested in
noise processes, you
[should check out the very comprehensive docs](https://docs.juliadiffeq.org/latest/features/noise_process).
The big parts of the change are the following. Noise processes can form their own
problems now, and so these can be solved just like any other diffeq, even with
Monte Carlo tools. This is great because the standard noise processes are
are not SDE approximations and are thus distributionally-exact. Therefore if you
need very exact properties of say `GeometricBrownianMotion`, you can use this
noise process to generate it without any SDE solving, making it high performance
without the numerical approximation error. In addition, as just noted, many
basic noise processes like `BrownianBridge` and `OrnsteinUhlenbeck` have this
distributionally-exact implementation.

But even better (for developers), this form of `NoiseProcess` is now just one
of many `AbstractNoiseProcess` types. The others can be used to build high-fidelity
(though not distributionally-exact) noise processes through common means. For example,
`NoiseGrid` lets you build an `AbstractNoiseProcess` from a grid of points. This
means that your standard way of generating temporally-correlated noise (building
an array) is compatible with the JuliaDiffEq interface, and you can use this
noise array directly in the SDE solvers. Additionally, `NoiseApproximation` lets
you define processes from other SDEs, letting you implant SDE solutions as the
`dW` in another SDE.

If this is not your mathematical forte but you are still interested in using noise
processes, this part of the update is still huge because these will be the tools
that will be used to build standard versions of more complex noise processes.
For example, `PinkNoise` and `FractionalBrownianMotion` can be easily built using
a `NoiseGrid`, and thus in the near future we will offer direct constructors for
these noise types to be used in the SDE/RODE solvers to make modeling with colored
noise very accessible. What is really nice is that all of these `AbstractNoiseProcess`
types build appropriate back-interpolations, meaning that adaptive timestepping
methods can be compatible with them (given a suitable error estimate).

### Full Precompilation

This update follows an update in SymEngine.jl that lets it use libsymengine
v0.3.0. This means that ParameterizedFunctions.jl could get rid of all
uses of `@eval` and finally precompile. The result is that every package
in JuliaDiffEq is now precompilation-safe (before, ParameterizedFunctions.jl
and DifferentialEquations.jl had precompilation turned off for this reason).

### Improved Derivative Information in the `@ode_def` Macro

The SymEngine change had one additional benefit. A wider range of equations
can now be symbolically differentiated. This means that your equations can
have special functions like `erf` and now receive a symbolically-calculated
Jacobian. This should help sufficiently weird equations run faster with
stiff solvers!

### Rosenbrock: To the Limits

The `Rosenbrock23` and `Rosenbrock32` methods now support the full the limits
of the common interface. Before they could do all of the event things like
resize, but they did not support all of the performance enhancements. Now
the `Rosenbrock` methods will directly use the `invW` equations from
the `@ode_def` macro to be explicit stiff solvers in these cases. It
includes fallbacks to using the Jacobian and t-gradient for cases where
that is not defined, and has a fallback to autodifferentiation and numerical
differentition if nothing else is defined. These methods now support mass
matrices as well. This means that these methods, being A-B-L stable, are
an "everyman's method": they can do anything, and can get any of the
performance boosts that are possible. We will be working on higher order
versions, but even when those are created, `Rosenbrock23` should be
considered a foundational stiff method because of its impeccable stability
(no higher order method, has all of these stability properties. Not even BDF
methods like Sundials!), and so it's good that this method is essentially
complete (barring bugfixes).

### Improved DEDataArray

Now when interpolating `DEDataArray`, its non `.x` values hold true to their
discrete interpolation and are considered constant on any interval of
integration. Thus interpolating a `DEDataArray` will keep the same non `.x`
values as the left-hand side of the integration.

In addition, using `DEDataArray` is now  compatible with "in-equation
updates". [The docs now show](https://docs.juliadiffeq.org/latest/features/diffeq_arrays)
that DEDataArrays can be updated by updating the `u` variable in the equation
(keeping with the theme "discrete", and thus `du` does not record changes
to these variables). These changed values will then be saved for the next
iteration, and are saved in the final result. This allows you to easily mix
in discrete variables, or save the results of algebraic relations between
other variables. Some solvers are not compatible with this usage, and this
is now explicitly stated with the solver choice.

### PyDSTool Removed From DifferentialEquations

PyDSTool is an addon which is only used for bifurcation plotting, so it was
too large to justify having by default. It's kept in the documentation, and
instead the relevant documentation page tells the user to install this
package before using.

### IO Functionality

IO is now out of its experimental phase into its early release. It's still
being worked on, but [the documentation page exists](https://docs.juliadiffeq.org/latest/features/io).

### Monte Carlo Reductions

Monte Carlo reductions allow you to solve the parallel problem in batches, and
perform operations on the batches. Thus, instead of building a big array of the
solutions, you can instead in batches of 200 take the mean at each timeseries,
and add it to the mean of the last batch(es). This way, no more than 200+1 timeseries
ever have to be in memory, drastically reducing the memory cost and still outputting
the desired quantity. In addition, convergence checks can be done at the batch
calculations. For example, you can check the standard error of the mean (SEM), and
have the Monte Carlo simulation stop when the SEM is low enough (indicating that
you've ran enough samples to get the confidence in the mean sufficiently small).
This can save a lot time by adaptiving the simulation size as necessary.

### Support for StaticArrays

StaticArrays.jl provides static and fixed-sized arrays that speed up computations
on small systems. The `*DiffEq` methods now fully support using `SArray` and
`MArray` types. The `SArray` types are stack-allocated, meaning that the
not-in-place versions can be used on these arrays without a performance penalty
(in fact, they can have a large performance gain!). `MArray`s can be used in
place of normal arrays when you know the size is constant, and speedups can
occur due to extra compiler optimizations. Together, these are a good set of
types for many use cases.

## Minor Changes

- Improved Monte Carlo pmap speed via an extra caching step
- Fixed some interpolation bugs when differentiating by ForwardDiff
- Fixed a `NoiseWrapper` bug when interpolating many times in the same interval
- Added an error to `add_tstop!` when the added time lags behind the current time
- Fixed `plot_analytic` for refined problems
- Added a recursive dispatch to the default norm for handling nested arrays
- `L2DistLoss` added to DiffEqParamEstim.jl for improved efficiency
- Improved numerical accuracy in interpolations (Horner's rule)
- Greatly improved OrdinaryDiffEq and DiffEqNoiseProcess tests

## Near Future

In the next minor release, I am hoping to accomplish the following:

### IIF Methods for Split Linear-Nonlinear Equations and Low Order Exponential Runge-Kutta Methods

An implementation of these actually exist now, and pass convergence tests. Caching
of the exponential and setup with ExpoKit.jl or ExpmV.jl will be necessary before
this is ready for prime-time.

### High Order Rosenbrock Methods

The coefficients are in, but these need to be debugged.

### Velocity Verlets

This is not far off.

### Shooting Method BVP Solver

It's already created and robust. We just need to clarify the problem setup, add
some documentation, and get things registered.
