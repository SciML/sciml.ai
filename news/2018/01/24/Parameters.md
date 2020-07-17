@def rss_pubdate = Date(2018,1,24)
@def rss = """ DifferentialEquations.jl 4.0: Breaking Syntax Changes, Adjoint Sensitivity, Bayesian Estimation, and ETDRK4 """
@def published = "24 February 2018"
@def title = " DifferentialEquations.jl 4.0: Breaking Syntax Changes, Adjoint Sensitivity, Bayesian Estimation, and ETDRK4 "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

In this release we have a big exciting breaking change to our API. We are taking
a "now or never" approach to fixing all of the API cruft we've gathered as we've
expanded to different domains. Now that we cover the space of problems we wish
to solve, we realize many inconsistencies we've introduced in our syntax.
Instead of keeping them, we've decided to do a breaking change to fix these
problems.

# Important BREAKING CHANGES

There have been a lot of requests for the same breaking changes for a long time.
Given the incoming Julia 1.0 and its breaking changes, we decided to follow suit
and fix our syntax issues as well. In our next release we will finally be
applying these breaking changes.

#### These changes are live!

To see what version you have, use `Pkg.status("DifferentialEquations")`. To
stay on the previous version, use `Pkg.pin("DifferentialEquations",v"3.1.0")`.

Note that the [latest docs](https://docs.juliadiffeq.org/latest/index) are
live with the changes. The [release-3.2 docs](https://docs.juliadiffeq.org/release-3.2/)
still hold the old syntax if needed.

### Summary of the Changes

1. Mutation goes first, then dependent variables, then parameters, then independent
   variables.    `f(mutate, dependent variables, p/integrator, independent variables)`
2. No more wrapping parameters into functors. Parameters are part of the problem.
3. All functions will have access to the problem parameters `p`.

For example, this means that the ODE syntax will be `f(u,p,t)` and `f(du,u,p,t)`.
This is breaking, as your previous code will break. In addition, there is no
deprecation warning which is possible for this transition, making it a little
more difficult than most. The documentation is already live with the changes.
The upgrade path is as follows:

* For any ODE/SDE function `f(t,u)`, it's now `f(u,p,t)`
* For any ODE/SDE function `f(t,u,du)`, it's now `f(du,u,p,t)`
* For any DAE function `f(t,u,du,resid)`, it's now `f(resid,du,u,p,t)`
* For any DAE function `f(t,u,du)`, it's now `f(du,u,p,t)`
* For any DDE function `f(t,u,h,du)`, it's now `f(du,u,h,p,t)`
* For any DDE function `f(t,u,h)`, it's now `f(u,h,p,t)`
* For any BVP boundary condition `bc(resid,u)`, it's now `bc(resid,u,p,t)`
* For any RODE function `f(t,u,W)`, it's now `f(u,p,t,W)`
* For any RODE function `f(t,u,du,W)`, it's now `f(du,u,p,t,W)`
* For any Dynamical ODE function `f(t,u,v,dv)`, it's now `f(dv,v,u,p,t)`
* For any Dynamical ODE function `f(t,u,v)`, it's now `f(v,u,p,t)`
* For any second order ODE function `f(t,u,du,out)`, it's now `f(out,du,u,p,t)`
* For any second order ODE function `f(t,u,du)`, it's now `f(du,u,p,t)`
* For any Hamiltonian `H(q,p)`, it's now `H(p,q,params)`
* For any ODE Jacobian `f(::Type{Val{:jac}},t,u,J)`, it's now `f(::Type{Val{:jac}},J,u,p,t)`
* For any DAE Jacobian `f(::Type{Val{:jac}},t,u,du,gamma,J)`, it's now
  `f(::Type{Val{:jac}},J,du,u,p,gamma,t)`
* For any jump rates `rate(t,u)`, it's now `rate(u,p,t)`
* For any callback condition `condition(t,u,integrator)`, it's now `condition(u,t,integrator)`
* `DDEProblem`s now use keyword arguments for the lags. The new construction
  syntax is:

```julia
DDEProblem{isinplace}(f,u0,h,tspan,p=nothing;
                             constant_lags=nothing,
                             dependent_lags=nothing,
                             mass_matrix=I,
                             neutral = mass_matrix == I ?
                                       false : det(mass_matrix)!=1,
                             callback = nothing)
```

* State-dependent delay lags `lag(t,u)` are now `lag(u,p,t)`
* `DDEProblem` history functions now use keyword arguments for `idxs` to match
  the interpolation of standard solution types.
* `DAEProblem`s now flip to `du0,u0` to match the way the arguments show in the
  function. The construction syntax is now:

```julia
DAEProblem{isinplace}(f,du0,u0,tspan,p=nothing;
                      callback = nothing,
                      differential_vars = nothing)
```
* For any `@ode_def` definition, the function no longer holds the
  parameters. For example,

```julia
g = @ode_def LorenzExample begin
  dx = σ*(y-x)
  dy = x*(ρ-z) - y
  dz = x*y - β*z
end σ=>28.0 ρ=>10.0 β=>8/3
```

is now

```julia
g = @ode_def LorenzExample begin
  dx = σ*(y-x)
  dy = x*(ρ-z) - y
  dz = x*y - β*z
end σ ρ β
```

This gets rid of the most repeated question "why are some `=>` and others `=`?".
Now it's only for parameters, instead just inline the constants.

* There's no need for `ParameterizedFunction(f,p)` to enclose
  parameters. To give parameters, now they are given to the problem. For example,
  for the ODEProblem, you can call

```julia
ODEProblem(f,u0,tspan)
```

and that will default to `p=nothing`, while

```julia
ODEProblem(f,u0,tspan,p)
```

will set the parameters as `p`.

However, there are many things that benefit from this:

1. No more digging through documentation for the right way to add parameters.
2. Since there's one way to do parameters, it's always compatible with add-ons.
3. All of the explicit parameter functionality (estimation, sensitivity, etc.)
   had to deal with the many ways parameters could be implemented. This will
   make it more concise and less prone to bugs.
4. All functions have access to parameters now. Before, there were some omissions
   like boundary conditions and reaction rates couldn't use parameters. This
   led to weird edge cases in parameter inference which could not be dealt with.
5. This syntax extends to PDEs better. `f(du,u,p,t,x,y,z)`.
6. This syntax does mutation first. This is a Julia-wide convention except for
   the old DiffEq which followed the Fortran ODE solver convention. Now we can
   finally match the rest of the Julia ecosystem and style guide.
7. People will no longer be confused about the case to use `@ode_def`. Now you
   can see it's explicitly for the syntax and the automatic Jacobian calculations,
   but not required for any use of parameters.
8. This opens up the possibility to have an option to pass the `integrator` as
   `p` in the near future, which then gives you access to all sorts of wild
   controls.

These issues are what tripped up more people over time than anything else, so
while this is a breaking change that will require work from everyone,
we hope that the dust will settle in about 2 weeks and everything will go forward
with a syntax that will persist and be well-liked.

## ETDRK4

The ETDRK4 algorithm is a high order exponential integrator typically used in
pseudospectral discretizations of partial differential equations like the
Navier-Stokes equation. OrdinaryDiffEq.jl now contains a numerically-stable
version which specializes on the chosen operator types to be efficient for
many types of PDE discretizations. We will be featuring a blog post soon which
highlights how this (and other related tools) can be used as central tools
for solving PDEs in Julia. More on this to come.

## Documentation FAQ

The documentation now has [a FAQ page](https://docs.juliadiffeq.org/latest/basics/faq).
It explains a lot of things like how to optimize your code, how to build
complicated models, and how to diagnose and handle numerical errors. Please
use this guide and request new additions as necessary!

## Adjoint Sensitivity Analysis

Adjoint sensitivity analysis lets you directly solve for the derivative of some
functional of the differential equation solution, such as a cost function in
an optimization problem.
[DifferentialEquations.jl now has a package-independent adjoint sensitivity analysis implementation](https://docs.juliadiffeq.org/latest/analysis/sensitivity) that lets you use any of the common
interface ODE solvers to perform this analysis. While there are more optimizations
which still need to be done in this area, this will be a useful feature for those
looking to perform optimization on the ODE solver.

## Generalized Maximum Likelihood Fitting

Our parameter inference methods previously relied on a distance-based cost
function approach. While L2-error of the solution against data corresponds to
maximum likelihood estimation under the assumption of a Normal likelihood, this
is constrained to very specific likelihood functions (Normal). Now our tools
allow for giving a likelihood distribution associated with each time point.
[We have some examples in the documentation showing how to use MLE estimation to get fitting distributions](https://docs.juliadiffeq.org/latest/analysis/parameter_estimation).
This process is a more precise approach to data fitting and thus should be an
interesting new tool to use in cases where one wants to fit parameters against
a lot of data.

## Bayesian Parameter Inference

This release introduces a new library, DiffEqBayes.jl, which allows for Bayesian
parameter estimation. Right now there are two inference functions. `stan_inference`
requires that your function is defined via `@ode_def` and will write and run a
code from [Stan](https://mc-stan.org/) to generate posterior distributions. The
`turing_inference` function uses [Turing.jl](https://github.com/yebai/Turing.jl)
and can work with any DifferentialEquations.jl object. These functions simply
require your `DEProblem`, data, and prior distributions and the [rest of the inference setup is done for you](https://docs.juliadiffeq.org/latest/analysis/parameter_estimation). Thus this is a very quick way to make use of
the power of Bayesian inference tools!

## Small Problem Speedups

We keep speeding up the "small problem case", which is solving problems which
take on the order of microseconds. This required reducing the cost of adaptivity
and being smarter in the setup routines. While this doesn't effect any decently
long running code, it'll be helpful for parameter estimation with quick
functions which have to be solved thousands to millions of times.

# Upcoming Events

The following JuliaDiffEq-related events are coming up:

## DiffEq Tutorial

There will be a [live Youtube tutorial February 6th at 10AM PST](https://www.youtube.com/watch?v=KPEqYtEd-zY).
This is to introduce users to DiffEq and for people to ask questions about
getting started. It will focus mostly on how to solve ODEs, with some foreys
into more difficult differential equations. We will be walking through the new
syntax and parameter usage. You're encouraged to come join us, and if you're an
expert it's always nice to have someone answering questions in the chat!

## SoCal Julia Meetup

On [Febraury 8th at 7PM PST](https://www.meetup.com/Southern-California-Julia-Users/events/247130330/)
we will be having a SoCal Julia meetup at the
University of California, Irvine. Katharine Hyatt will be giving a talk with
titled "Using Julia to Develop New Methods for Non-Equilibrium Statistical
Mechanics". Additionally, Chris Rackauckas will be giving a talk titled "How
Multiprecision Leads to More Efficient and More Robust PDE Solvers". If you
are in the area and would like to give a talk, please contact the organizers.

# In development

Please take a look at [possible GSoC projects](https://sciml.ai/soc/projects/diffeq.html).
Please get in touch with us if you're interested in working on numerical
differential equation solvers!

Putting those aside, this is the main current "in development" list:

- Preconditioner choices for Sundials methods
- Small feature requests (for changing initial conditions, etc.)
- Improved jump methods (tau-leaping)
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support (outside of Sundials)
- IMEX
- Improved jump methods (tau-leaping)
- Compiling Sundials with KLU and SuperLUMT
- LSODA integrator interface
