@def rss_pubdate = Date(2019,6,6)
@def rss = """ DifferentialEquations.jl v6.5.0: Stiff SDEs, VectorContinuousCallback, Multithreaded Extrapolation """
@def published = " 6 June 2019 "
@def title = " DifferentialEquations.jl v6.5.0: Stiff SDEs, VectorContinuousCallback, Multithreaded Extrapolation "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Well, we zoomed towards this one. In this release we have a lot of very compelling
new features for performance in specific domains. Large ODEs, stiff SDEs, high
accuracy ODE solving, many callbacks, etc. are all specialized on and greatly
improved in this PR.

In fact, the milestone that we hit in this PR is that we
now have a serious discussion about whether it's time to drop Sundials from
all DifferentialEquations.jl default algorithm choices. More benchmarking is
being done to confirm this, but the last domain we were having issues with,
"large enough ODEs", seems to now be handled as well by our native Julia
Newton-Krylov methods as `CVODE(linsolve=:GMRES)`, and thus without any compelling
reasons we may switch to pure-Julia defaults in the next few months.

With that in mind, here are the new features.

## Improved Newton-Krylov

This is the big change. Yingbo Ma (@YingboMa) tracked down the performance of
Newton-Krylov and now our GMRES is in line with Sundials. On a very stiff ODE
of ~1,200 ODEs and 25,000 terms with a sparse Jacobian (our BCR network benchmark),
the timings are very comparable:

```julia
julia> prob1 = ODEProblem(ODEFunction(rn, jac_prototype=JacVecOperator{Float64}(rn, u0, p; autodiff=false)), u0, (0, 10000.), p)
ODEProblem with uType Array{Float64,1} and tType Float64. In-place: true
timespan: (0.0, 10000.0)
u0: [2.99718e5, 47149.2, 46979.0, 2.90771e5, 2.99981e5, 300000.0, 141.315, 0.12565, 0.404878, 140.805  …  5.27997e-11, 1.00559e-24, 6.72495e-17, 3.39556e-16, 1.78799e-5, 8.76184e-13, 0.000251795, 0.000553912, 2.28125e-14, 1.78232e-8]

julia> sol = @time solve(prob1, TRBDF2(autodiff=false, controller=:PI, smooth_est=false));
 26.327145 seconds (5.40 M allocations: 502.873 MiB)

julia> bdf = @time solve(prob1, CVODE_BDF(linear_solver=:GMRES));
 25.688197 seconds (2.19 M allocations: 525.980 MiB, 4.34% gc time)
```

We'll be verifying this on all of our PDE MOL benchmarks as well. If this has
consistent results, the next release of DifferentialEquations.jl will have some
changes in the default algorithms used, and DifferentialEquations.jl 7.0 will
drop Sundials.jl as a dependency to be a pure-Julia library. Sundials.jl will
continue to be maintained as a component solver, but this will allow us to
not require any binaries in the installation of DifferentialEquations.jl, meaning
you could take the pure Julia package scripts, copy paste them anywhere that
Julia is installed, and they should work.

## VectorContinuousCallback

VectorContinuousCallback allows you to specify a whole array of simultaneous
continuous callbacks. For example, if you have 3,000 events that you want to
run, using a CallbackSet of 3,000 ContinuousCallbacks is not a good idea for
performance, but VectorContinuousCallback is a fix for this use case. We plan
for this to be used in cases like Modia.jl and ModelingToolkit.jl where many
events need to be simultaneously checked. Thanks to Kanav Gupta (@kanav99)
for this new feature!


For reference, here's a ball bouncing off of two walls with one callback:

```julia
using OrdinaryDiffEq, Plots
function f(du,u,p,t)
  du[1] = u[2]
  du[2] = -p
  du[3] = u[4]
  du[4] = 0.0
end

function condition(out,u,t,integrator) # Event when event_f(u,t) == 0
  out[1] = u[1]
  out[2] = (u[3] - 10.0)u[3]
end

function affect!(integrator, idx)
  if idx == 1
    integrator.u[2] = -0.9integrator.u[2]
  elseif idx == 2
    integrator.u[4] = -0.9integrator.u[4]
  end
end

cb = VectorContinuousCallback(condition,affect!,2)

u0 = [50.0,0.0,0.0,2.0]
tspan = (0.0,15.0)
p = 9.8
prob = ODEProblem(f,u0,tspan,p)
sol = solve(prob,Tsit5(),callback=cb,dt=1e-3,adaptive=false)

plot(sol,vars=(1,3))
```

![double bounce](https://user-images.githubusercontent.com/33966400/59046655-0154f280-88a0-11e9-90c5-ea80b501cd27.png)

Documentation along with explanation of the code above can be found [here](https://docs.juliadiffeq.org/latest/features/callback_functions).

## SROCK

A new class of stiff SDE solvers has been implemented. The SROCK methods are
stabilized explicit methods, i.e. no implicit solvers are required. From the
literature there are many cases of stiff SDEs where these methods are vastly
superior to semi-implicit methods, and thus we are excited to be the first
differential equations solver ecosystem to have support for this method. Right
now we only have Stratonovich versions of the method, but coming soon are
Ito versions and also weak order two versions (SROCK2). Thanks to Deepesh
Shakur (@deeepeshthakur) for this method.

## Improved nonlinear solvers for stiff SDE handling

The nonlinear solving handling of the SDEs is now in line with the ODEs. Since
over the last few months we have had many improvements to the ODE versions, this
has been a major update in the stiff SDE handling via semi-implicit methods.
Thanks to Kanav Gupta (@kanav99) for this refactoring.

## Multithreaded Extrapolation

We now have a new method which exploits multithreading in order to be fast for
non-stiff ODEs. This new method, thanks to Saurabh Agarwal (@saurabhkgp21),
multithreads across the `f` calls of our newest extrapolation methods in order
to give a very fast method. Recent papers have shown that this method should
benchmark as faster than any non-multithreaded high order RK method. We will
be testing this very soon, and it may become one of the main default methods
for non-stiff ODEs after Julia's PARTR (improved multithreading) release.

## Improved TaylorIntegration

TaylorIntegration.jl will soon be releasing a breaking release that makes its
internal interface match that of DifferentialEquations.jl. The result is that
its `@taylorize` macro will now be compatible with common ODE function definitions,
making the use of TaylorIntegration.jl from the common interface be about a
factor 8 faster. This has shown some superior results when compared to the
Feagin 14th order methods, and so we are excited to see whether this becomes
the new best method for very high accuracy non-stiff ODE solving. The PR for this
is complete and will be merged soon.

## Split-step Milstein SDE methods

Split-step Milstein methods are new strong order 1.0 non-stiff integrators
for SDEs. They can be more stable in the presence of high noise. Thanks to
Deepesh Shakur (@deeepeshthakur) for this method.

## No-recompilation mode for ODEs

We now have the ability to set a no-recompilation mode in ODEs which uses
FunctionWrappers.jl to allow one to re-define `f` without requiring recompilation
or re-specailization of the ODE solver code. On non-stiff ODEs this has practically
no performance degradation. While this does not allow AD to work through the
`f` function, this is a specific feature which might be useful for certain cases
like dynamical systems where many non-stiff ODEs show up and one wants zero
recompilation burden. Thanks to Kanav Gupta (@kanav99) for helping complete
this feature.

## Next Directions

Some coordination with happening with other parts of the Julia ecosystem to
finalize some support. We are discussing/working with the IterativeSolvers.jl
developers to make sure GMRES gets fully supported on GPUs: right now there's
a portion with some indexing which isn't too harmful but triggers errors if
`CuArrays.allowscalar(false)`. In addition, we are working on getting Makie
recipes for DifferentialEquations.jl to allow for the auto-plotting to take
place on the cool new library (and this will make it easier to handle GPUArrays
in plots!). Integration with Zygote.jl is chugging along, and some tags are
needed, but when those go through our DiffEqSensitivity.jl adjoint passes
will be able to boast acceleration by Zygote.

One of the big things to watch out for in our next release is improvements to
sparsity handling, which includes:

- Surrogate optimization
- Automatic sparsity detection
- Jacobian coloring
- Specialized numerical differentiation and AD on sparse matrices for performance

In addition, the other areas getting some active work are:

- Better boundary condition handling in DiffEqOperators.jl
- More native implicit ODE (DAE) solvers

With in the background:

- Adaptivity in the MIRK BVP solvers
- Improved BDF
