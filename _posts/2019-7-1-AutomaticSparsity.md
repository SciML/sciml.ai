---
layout: post
title:  "DifferentialEquations.jl v6.7.0: GPU-based Ensembles"
date:   2019-6-24 12:00:00
categories:
---

In this release we are getting the culmination of our ongoing sparsity story.
Let's demonstrate what this looks like. Assume you have an `f` with a sparse
Jacobian which defines a stiff ODE.

## (Breaking with Deprecations) DiffEqGPU: GPU-based Ensemble Simulations

The `MonteCarloProblem` interface received an overhaul. First of all, the
interface has been renamed to `Ensemble`. The changes are:

- `MonteCarloProblem` -> `EnsembleProblem`
- `MonteCarloSolution` -> `EnsembleSolution`
- `MonteCarloSummary` -> `EnsembleSummary`

**Specifying `parallel_type` has been deprecated** and a deprecation warning is
thrown mentioning this. So don't worry: your code will work but will give
warnings as to what to change. Additionally, **the DiffEqMonteCarlo.jl package
is no longer necessary for any of this functionality**.

Now, `solve` of a `EnsembleProblem` works on the same dispatch mechanism as the
rest of DiffEq, which looks like `solve(monteprob,Tsit5(),EnsembleThreads())`
where the third argument is an ensembling algorithm to specify the
threading-based form.  Code with the deprecation warning will work until the
release of DiffEq 7.0, at which time the alternative path will be removed.

The change to dispatch was done for a reason: it allows us to build new libraries
specifically for sophisticated handling of many trajectory ODE solves without
introducing massive new dependencies to the standard DifferentialEquations.jl
user. However, many people might be interested in the first project to make
use of this: DiffEqGPU.jl. DiffEqGPU.jl let's you define a problem, like an
`ODEProblem`, and then solve thousands of trajectories in parallel using your
GPU. The syntax looks like:

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

## Color Differentiation Integration with Native Julia DE Solvers

The `ODEFunction`, `DDEFunction`, `SDEFunction`, `DAEFunction`, etc. constructors
now allow you to specify a color vector. This will reduce the number of `f`
calls required to compute a sparse Jacobian, giving a massive speedup to the
computation of a Jacobian and thus of an implicit differential equation solve.
The color vectors can be computed automatically using the SparseDiffTools.jl
library's `matrix_colors` function. Thank JSoC student Langwen Huang (@huanglangwen)
for this contribution.

## GPU-Optimized Sparse (Colored) Automatic Differentiation

## Parallelized Implicit ODE Solvers

## High Strong Order Methods for Non-Commutative Noise SDEs

## Jacobian reuse efficiency in Rosenbrock-W methods

## Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl

## Exponential integrator improvements

Thanks to Yingbo Ma (@YingboMa), the exprb methods have been greatly improved.

# Next Directions

Our current development is very much driven by the ongoing GSoC/JSoC projects,
which is a good thing because they are outputting some really amazing results!

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Surrogate optimization
