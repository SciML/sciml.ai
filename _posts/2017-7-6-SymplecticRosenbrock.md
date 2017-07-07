---
layout: post
title:  "High Order Rosenbrock and Symplectic Methods"
date:   2017-7-7 1:30:00
categories:
---

For awhile I have been saying that JuliaDiffEq really needs some fast high
accuracy stiff solvers and symplectic methods to take it to the next level.
I am happy to report that these features have arived, along with some other
exciting updates. And yes, they benchmark really well. With new Rosenbrock methods
specifically designed for stiff nonlinear parabolic PDE discretizations, SSPRK
enhancements specifically for hyperbolic PDEs, and symplectic methods for Hamiltonian
systems, physics can look at these release notes with glee. Here's the full ecosystem
release notes.

## Video Tutorial for JuliaDiffEq

Due to JuliaCon we now have a video introduction to JuliaDiffEq!

<iframe width="560" height="315" src="https://www.youtube.com/embed/75SCMIRlNXM" frameborder="0" allowfullscreen></iframe>

I find videos to be a very good media for teaching, so there will surely be
more to follow.

## High Order Rosenbrock Methods

They have finally arrived. Let me accompany this with an explanation. For lots
of differential equation history, Rosenbrock methods have been somewhat niche
stiff solvers. Multistep methods like Sundials' `CVODE_BDF` is usually the
goto method [though I explained in depth why this is a bad idea](https://scicomp.stackexchange.com/questions/27178/bdf-vs-implicit-runge-kutta-time-stepping)
(essentially they work well for very large stiff PDE discretizations, but then using
them on a small problem is like using Thor's hammer to build a fence: the tool
is powerful but can be very inefficient outside of its main domain!). `radau`
is a great implicit Runge-Kutta method to default to, but it's main purpose
is high accuracy and it can be very slow when you don't need too much accuracy.
Rosenbrock methods have generally filled the gap for really low accuracy (see
`ode23s`), but never went much further.

But why is that the case? It's actually very easy to explain. In all other stiff
solvers, the method is implicit. The Jacobian is used to make an the implicit
equation solver faster, and inaccurate Jacobians don't actually affect the order
of accuracy since it's all about solving the implicit equation to convergence
(though inaccurate Jacobians slow convergence). However, in the Rosenbrock method
Jacobians are actually part of the method and its derivation. This means that
if the Jacobian is too inaccurate, then you actually lose the asymptotic order
of accuracy. In previous diffeq software, this was a limiting factor because
most of the time Jacobians have to be estimated, and numerical differentiation
has high inaccuracies, meaning there was a fundamental cutoff to how well Rosenbrock
methods could do. However, as long as you don't hit that issue, for example
stay at low accuracy or provide the analytical Jacobian, Rosenbrock methods
are extremely efficient (see the benchmarks in Hairer's book as a reference to the
fact that this was known).

But we're in Julia! Not only do we have the `@ode_def` macro supplying the analytical
Jacobian, even for arbitrary Julia functions we can usually use ForwardDiff.jl
to get the system Jacobian via autodifferentiation which works to machine accuracy!
So the previous issues are thrown out the window, which is why I thought we should
revist Rosenbrock methods. So we revisted them well. This release includes the
following new Rosenbrock methods:

- `ROS3P` - 3rd order A-stable and stiffly stable (Index-1 DAE compatible) Rosenbrock method.
  Keeps high accuracy on discretizations of nonlinear parabolic PDEs.
- `Rodas3` - 3rd order A-stable and stiffly stable Rosenbrock method.
- `RosShamp4`- An A-stable 4th order Rosenbrock method.
- `Veldd4` - A 4th order D-stable Rosenbrock method.
- `Velds4` - A 4th order A-stable Rosenbrock method.
- `GRK4T` - An efficient 4th order Rosenbrock method.
- `GRK4A` - An A-stable 4th order Rosenbrock method. Essentially "anti-L-stable" but efficient.
- `Ros4LStab` - A 4th order L-stable Rosenbrock method.
- `Rodas4` - A 4th order A-stable stiffly stable Rosenbrock method with a stiff-aware
  3rd order interpolant
- `Rodas42` - A 4th order A-stable stiffly stable Rosenbrock method with a stiff-aware
  3rd order interpolant
- `Rodas4P` - A 4th order A-stable stiffly stable Rosenbrock method with a stiff-aware
  3rd order interpolant. 4th order on linear parabolic problems and 3rd order accurate
  on nonlinear parabolic problems (as opposed to lower if not corrected).
- `Rodas5` - A 5th order A-stable stiffly stable Rosenbrock method with a stiff-aware
  3rd order interpolant.

I gave the theory, but the followup question is, do you have benchmarks to prove
the theory? Yes!
[The DiffEqBenchmarks.jl stiff benchmarks now include the Rosenbrock methods](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl)
At standard tolerances (`1e-2 < reltol < 1e-6`), the Rosenbrock methods `Rosenbrock23`,
`Rodas3`, and `Rodas4` together form a group of methods which are 5x-10x faster
than the previously recommended Fortran and Sundials methods. Here's an example
benchmark on the VanDerPol problem where the error is at the final timepoint
vs a reference solution calculated with `tol=1e-14`:

<img src="https://user-images.githubusercontent.com/1814174/27948516-ec781da6-62ae-11e7-8df0-c84d2fd65e34.PNG">

Here we plot error vs compute time, where we are changing the `abstol` and `reltol`
of the solvers. It's a small problem, but in normal tolerances it's already able to distinguish
itself. For larger problems where the Jacobian can still be factorized, these
methods show even larger performance gains. In additions, these methods are in OrdinaryDiffEq.jl,
so they are compatible with the event handling, have "stiff-aware" high-order interpolants,
and can use arbitrary precision along with all of the other cool features. For
regular sized systems, most users will find this to be a sizable performance
enhancement for stiff equations. There are some made specifically for non-linear
parabolic PDEs, and many are "stiffly stable", meaning they can be used for DAEs in
mass matrix form.

There is still a lot of work to be done on these. More optimizations can occur,
and they need to be made compatible with resizing in events (`Rosenbrock23` has
this ability and all others can be done similarly, so in the near future these
will be fully compatible with everything you can do in events). But, the benchmarks
already show that for standard problems, we have a new top level of efficiency and
it's given by native Julia methods!

## Symplectic Methods

Rosenbrock methods are not the only new set of solvers which are part of this
release. In this release we are also including a full array of symplectic integrators.
For those who don't know, symplectic integrators conserve first integral properties
like energy, making them very efficient for long-time integration of Hamiltonian
systems. This makes them a favorite amongst physicists. In this release we went
all out. The new methods are:

- `VelocityVerlet`: 2nd order explicit symplectic integrator.
- `VerletLeapfrog`: 2nd order explicit symplectic integrator.
- `PseudoVerletLeapfrog`: 2nd order explicit symplectic integrator.
- `McAte2`: Optimized efficiency 2nd order explicit symplectic integrator.
- `Ruth3`: 3rd order explicit symplectic integrator.
- `McAte3`: Optimized efficiency 3rd order explicit symplectic integrator.
- `CandyRoz4`: 4th order explicit symplectic integrator.
- `McAte4`: 4th order explicit symplectic integrator. Requires quadratic
  kinetic energy.
- `CalvoSanz4`: Optimized efficiency 4th order explicit symplectic integrator.
- `McAte42`: 4th order explicit symplectic integrator.
- `McAte5`: Optimized efficiency 5th order explicit symplectic integrator.
  Requires quadratic kinetic energy
- `Yoshida6`: 6th order explicit symplectic integrator.
- `KahanLi6`: Optimized efficiency 6th order explicit symplectic integrator.
- `McAte8`: 8th order explicit symplectic integrator.
- `KahanLi8`: Optimized efficiency 8th order explicit symplectic integrator.
- `SofSpa10`: 10th order explicit symplectic integrator.

You can read more about them
[in the Refined ODE Solver docs](http://docs.juliadiffeq.org/latest/solvers/refined_ode_solve.html).
We have some [new physics tutorials](http://nbviewer.jupyter.org/github/JuliaDiffEq/DiffEqTutorials.jl/blob/master/PhysicalModels/ClassicalPhysics.ipynb)
which show how to build a `SecondOrderODEProblem` and use these methods. They use
the same fast Runge-Kutta setup as the rest of OrdinaryDiffEq.jl so they are quite
efficient (though they do not include adaptive timestepping, long story there).

## SSPRK Updates

Yes, we looked at other categories of solvers. @ranocha put a lot of work into the
SSPRK solvers this time around. These solvers have the special property that they
conserve monotonicity which is required for solving many hyperbolic PDEs. Before
we just had fixed timestep variants. Now we have all of the bells and whistles:
adaptive timestepping, dense output which satisfies the SSP property, etc. Essentially
it's all of the tools you'd ask for, except the automatic spatial discretization
(of course that's coming soon!).

## Element-wise Tolerances

Element-wise tolerances let you set different tolerances on different parts of
your equation and speed things up. This is something that `*DiffEq` was missing,
until now. This is fully compatible with the `integrator` interface, so you
can even change them on the fly in events.

## DiffEqOperator

We have settled the new `DiffEqOperator` interface which will allow for building
methods which require parts of the equation to be a linear operator. It'll be
added to the docs shortly, but it's allowing us to build all sorts of tools
which will take advantage of linearity.

## All Around Performance Boosts

Oh boy, big performance boosts. The quick lowdown is this:

- OrdinaryDiffEq.jl got "fast tableau" specializations for Float64. So methods
  which store coefficients as BigFloats now have a setup specifically for Float64
  that hardcodes the truncated coefficients. This in some cases drastically reduces
  startup times, helping not just benchmarks but also interactivity and tasks which
  require solving many small equations.
- Some fastmath was added around to areas that bottlenecked small systems. These
  then got a pretty sizable performance gain.
- DiffEqJump got heavily profiled and some major performance improvements were found.
  Testing against the handwritten loops of Gillespie.jl shows that this setup now
  is very close to par, about `<20%` away from full efficiency. Given that this setup
  allows for jump equations to couple with diffeqs, I'm calling this a major victory.
- MonteCarloSimulations now use `CachingPools` to dramatically increase the efficiency
  of multiprocessing. There are more options which were added so you can control the
  batchsize of `pmap`.
- The standard RNG was swapped out for a `Xoroshiro128Plus`. Our tests show that
  it's both more accurate and faster, giving the best of both worlds upgrade.

You can see the impact of these by checking out the improved timings in
[DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl).
Higher order methods got a really nice boost because their startup cost was
heavily decreased, making `Vern7` and `Vern9` look even better than before.

## Experiments with Broadcast

There was a version of OrdinaryDiffEq and StochasticDiffEq which replaced all loops
with broadcast. Tests were run and it shows that things like `GPUArray`s then
work directly in the DiffEq solvers. However, broadcasting gave a pretty sizable
performance loss, so it was reverted. But the proper issues have been opened in
Base, and the tests showed that a wide class of "weird abstract arrays" with
performant broadcast overloads "just work" efficiently in the DiffEq solvers.
Until this is fixed, we might bring this back for select solvers.

## Stochastic Seeding

At JuliaCon I was asked if there were seeds for each stochastic simulation. Unfortunately
there wasn't. But that was a pretty good idea, so there is now. Stochastic problems
like SDEs now let you set a `seed`. This then seeds the RNG at the start of the
run. If it's not set, then a random seed is chosen. That seed is stored in the
solution type as `.seed`, so you can always recover how the seed for any solution.
Using this the results should be much more reproducible.

## Reduced Stochastic Saving Pressure

For awhile, `save_everystep` and `timeseries_steps` didn't effect the Brownian
motion, meaning that it still used a lot of memory. Now the `NoiseProcess` matches
the diffeq's saving properties, allowing massive performance gains on really long
running problems.

## Deprecation of ODE.jl

This has been a long time coming. It's known that
[some of its methods may be giving incorrect results](https://github.com/JuliaDiffEq/ODE.jl/issues/124),
[there are some very slow parts](https://github.com/JuliaDiffEq/ODE.jl/issues/121),
and it's missing a lot of the advanced features we need. If you check out
[DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl), you'll
see that ODE.jl's algorithms diverge on most of the test problems. The library
hid this by having very low defaults for the tolerances, but we can do better.
Also, it sacrifices a lot of features and speed to get cleaner code,
which is a nice tradeoff in some senses but is not something which should be
done in a core production ODE solver.  

Because of this state for ODE.jl, many users have asked that I formally deprecate
ODE.jl in favor of OrdinaryDiffEq.jl in order to stop the confusion around the
library. This is the announcement that this has occurred.
To help users transition, all of ODE.jl's algorithms are part of the
common interface, so setting the defaults correctly will allow you to exactly
replicate your results in the DiffEq framework. All of the packages which had
ODE.jl as a dependency received a PR which replaces ODE.jl with OrdinaryDiffEq.jl
(note you can directly use OrdinaryDiffEq.jl without the rest of DiffEq, see
[this page in the docs](http://docs.juliadiffeq.org/latest/features/low_dep.html)).

ODE.jl is not going away. I have maintained it for a year, and will continue to
maintain it and make sure it exists in a usable state in Julia 1.0. What I will
not promise is any new features. ODE.jl is not designed in a manner that makes
it easy to develop with all of the bells and whistles, which is why it has been
ignored. But your ODE.jl code should continue to run on Julia 1.0 exactly the
same as it did before. ODE.jl will still have its place as a nice clean set
of algorithms which is good for teaching, and is a low-dependency library
(for example, it doesn't make use of autodifferentiation so it doesn't have
dependencies on ForwardDiff.jl). The library will probably get updates in the
future to help it better serve this role.

# Near Future

This was a huge release, with over 30 new solver methods. Surely we won't have
another sprint like that for a little bit. But there's many things which are
pretty far along the pipeline.

## IIF, low order Exponential RK methods and Shooting Method

These work and just need to be documented and get some tutorials. Technically
they might actually be part of this release. The first two can use some
more optimizations, but tests are passing on all of them.

## Lazy Finite Difference Operators

This is a GSoC project, and it's coming along very nicely. It allows you to simply
say "I want the 2nd derivative with a 4th order discretization" and get back an
efficient operator which does just that, and it's compatible with numerical linear
algebra tools like IterativeSolvers.jl. It may be ready for release by the next
ecosystem release.

## DiffEqApproxFun.jl's Indirect Problem

Directly using ApproxFun's `Fun` type will be a topic of long research. But building
spectral discretizations of PDEs and solving them with any method on the DiffEq
common interface is easy. This already exists and is tested, so check out the
package DiffEqApproxFun.jl if you want. It'll get documented and released.

## DelayDiffEq Performance Improvements

You can technically throw a stiff solver in there already, but we can make it
so that way the Rosenbrock methods are much more efficient by allowing there
to be a flag that says "only factorize the first time". Then, when coupled with
Anderson acceleration, we will have very fast tools for most stiff DDEs and
stiff delay DAEs (with events of course)! This just needs a few more lines of
code and a bunch of tests.

## Physical Modeling Tools

DiffEqPhysics.jl has had some work done on it to make physical modeling easier.
By the next release we should have some tools for easily generating N-body problems,
automatically converting Hamiltionians into equations of motion for symplectic
integrators, and tools to make it easy to define common models like Hamiltonians
which arise in MD simulations.

## Wrap More ODEInterface

ODEInterface.jl has added a few new things, so we'll add these to the common
interface shortly.

# Down the Pipeline

So with all of that above pretty far along, what's next in the pipeline?

- Implicit Runge-Kutta methods
- Expansion of the public benchmarks. There's a lot more that's private, and it's
  always nice to share benchmarks!
- More parameter estimation tools
- New SDE methods
- Biological modeling tools.
