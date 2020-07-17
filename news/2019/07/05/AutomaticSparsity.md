@def rss_pubdate = Date(2019,7,5)
@def rss = """ DifferentialEquations.jl v6.7.0: GPU-based Ensembles and Automatic Sparsity """
@def published = " 5 July 2019 "
@def title = " DifferentialEquations.jl v6.7.0: GPU-based Ensembles and Automatic Sparsity "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Let's just jump right in! This time we have a bunch of new GPU tools and
sparsity handling.

## (Breaking with Deprecations) DiffEqGPU: GPU-based Ensemble Simulations

The `MonteCarloProblem` interface received an overhaul. First of all, the
interface has been renamed to `Ensemble`. The changes are:

- `MonteCarloProblem` -> `EnsembleProblem`
- `MonteCarloSolution` -> `EnsembleSolution`
- `MonteCarloSummary` -> `EnsembleSummary`
- `num_monte` -> `trajectories`

**Specifying `parallel_type` has been deprecated** and a deprecation warning is
thrown mentioning this. So don't worry: your code will work but will give
warnings as to what to change. Additionally, **the DiffEqMonteCarlo.jl package
is no longer necessary for any of this functionality**.

Now, `solve` of a `EnsembleProblem` works on the same dispatch mechanism as the
rest of DiffEq, which looks like `solve(ensembleprob,Tsit5(),EnsembleThreads(),trajectories=n)`
where the third argument is an ensembling algorithm to specify the
threading-based form.  Code with the deprecation warning will work until the
release of DiffEq 7.0, at which time the alternative path will be removed.

See the [updated ensembles page for more details](https://docs.juliadiffeq.org/latest/features/ensemble)

The change to dispatch was done for a reason: it allows us to build new libraries
specifically for sophisticated handling of many trajectory ODE solves without
introducing massive new dependencies to the standard DifferentialEquations.jl
user. However, many people might be interested in the first project to make
use of this: [DiffEqGPU.jl](https://github.com/JuliaDiffEq/DiffEqGPU.jl).
DiffEqGPU.jl lets you define a problem, like an `ODEProblem`, and then solve
thousands of trajectories in parallel using your GPU. The syntax looks like:

```julia
monteprob = EnsembleProblem(my_ode_prob)
solve(monteprob,Tsit5(),EnsembleGPUArray(),num_monte=100_000)
```

and it will return 100,000 ODE solves. **We have seen between a 12x and 90x speedup
depending on the GPU of the test systems**, meaning that this can be a massive
improvement for parameter space exploration on smaller systems of ODEs.
Currently there are a few limitations of this method, including that events
cannot be used, but those will be solved shortly. Additional methods for
GPU-based parameter parallelism are coming soon to the same interface. Also
planned are GPU-accelerated multi-level Monte Carlo methods for faster weak
convergence of SDEs.

Again, this is utilizing compilation tricks to take the user-defined `f`
and recompile it on the fly to a `.ptx` kernel, and generating kernel-optimized
array-based formulations of the existing ODE solvers

## Automated Sparsity Detection

Shashi Gowda (@shashigowda) implemented a sparsity detection algorithm which
digs through user-defined Julia functions with Cassette.jl to find out what
inputs influence the output. The basic version checks at a given trace, but
a more sophisticated version, which we are calling Concolic Combinatoric Analysis,
looks at all possible branch choices and utilizes this to conclusively build a
Jacobian whose sparsity pattern captures the possible variable interactions.

The nice part is that this functionality is very straightforward to use.
For example, let's say we had the following function:

```julia
function f(dx,x,p,t)
  for i in 2:length(x)-1
    dx[i] = x[i-1] - 2x[i] + x[i+1]
  end
  dx[1] = -2x[1] + x[2]
  dx[end] = x[end-1] - 2x[end]
  nothing
end
```

If we want to find out the sparsity pattern of `f`, we would simply call:

```julia
sparsity_pattern = sparsity!(f,output,input,p,t)
```

where `output` is an array like `dx`, `input` is an array like `x`, `p`
are possible parameters, and `t` is a possible `t`. The function will then
be analyzed and `sparsity_pattern` will return a `Sparsity` type of `I` and `J`
which denotes the terms in the Jacobian with non-zero elements. By doing
`sparse(sparsity_pattern)` we can turn this into a `SparseMatrixCSC` with the
correct sparsity pattern.

This functionality highlights the power of Julia since there is no way to
conclusively determine the Jacobian of an arbitrary program `f` using numerical
techniques, since all sorts of scenarios lead to "fake zeros" (cancelation,
not checking a place in parameter space where a branch is false, etc.). However,
by directly utilizing Julia's compiler and the SSA provided by a Julia function
definition we can perform a non-standard interpretation that tells all of the
possible numerical ways the program can act, thus conclusively determining
all of the possible variable interactions.

Of course, you can still specify analytical Jacobians and sparsity patterns
if you want, but if you're lazy... :)

See [SparsityDetection.jl's README for more details](https://github.com/JuliaDiffEq/SparsityDetection.jl).

## GPU Offloading in Implicit DE Solving

We are pleased to announce the `LinSolveGPUFactorize` option which allows for
automatic offloading of linear solves to the GPU. For a problem with a large
enough dense Jacobian, using `linsolve=LinSolveGPUFactorize()` will now
automatically perform the factorization and back-substitution on the GPU,
allowing for better scaling. For example:

```julia
using CuArrays
Rodas5(linsolve = LinSolveGPUFactorize())
```

This simply requires a working installation of CuArrays.jl. See
[the linear solver documentation for more details](https://docs.juliadiffeq.org/latest/features/linear_nonlinear).

## Experimental: Automated Accelerator (GPU) Offloading

We have been dabbling in allowing automated accelerator (GPU, multithreading,
distributed, TPU, etc.) offloading when the right hardware is detected and the
problem size is sufficient to success a possible speedup.
[A working implementation exists as a PR for DiffEqBase](https://github.com/JuliaDiffEq/DiffEqBase.jl/pull/273)
which would allow automated acceleration of linear solves in implicit DE solving.
However, this somewhat invasive of a default, and very architecture dependent,
so it is unlikely we will be releasing this soon. However, we are investigating
this concept in more detail in the [AutoOffload.jl](https://github.com/JuliaDiffEq/AutoOffload.jl). If you're interested in Julia-wide automatic acceleration,
please take a look at the repo and help us get something going!

## A Complete Set of Iterative Solver Routines for Implicit DEs

Previous releases had only a pre-built GMRES implementation. However, as
detailed on the [linear solver page](https://docs.juliadiffeq.org/latest/features/linear_nonlinear),
we now have an array of iterative solvers readily available, including:

- LinSolveGMRES – GMRES
- LinSolveCG – CG (Conjugate Gradient)
- LinSolveBiCGStabl – BiCGStabl Stabilized Bi-Conjugate Gradient
- LinSolveChebyshev – Chebyshev
- LinSolveMINRES – MINRES

These are all compatible with matrix-free implementations of a
`AbstractDiffEqOperator`.

## Exponential integrator improvements

Thanks to Yingbo Ma (@YingboMa), the exprb methods have been greatly improved.

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Surrogate optimization
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
- High Strong Order Methods for Non-Commutative Noise SDEs
- GPU-Optimized Sparse (Colored) Automatic Differentiation
- Parallelized Implicit Extrapolation of ODEs
