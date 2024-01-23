@def rss_pubdate = Date(2024,1,23)
@def rss = """Why we deprecated NLsolve.jl for NonlinearSolve.jl for Solving Nonlinear Systems in Julia"""
@def published = " 23 January 2024 "
@def title = "Why we deprecated NLsolve.jl for NonlinearSolve.jl"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Why we deprecated NLsolve.jl for NonlinearSolve.jl for Solving Nonlinear Systems in Julia

In SciML, we have deprecated all direct NLsolve.jl interfaces to instead only support the
NonlinearSolve.jl interfaces. This fixes a bunch of issues, both in terms of bugs and correctness,
and reduces the support surface. We recommend that all downstream users update to make use of the
NonlinearSolve.jl as well.

## Introduction Video to NonlinearSolve.jl

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/O-2F8fBuRRg?si=6GGlCfzGrXL--YI2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
~~~

## Upgrade Path

As a direct upgrade path, NonlinearSolve.jl wraps the NLsolve.jl solvers. To use the wrapper, simply
do `using NLsolve` and use the `NLsolveJL()` solver in the `solve` call. This looks like:

```julia
using NonlinearSolve, NLsolve
f(u, p) = u .* u .- p
u0 = [1.0, 1.0]
p = 2.0
prob = NonlinearProblem(f, u0, p)
sol = solve(prob, NLsolveJL())
```

This can be used to update to the NonlinearSolve.jl interface while retaining exactly the same solver
which can make the transition easier. However, through the NonlinearSolve.jl interface one can then
explore other solves, many of which achieve higher performance and robustness than NLsolve.jl.

## Reasons for Changing to NonlinearSolve.jl

NLsolve.jl was widely used in the SciML ecosystem from around 2016 all the way through to 2023, what changed so that now all of those
interfaces will update to the new interface? This comes from a combination of factors. Here's a subset of the total discussion.

### Improvements to Performance and Robustness

NonlinearSolve.jl solves some of the performance issues of NLsolve.jl. NLsolve.jl did not have caching interfaces and even its direct
solve interface had more overhead than is necessary for many problems, which is demonstrated in the 
[SciMLBenchmarks](https://docs.sciml.ai/SciMLBenchmarksOutput/stable/). While NLsolve.jl does have a good showing in the benchmarks
in comparison to prior tools such as CMINPACK (i.e. SciPy), NonlinearSolve.jl eeks out an extra level of performance across the board,
and many new robust methods.

![](https://private-user-images.githubusercontent.com/1814174/298835853-ec2eb0ee-2e9a-4c27-9a6c-aa9b1fad7eca.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDU5OTQxMTksIm5iZiI6MTcwNTk5MzgxOSwicGF0aCI6Ii8xODE0MTc0LzI5ODgzNTg1My1lYzJlYjBlZS0yZTlhLTRjMjctOWE2Yy1hYTliMWZhZDdlY2EucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyMyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjNUMDcxMDE5WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YmFjYmYyYjY5YzVlNTE0NDc1YmFkZDU3MTMyMjliMGI2ODBmNDgwZTkzM2U1M2U4YTQ5NjdhOTg2MDE3NWYxYyZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.k12Hi7AaogHM1RPxssuXzZU4hgGh2VKbH3Cueuw3YxA)

### Proper Handling of Sparsity and Linear Solvers

NLsolve.jl allows for supplying a sparse matrix, but it does not fully make use of the sparsity. For example, it still computes the Jacobian
matrix as a complete dense object. NonlinearSolve.jl makes use of [SparseDiffTools.jl](https://github.com/JuliaDiff/SparseDiffTools.jl)
in order to perform matrix coloring and construct sparsity-specific differentiation passes. This can change the number of calls to `f` in
order to calculate a Jacobian from O(n) to small constant O(1) in many important cases, for example the calculation of a tridiagonal
Jacobian goes from the number of columns to to simply 3 `f` calls with this change.

Additionally, NLsolve.jl did not integrate with [LinearSolve.jl](https://github.com/SciML/LinearSolve.jl) which made it much more
difficult to swap out to the correct linear solver. This also means that the improved defaults of LinearSolve.jl are not applied to 
the user's function. For example, on Mac M-series chips it's much faster to use AppleAccelerate BLAS backends for the LU-factorization
but NLsolve.jl uses OpenBLAS by default instead. On x86 platforms it defaults to OpenBLAS instead of directly interfacing with the MKL_jll
binaries, which is a major slowdown on any Intel or AMD CPU which is not an AMD EPYC. LinearSolve.jl's defaulting system accounts for
these nuanances, and this alone can account for a nearly 2x performance difference
[as demonstrated by many user benchmarks](https://github.com/SciML/LinearSolve.jl/issues/357#issuecomment-1669714631).

![](https://github.com/SciML/LinearSolve.jl/issues/357#issuecomment-1669714631)

Users of NLsolve.jl are required to know to `using AppleAccelerate` or `using MKL` based on what is the optimal backend given their CPU.
However, we have found over the years that most users do not know what BLAS/LAPACK is and would prefer the library developers do
CPU-specific optimizations in the library itself, and this change now to using NonlinearSolve.jl now takes that burden from the user 
to the library developer (it can be overriden, but the defaults try to be smart).

### Automatic Differentiation Integration

Automatic differentation of a nonlinear solver can be much smart. For mathematical details, see 
[this paper](https://arxiv.org/abs/2201.12240). At a high level, what is meant by this is that calculating the derivative of the solution
to a nonlinear system does not require differentiating the solver and instead can be done in a single step.

NLsolve.jl does not integrate with automatic differenitation libraries. NonlinearSolve.jl integrates at a very deep level, having a
defaulting system on the choice of vjp in order to achieve performance and allow for compatability with the standard mutable function
form, and ensuring performance. Here is NonlinearSolve.jl building a loss function defined by the sum of the solution vector to the
nonlinear system and differentiating that loss function with respect to the parameters that define the nonlinear system:

```julia
u0 = [0.0]
p = [2.0, 1.0]
prob = NonlinearProblem((du, u, p) -> du[1] = u[1] - p[1] + p[2], u0, p)

function test_loss(p, prob; alg = NewtonRaphson())
    _prob = remake(prob, p = p)
    sol = sum(solve(_prob, alg))
    return sol
end
dp1 = Zygote.gradient(p -> test_loss(p, prob), p)[1]
```

Note that this is using the O(1)-backpropagation adjoint rule, also known as "implicit differentiation". There's no special packages
required to make this work, it just works.

This fixes many issues with nonlinear solver integration into many downstream libraries as AD support is a generally crucial feature
throughout SciML. And note that this is generic to the algorithm, and thus the best way to make NLsolve.jl compatible with AD is to
simply use it through the NonlinearSolve.jl interface, which is why for upgrade and compatability reasons this is always done during
the deprecation process.

We note that this applies to forward-mode AD as well. NonlinearSolve.jl has special integration with ForwardDiff to ensure that the
AD system does not differentiate the solver and instead applies a forward implicit differentiation rule automatically, improving the
performance. This removes the nested differentiation required in the Jacobian calculations, since naively it would differentiate the
differentiation, which is a very expensive process that is simply eliminated.

### No Allocation and Static Compilation

NonlinearSolve.jl has a no-allocation and static compilation compatible mode via the SimpleNonlinearSolve.jl set of solvers. All you have
to do is swap out the solver and ensure you're using static arrays and numbers:

```julia
using SimpleNonlinearSolve, StaticArrays

f(u, p) = u .* u .- p
u0 = SA[1.0, 1.0]
p = 2.0
prob = NonlinearProblem(f, u0, p)
sol = solve(prob, SimpleNewtonRaphson())
```

and it compiles to a purely-static solve with 0 allocations. This can be used in GPU kernels, static binary builds, and many other
applications that want a very fast and simple to compile nonlinear solver. Importantly, this gives all of these features to the
nonlinear solver without changing the interface, and is thus a key piece required in the downstream GPU compatability of many
SciML libraries. The need for this feature alone is what caused the NonlinearSolve.jl project to start, and thus it's a highly-tested
and central part of why we are deprecating all of the NLsolve.jl interfaces in favor of now only using the NonlinearSolve.jl ones.

### GPU Compatibility

NLsolve.jl had spotty compatability with GPUs. It did not have comprehensive GPU support, for example ensuring it generates appropriate
sparse matrices on the GPU if a sparse matrix is supplied, ensure that every internal operation is broadcasted together to reduce the
number of GPU kernels, etc. But most importantly, it did not test GPU support as part of its CI processes so the GPU support that it did
have was not robust. With NonlinearSolve.jl being regularly used in DeepEquilibriumNetworks, it is a regular use case to mix it with
automatic differentiation, neural networks, and GPUs. Therefore these use cases are much more battle-tested and captured in CI/CD
processes.

### Unification of Interfaces

Finally, NonlinearSolve.jl unifies the interface with the rest of SciML. Just like everything else, this makes the process simply
`NonlinearProblem` then `solve`. Passing algorithms is you just pass the struct, i.e. `TrustRegion()`. The documentation is all
[in the SciMLDocs](https://docs.sciml.ai/NonlinearSolve/stable/). This makes the whole API much more streamlined and simple in comparison
to having NLsolve.jl around, where suddenly algorithm choices for the nonlinear solver were `:trustregion`, something foreign to the
rest of SciML.

This makes the interfaces easier to document to the user. When NonlinearSolve.jl is used in a downstream component like an ODE solver,
we can simply say "provide a nonlinear solver from NonlinearSolve.jl. For more information, see the NonlinearSolve.jl documentation",
and it will have a clear flow in the same docs system and a clear flow to similar syntax to the user. This unification and integration
cannot be understated.

## Conclusion

All interfaces in SciML which previously used NLsolve.jl are now deprecated for NonlinearSolve.jl. Any use of the old interfaces will
throw a warning to update. The upgrade process is straightforward and through the wrapper functionality. This change improves
performance, robustness, CI/CD testing, sparsity handling, GPU support, automatic differentiation, no allocation modes, and static
compilation. As a result, it achieves some of the major goals of the SciML organization, i.e. ensuring compatability of numerical solvers
to the vast array of alternative applications and connections to machine learning without requiring that the user do anything special.
Therefore, we are extremely happy with this change and hope all users will be too.