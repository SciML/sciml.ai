@def rss_pubdate = Date(2019,6,24)
@def rss = """ DifferentialEquations.jl v6.6.0: Sparse Jacobian Coloring, Quantum Computer ODE Solvers, and Stiff SDEs """
@def published = " 24 June 2019 "
@def title = " DifferentialEquations.jl v6.6.0: Sparse Jacobian Coloring, Quantum Computer ODE Solvers, and Stiff SDEs "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

## Sparsity Performance: Jacobian coloring with numerical and forward differentiation

If you have a function `f!(du,u)` which has a Tridiagonal Jacobian, you could
calculate that Jacobian by mixing perturbations. For example, instead of doing
`u .+ [epsilon,0,0,0,0,0,0,0,...]`, you'd do `u .+ [epsilon,0,0,epsilon,0,0,...]`.
Because the `epsilons` will never overlap, you can then decode this "compressed"
Jacobian into the sparse form. Do that 3 times and boom, full Jacobian in
4 calls to `f!` no matter the size of `u`! Without a color vector, this matrix
would take `1+length(u)` `f!` calls, so I'd say that's a pretty good speedup.

This is called Jacobian coloring. `[1,2,3,1,2,3,1,2,3,...]` are the colors in
this example, and places with the same color can be differentiated simultaneously.
Now, the DiffEqDiffTools.jl internals allow for passing a color vector into the
numerical differentiation libraries and automatically decompressing into a
sparse Jacobian. This means that DifferentialEquations.jl will soon be compatible
with this dramatic speedup technique. In addition, other libraries in Julia with
rely on our utility libraries, like Optim.jl, could soon make good use of this.

What if you don't know a good color vector for your Jacobian? No sweat! The
soon to be released SparseDiffTools.jl repository has methods for automatically
generating color vectors using heuristic graphical techniques.
DifferentialEquations.jl will soon make use of this automatically if you specify
a sparse matrix for your Jacobian!

Note that the SparseDiffTools.jl repository also includes functions for calculating
the sparse Jacobians using color vectors and forward-mode automatic differentiation
(using Dual numbers provided by ForwardDiff.jl). In this case, the number of Dual
partials is equal to the number of colors, which can be dramatically lower than
the `length(u)` (the dense default!), thereby dramatically reducing compile
and run time.

Stay tuned for the next releases which begin to auto-specialize everything
along the way based on sparsity structure. Thanks to JSoC student Pankaj (@pkj-m)
for this work.

## Higher weak order SROCK methods for stiff SDEs

Deepesh Thakur (@deeepeshthakur) continues his roll with stiff stochastic
differential equation solvers by implementing not 1 but 7 new high weak order
stiff SDE solvers. SROCK1 with generalized noise, SKSROCK, and a bunch of
variants of SROCK2. Benchmark updates will come soon, but I have a feeling
that these new methods may be by far the most stable methods in the library,
and the ones which achieve the lowest error in the mean solution most efficiently.

## DiffEqBot

GSoC student Kanav Gupta (@kanav99) implemented a bot for the JuliaDiffEq
team that allows us to run performance regression benchmarks on demand with
preset Gitlab runners. Right now this has a dedicated machine for CPU and
parallelism performance testing, and soon we'll have a second machine
up and running for performance testing on GPUs. If you haven't seen the Julialang
blog post on this topic, [please check it out!](https://sciml.ai/blog/2019/06/diffeqbot).

## Quantum ODE Solver QuLDE

If you happen to have a quantum computer handy, hold your horses. `QuLDE` from
QuDiffEq.jl is an ODE solver designed for quantum computers. It utilizes the
Yao.jl quantum circuit simulator to run, but once Yao.jl supports QASM then
this will compile to something compatible with (future) quantum computing
hardware. This means that, in order to enter the new age of computing, all
you have to do is change `solve(prob,Tsit5())` to `solve(prob,QuLDE())` and you're
there. Is it practical? Who knows (please let us know). Is it cool? Oh yeah!

See [the quantum ODE solver blog post for more details](https://nextjournal.com/dgan181/julia-soc-19-quantum-algorithms-for-differential-equations).

## Commutative Noise GPU compatibility

The commutative noise SDE solvers are now GPU-compatible thanks to GSoC student
Deepesh Thakur (@deeepeshthakur). The next step will be to implement high order
non-commutative noise SDE solvers and the associated iterated integral
approximations in a manner that is GPU-compatible.

## New benchmark and tutorial repository setups

DiffEqBenchmarks.jl and DiffEqTutorials.jl are now fully updated to a Weave.jl
form. We still need to fix up a few benchmarks, but it's in a state that is ready
for new contributions.

## Optimized multithreaded extrapolation

The GBS extrapolation methods have gotten optimized, and they now are the one
of the most efficient methods at lower tolerances of the Float64 range for
non-stiff ODEs:

![non-stiff extrapolation](https://user-images.githubusercontent.com/1814174/59899185-d56a5e80-93c1-11e9-86a0-ea09bfaa59ed.png)

Thank you to Konstantin Althaus (@AlthausKonstantin) for contributing the first
version of this algorithm and GSoC student Saurabh Agarwal (@saurabhkgp21) for
adding automatic parallelization of the method.

This method will soon see improvements as multithreading will soon be improved
in Julia v1.2. The new PARTR features will allow our internal `@threads` loop
to perform dynamic work-stealing which will definitely be a good improvement to
the current parallelism structure. So stay tuned: this will likely benchmark
even better in a few months.

## Fully non-allocating exp! in exponential integrators

Thanks to Yingbo Ma (@YingboMa) for making the internal `exp` calls of the
exponential integrators non-allocating. Continued improvements to this category
of methods is starting to show promise in the area of semilinear PDEs.

## Rosenbrock-W methods

JSoC student Langwen Huang (@huanglangwen) has added the Rosenbrock-W class of
methods to OrdinaryDiffEq.jl. These methods are like the Rosenbrock methods
but are able to reuse their W matrix for multiple steps, allowing the method
to scale to larger ODEs more efficiently. Since the Rosenbrock methods
benchmark as the fastest methods for small ODEs right now, this is an exciting
new set of methods which will get optimized over the course of the summer.
Efficient Jacobian reuse techniques and the ability to utilize the sparse
differentiation tooling are next on this project.

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Higher order SDE methods for non-commutative noise
- Parallelized methods for stiff ODEs
- Integration of sparse colored differentiation into the differential equation solvers
- Jacobian reuse efficiency in Rosenbrock-W methods
- Exponential integrator improvements
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
- Automated matrix-free finite difference PDE operators
- Surrogate optimization
- GPU-based Monte Carlo parallelism
