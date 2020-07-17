@def rss_pubdate = Date(2019,5,9)
@def rss = """ DifferentialEquations.jl v6.4.0: Full GPU ODE, Performance, ModelingToolkit """
@def published = "9 May 2019 "
@def title = " DifferentialEquations.jl v6.4.0: Full GPU ODE, Performance, ModelingToolkit "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

This is a huge release. We should take the time to thank every contributor
to the JuliaDiffEq package ecosystem. A lot of this release focuses on performance
features. The ability to use stiff ODE solvers on the GPU, with automated
tooling for matrix-free Newton-Krylov, faster broadcast, better Jacobian
re-use algorithms, memory use reduction, etc. All of these combined give some
pretty massive performance boosts in the area of medium to large sized highly
stiff ODE systems. In addition, numerous robustness fixes have enhanced the
usability of these tools, along with a few new features like an implementation
of extrapolation for ODEs and the release of ModelingToolkit.jl.

Let's start by summing up this release with an example.

### Comprehensive Example

Here's a nice showcase of DifferentialEquations.jl: Neural ODE with batching on
the GPU (without internal data transfers) with high order adaptive implicit ODE
solvers for stiff equations using matrix-free Newton-Krylov via preconditioned
GMRES and trained using checkpointed adjoint equations. Few programs work
directly with neural networks and allow for batching, few utilize GPUs, few
have methods applicable to highly stiff equations, few allow for large stiff
equations via matrix-free Newton-Krylov, and finally few have checkpointed
adjoints. This is all done in a high level programming language. What does the
code for this look like?

```julia
using OrdinaryDiffEq, Flux, DiffEqFlux, DiffEqOperators, CuArrays
x = Float32[2.; 0.]|>gpu
tspan = Float32.((0.0f0,25.0f0))
dudt = Chain(Dense(2,50,tanh),Dense(50,2))|>gpu
p = DiffEqFlux.destructure(dudt)
dudt_(du,u::TrackedArray,p,t) =  du .= DiffEqFlux.restructure(dudt,p)(u)
dudt_(du,u::AbstractArray,p,t) = du .= Flux.data(DiffEqFlux.restructure(dudt,p)(u))
ff = ODEFunction(dudt_,jac_prototype = JacVecOperator(dudt_,x))
prob = ODEProblem(ff,x,tspan,p)
diffeq_adjoint(p,prob,KenCarp4(linsolve=LinSolveGMRES());u0=x,
               saveat=0.0:0.1:25.0,backsolve=false)
```

That is 10 lines of code, and we can continue to make it even more succinct.

Now, onto the release highlights.

## Full GPU Support in ODE Solvers

Now not just the non-stiff ODE solvers but the stiff ODE solvers allow for
the initial condition to be a GPUArray, with the internal methods not
performing any indexing in order to allow for all computations to take place
on the GPU without data transfers. This allows for expensive right-hand side
calculations, like those in neural ODEs or PDE discretizations, to utilize
GPU acceleration without worrying about whether the cost of data
transfers will overtake the solver speed enhancements.

While the presence of broadcast throughout the solvers might worry one about
performance...

## Fast DiffEq-Specific Broadcast

Yingbo Ma (@YingboMa) implemented a fancy broadcast wrapper that allows for
all sorts of information to be passed to the compiler in the differential
equation solver's internals, making a bunch of no-aliasing and sizing assumptions
that are normally not possible. These change the internals to all use a
special `@..` which turns out to be faster than standard loops, and this is the
magic that really enabled the GPU support to happen without performance
regressions (and in fact, we got some speedups from this, close to 2x in some
cases!)

## Smart linsolve defaults and LinSolveGMRES

One of the biggest performance-based features to be released is smarter linsolve
defaults. If you are using dense arrays with a standard Julia build, OpenBLAS
does not perform recursive LU factorizations which we found to be suboptimal
by about 5x in some cases. Thus our default linear solver now automatically
detects the BLAS installation and utilizes RecursiveFactorizations.jl to give
this speedup for many standard stiff ODE cases. In addition, if you passed a
sparse Jacobian for the `jac_prototype`, the linear solver now automatically
switches to a form that works for sparse Jacobians. If you use an
`AbstractDiffEqOperator`, the default linear solver automatically switches to
a Krylov subspace method (GMRES) and utilizes the matrix-free operator directly.
Banded matrices and Jacobians on the GPU are now automatically handled as well.

Of course, that's just the defaults, and most of this was possible before but
now has just been made more accessible. In addition to these, the ability to
easily switch to GMRES was added via `LinSolveGMRES`. Just add
`linsolve = LinSolveGMRES()` to any native Julia algorithm with a swappable
linear solver and it'll switch to using GMRES. In this you can pass options
for preconditioners and tolerances as well. We will continue to integrate this
better into our integrators as doing so will enhance the efficiency when
solving large sparse systems.

## Automated J*v Products via Autodifferentiation

When using `GMRES`, one does not need to construct the full Jacobian matrix.
Instead, one can simply use the directional derivatives in the direction of
`v` in order to compute `J*v`. This has now been put into an operator form
via `JacVecOperator(dudt_,x)`, so now users can directly ask for this to
occur using one line. It allows for the use of autodifferentiation or
numerical differentiation to calculate the `J*v`.

## DEStats

One of the nichest but nicest new features is DEStats. If you do `sol.destats`
then you will see a load of information on how many steps were taken, how many
`f` calls were done, etc. giving a broad overview of the performance of the
algorithm. Thanks to Kanav Gupta (@kanav99) and Yingbo Ma (@YingboMa) for really
driving this feature since it has allowed for a lot of these optimizations to
be more thoroughly investigated. You can expect DiffEq development to
accelerate with this information!

## Improved Jacobian Reuse

One of the things which was noticed using DEStats was that the amount of Jacobians
and inversions that were being calculated could be severly reduced. Yingbo Ma (@YingboMa)
did just that, greatly increasing the performance of all implicit methods like
`KenCarp4` showing cases in the 1000+ range where OrdinaryDiffEq's native
methods outperformed Sundials CVODE_BDF. This still has plenty of room for
improvement.

## DiffEqBiological performance improvements for large networks (speed and sparsity)

Samuel Isaacson (@isaacson) has been instrumental in improving DiffEqBiological.jl
and its ability to handle large reaction networks. It can now parse the networks
much faster and can build Jacobians which utilize sparse matrices. It pairs
with his ParseRxns(???) library and has been a major source of large stiff
test problems!

## Partial Neural ODEs, Batching and GPU Fixes

We now have working examples of partial neural differential equations, which
are equations which have pre-specified portions that are known while others
are learnable neural networks. These also allow for batched data and GPU
acceleration. Not much else to say except let your neural diffeqs go wild!

## Low Memory RK Optimality and Alias_u0

Kanav Gupta (@kanav99) and Hendrik Ranocha (@ranocha) did amazing jobs at doing memory optimizations of
low-memory Runge-Kutta methods for hyperbolic or advection-dominated PDEs.
Essentially these methods have a minimal number of registers which are
theoretically required for the method. Kanav added some tricks to the implementation
(using a fun `=` -> `+=` overload idea) and Henrick added the `alias_u0` argument
to allow for using the passed in initial condition as one of the registers. Unit
tests confirm that our implementations achieve the minimum possible number of
registers, allowing for large PDE discretizations to make use of
DifferentialEquations.jl without loss of memory efficiency. We hope to see
this in use in some large-scale simulation software!

## More Robust Callbacks

Our `ContinuousCallback` implementation now has increased robustness in double
event detection, using a new strategy. Try to break it.

## GBS Extrapolation

New contributor Konstantin Althaus (@AlthausKonstantin) implemented midpoint
extrapolation methods for ODEs using Barycentric formulas and different a
daptivity behaviors. We will be investigating these methods for their
parallelizability via multithreading in the context of stiff and non-stiff ODEs.

## ModelingToolkit.jl Release

ModelingToolkit.jl has now gotten some form of a stable release. A lot of credit
goes to Harrison Grodin (@HarrisonGrodin). While it has
already been out there and found quite a bit of use, it has really picked up
steam over the last year as a modeling framework suitable for the flexibility
DifferentialEquations.jl. We hope to continue its development and add features
like event handling to its IR.

## SUNDIALS J*v interface, stats, and preconditioners

While we are phasing out Sundials from our standard DifferentialEquations.jl
practice, the Sundials.jl continues to improve as we add more features to
benchmark against. Sundials' J*v interface has now been exposed, so adding a
DiffEqOperator to the `jac_prototype` will work with Sundials. `DEStats` is
hooked up to Sundials, and now you can pass preconditioners to its internal
Newton-Krylov methods.

# Next Directions

- Improved nonlinear solvers for stiff SDE handling
- More adaptive methods for SDEs
- Better boundary condition handling in DiffEqOperators.jl
- More native implicit ODE (DAE) solvers
- Adaptivity in the MIRK BVP solvers
- LSODA integrator interface
- Improved BDF
