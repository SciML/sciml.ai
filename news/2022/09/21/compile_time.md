@def rss_pubdate = Date(2022,9,21)
@def rss = """How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1"""
@def published = " 21 September 2022 "
@def title = "How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1

We did it. We got control of our compile times in a large-scale >100,000 line of code
Julia library. The end result looks like:

![](https://user-images.githubusercontent.com/1814174/185794444-34a99f53-646a-4cbb-81a3-678bb2e13a17.gif)

However, the most important thing is the friends we made along the way. In this blog
post we will go through a step-by-step explanation of the challenges to compile times,
ways to understand and debug compile-time issues, how to directly control specialization 
to avoid recompilation, and finally how to setup snoop precompilation on packages to
enable easy system image building. We will describe the changes made to Julia in v1.8
which were necessary in order for this win, and the underlying trade-offs made with
these changes. With an understanding of what we have done and why,
this process for reducing Julia package compile times is easily reproducible to the
rest of the ecosystem. So let's get started!

Note: this is meant to be a human-readable summary of the 
[original thread on compile times found in the DifferentialEquations.jl repository](https://github.com/SciML/DifferentialEquations.jl/issues/786)

## Starting the Process: Profiling Why OrdinaryDiffEq First Solve Time Was 30 Second Compilation

First let's introduce our challenger. Up at bat and standing strong at 12 lines of code is a
formidable opponent: a stiff ODE solve. The code looks like this:

```julia
@time begin
  using OrdinaryDiffEq
  function lorenz(du,u,p,t)
      du[1] = 10.0(u[2]-u[1])
      du[2] = u[1]*(28.0-u[3]) - u[2]
      du[3] = u[1]*u[2] - (8/3)*u[3]
  end
  u0 = [1.0;0.0;0.0]; tspan = (0.0,100.0)
  prob = ODEProblem(lorenz,u0,tspan)
  solve(prob,Rodas5())
end
```

When we [started out compile-time journey on August 13, 2021](https://github.com/SciML/DifferentialEquations.jl/issues/786),
this small and widely used code took nearly 22 seconds for the first `solve` call. Note that
in the early phase we did not track `using OrdinaryDiffEq` time, which together brings the
time for this code chunk to around 30 seconds.

But why? The major improvement which came to the Julia language in the summer of 2021, which kicked
off this project, was the ability to profile compile times. To do this, one uses a mixture of
the package [SnoopCompile.jl](https://github.com/timholy/SnoopCompile.jl) with the flamegraph
viewing package [ProfileView.jl](https://github.com/timholy/ProfileView.jl). When we did that back
in the early phase of this project, the profiling code was:

```julia
using OrdinaryDiffEq, SnoopCompile

function lorenz(du,u,p,t)
 du[1] = 10.0(u[2]-u[1])
 du[2] = u[1]*(28.0-u[3]) - u[2]
 du[3] = u[1]*u[2] - (8/3)*u[3]
end

u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
prob = ODEProblem(lorenz,u0,tspan)
alg = Rodas5()
tinf = @snoopi_deep solve(prob,alg)
```

```julia
@show tinf
InferenceTimingNode: 1.460777/16.030597 on Core.Compiler.Timings.ROOT() with 46 direct children
```

The way to read this is that there was `1.460777` seconds of LLVM code generation time and 
`16.030597` seconds of inference time with 46 inference gaps (due to some uninferred portion) of the
code. [Note that this is the result after some optimizations were already in place]. This tells us
that there are potentially 16 seconds of inference time that could be precompiled away.

Additionally, we can get a flamegraph of the compile-time profile as follows:

```julia
using ProfileView
ProfileView.view(flamegraph(tinf))
```

![](https://user-images.githubusercontent.com/1814174/129282082-ac51270f-5843-4bcc-a452-8aa663c458b8.png)

A flamegraph is a representation of a profile where every bar is a line of code, moving vertically moves
down the call stack (for example, `g(f(x))` would have the time for `g(y)` over the time for `f(x)`),
and the horizontal bar represents the percentage of the time taken by a given function. From this you can
see two things. First of all, most of the time is in one large sized chunk whose function is labelled
`linear_nonlinear.jl`: we will go into this piece in detail. Then there is a small set of chunks to the
right which have a repeated structure, that points to a function in 
[FastBroadcast.jl](https://github.com/YingboMa/FastBroadcast.jl) for `@..` lowering, and finally there
are some decently-sized gaps in the graph. The gaps correspond to things which are not measured. The
snooping process only profiles the Julia inference time, not the LLVM compile time. Our goal will be
to get "everything we can into a gap".

## Interlude on the Biggest Chunk of Compile-Time: RecursiveFactorization

So first let's answer how the compile time got to an absurd 30 seconds. Stiff ODE solvers are much more
complex than methods for non-stiff equations because they need to do things like solve nonlinear equations.
Solving nonlinear equations requires the repeated solving of linear equations, i.e. solving `Ax = b` for
`x`. In most programming languages, the linear algebra handling for these kinds of standard operations
is performed by underlying libraries called the BLAS and LAPACK library. Most open source projects use
[an implementation called OpenBLAS](https://github.com/xianyi/OpenBLAS), a C implementation of BLAS/LAPACK
which does many of the tricks required for getting much higher performance than "simple" codes by using
CPU-specialized kernels based on the sizes of the CPU's caches. Open source projects like R and SciPy
also ship with OpenBLAS because of its generally good performance and open licensing, though it's known
that OpenBLAS is handedly outperformed by [Intel MKL](https://www.intel.com/content/www/us/en/develop/documentation/get-started-with-mkl-for-dpcpp/top.html)
which is a vendor-optimized BLAS/LAPACK implementation for Intel CPUs (which works on AMD CPUs as well).
Given its licensing, most open source projects cannot (and thus do not) ship with a binary of MKL even
though it is known to perform better in many circumstances.

In the Julia world and juiced with a need for speed, a package wrapping Intel's MKL,
[MKL.jl](https://github.com/JuliaLinearAlgebra/MKL.jl), exists and does a global swap of the BLAS/LAPACK
bindings from the current library (default OpenBLAS) to MKL. The underlying mechanism of this swap,
[libblastrampoline](https://github.com/JuliaLinearAlgebra/libblastrampoline), has a fantastic
[video by Elliot Saba from JuliaCon 2021](https://www.youtube.com/watch?v=t6hptekOR7s). However,
as a maintainer of one of the widest used Julia package organizations out there (with ~25% of all
unique IPs downloading the SciMLBase.jl package in some form according to the package server),
it would be very disruptive to simply add `using MKL` to our codebase and do a global preference swap
for the user. Telling users to do this in documentation would mean that one has "bad performance by
default" unless they read deep into the documentation, an unsettling result for any Julia developer.
So we looked to build an alternative.

Because the stiff ODE solvers only required a single LAPACK operation to solve `Ax = b`, the LU-factorization
performed within the call `A\b`, we developed a pure Julia implementation of the LU-factorization
as [RecursiveFactorization.jl](https://github.com/JuliaLinearAlgebra/RecursiveFactorization.jl). 

(Okay I lied, after the LU-factorization you need to do a backsolve, which is performed by 
[TriangularSolve.jl](https://github.com/JuliaSIMD/TriangularSolve.jl), but that's a small detail
so let's get back to the main story)

This RecursiveFactorization.jl used tools from the [JuliaSIMD](https://github.com/JuliaSIMD)
stack, mainly [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl) and
[Polyester.jl's low-overhead threading model](https://github.com/JuliaSIMD/Polyester.jl), to
generate architecture-specific compute kernels with efficient multithreading. After a great lift
done by @chriselrod and @yingboma on this front, the results became very clear that this new
LU-factorization codebase completely stomped OpenBLAS out of the water, achieving more than a
2x performance boost for matrices smaller than 500x500. But surprisingly, on some CPU architectures
RecursiveFactorization.jl was seeing up to 50% over the well-optimized MKL library (and interestingly,
there's a heavy correlation between "seeing a really good result" and "having benchmarked on an AMD CPU").
More details about this can be found [in a pull request](https://github.com/JuliaLinearAlgebra/RecursiveFactorization.jl/pull/28)
and in [Chris Elrod's JuliaCon 2021 talk on pure Julia linear algebra functions](https://www.youtube.com/watch?v=KQ8nvlURX4M).

![](https://user-images.githubusercontent.com/8043603/124346090-dafeff80-dbaa-11eb-839a-c110cede6d34.png)
![](https://user-images.githubusercontent.com/8043603/124346095-e2260d80-dbaa-11eb-97b4-062b0470150b.png)

With us now seeing results like:

```julia
Progress:   6%
█████████                                                                                                                           |  ETA: 0:49:51
  Size:                    (17, 17)
  RecursiveFactorization:  (MedianGFLOPS = 3.053, MaxGFLOPS = 5.323)
  MKL:                     (MedianGFLOPS = 2.047, MaxGFLOPS = 2.198)
  OpenBLAS:                (MedianGFLOPS = 2.509, MaxGFLOPS = 2.762)
  
Progress:   6%
████████                                                                                                                            |  ETA: 0:50:05
  Size:                    (486, 486)
  RecursiveFactorization:  (MedianGFLOPS = 61.48, MaxGFLOPS = 63.66)
  MKL:                     (MedianGFLOPS = 44.45, MaxGFLOPS = 46.02)
  OpenBLAS:                (MedianGFLOPS = 30.56, MaxGFLOPS = 31.42)
```

meaning about 1.5x-2x faster than what we had before, it was a no-brainer to incorporate this into the
ODE solver stack. Stiff ODEs are very LU-factorization bound, and therefore 2x faster LU-factorizations
can mean about a 2x performance improvement.

But of course, we now have replaced a prebuilt C binary with a just-in-time (JIT) compiled Julia code
and thus had to pay the JIT price in new sessions. This JIT price, with its automated CPU architecture
detection and specialization, cost over 17 seconds, and was thus the major player in our 22 seconds
first `solve` time. Ouch.

## Solving the RecursiveFactorization Compile-Times: Taking Control of Precompilation

Instead of backing down from this challenge, we decided to just figure out how to make Julia's
precompilation system better and work for us. With a 
[newly received CZI grant to the SciML organization](https://sciml.ai/news/2021/08/31/czi/),
we called in the help of [Dr. Tim Holy](https://neuroscience.wustl.edu/people/timothy-holy-phd/),
one of Julia's core compiler engineers behind the precompilation tooling, to help us untangle this
mess. Our goal was to make as few performance comprimises as possible but achieve 0.1 seconds
of compile-time. Luckily, our goal was in reach. Let's take another look at that compilation profile:

![](https://user-images.githubusercontent.com/1814174/129282082-ac51270f-5843-4bcc-a452-8aa663c458b8.png)

The largest chunk was the DiffEqBase.jl linear solver code, which we now know is almost entirely due to
the compilation of RecursiveFactorization.jl. However, the process `A\b` on 64-bit floating point numbers
is a very standard thing which could in theory be compiled once and reused in all sessions. There were
two major questions to solve:

* Why is Julia's precompilation mechanism not storing this LU-factorization call?
* How do we improve the compile-times of things which are not precompiled?

Let's dig in.

### Why is Julia's precompilation mechanism not storing this LU-factorization call?

The answer to the first question comes down to the interaction between package precompilation and
multiple dispatch. Let's assume we had the package:

```julia
module MyPackage
f(x,y) = x * y
end
```

How long should precompilation of this package take? On one hand the answer is "that should be quick, it's
simple!". However, `f(x,y)` is unbounded on the types that it can take, so therefore you *could*
precompile a whole lot of different methods of `f(x,y)`. And indeed if you want to fully cover all of the
possibilities for what `f(x::T,y::T2)` could call, you have a lot of possibilities. You have
`f(::Float64,::Float64)`, `f(::Int32, ::Int32)`, etc. we were thinking about numbers, but `"hi " * "there"`
is also valid since `*` in Julia is string concatenation. `f(::Dict,::Dict)` is a method too: it throws
an error, but it's a valid method of `f`. And so on. If you have `n` types in your Julia setup, then
`f` has `n^2` possible methods. Precompilation doesn't sound so simple anymore?

Thus in order to prevent a combinatoric explosion in compile times, Julia does not eagerly compile every
possible method to `f` that could be called. Instead, it chooses to precompile functions based on the
methods of `f` that it actually sees used. Because precompilation occurs at the time of `using`, i.e.
when the user first calls `using MyPackage` or `import MyPackage` (note in v1.7+ that's now moved to
the package installation time in order to be performed in parallel), the methods of `f` that are precompiled
are the methods of `f` which are called in the top-level of the module during `using` time. 

In other words, since in our module `MyPackage` `f` is defined but no methods of `f` are used, there 
are no methods of `f` which are precompiled. Yay, we stopped combinatorial precompilation growth!

This alludes to a simple fix: just call the methods that you need. For example, in the example `MyPackage`,
we can force the precompilation mechanism to precompile `f` on many standard number types by doing:

```julia
module MyPackage
f(x,y) = x * y

let
  f(1.0,1.0)
  f(1,1)
  f(Int32(1),1)
  f(1.0,Int128(1))
end
end
```

and etc. You can make a loop over the types you want and do the combination of all calls. Of course
this has two downsides. One has to be semi-explicit about what to precompile. By semi-explicit
I mean that you do not necessarily have to call `f` on every type combination, but you do need to
call some function which calls `f` on that type combination. Because most packages tend to have
a large number of commonly reused functions, this means that a few top-level calls will cause
"most" of the useful parts of the package to precompile, so it's not that much of a limitation,
but still it's something to consider. And secondly, this requires the function to be run at `using`
time. 

To solve this second problem, on July 25th 2022 Tim Holy released a new package, 
[SnoopPrecompile.jl](https://discourse.julialang.org/t/ann-new-package-snoopprecompile/84778),
which allows the internal calls of such a block to be "snooped", making it so the function calls
do not have to be run at `using` time. Thus the "proper" form of `MyPackage` to force compilation
now looks like:

```julia
module MyPackage
f(x,y) = x * y

import SnoopPrecompile
SnoopPrecompile.@precompile_all_calls begin
  f(1.0,1.0)
  f(1,1)
  f(Int32(1),1)
  f(1.0,Int128(1))
end
end
```

which will trace the function calls at precompilation time but "turn off" the calls for normal usings.

So what was the answer to the first question:

> Why is Julia's precompilation mechanism not storing this LU-factorization call?

The answer was that nobody told it to. So now, you see a precompile snoop
[at the top level of the OrdinaryDiffEq.jl module](https://github.com/SciML/OrdinaryDiffEq.jl/blob/v6.27.1/src/OrdinaryDiffEq.jl#L207-L333)
which covers the standard ODE solver calls, which then causes the internals such as RecursiveFactorization.jl
to be snooped and thus be precompiled. Therefore, problem solved... on Julia v1.8.

### Why only on Julia v1.8? What changed to allow for "more" precompilation?

I'm glad you asked. The reason is because a major change in the Julia compiler stack from Tim Holy
which was introduced in Julia v1.8 is required in order to allow for almost all (I'll describe "almost all")
calls to precompile. If you look at the 
[Julia v1.8 release notes](https://docs.julialang.org/en/v1/NEWS/#Compiler/Runtime-improvements) you'll see
an obscure mention of a change in the Julia compiler:

> Precompilation (with explicit precompile directives or representative workloads) now saves more type-inferred code, resulting in reduced time-to-first task for packages that use precompilation. This change also eliminates the runtime performance degradation occasionally triggered by precompilation on older Julia versions. More specifically, any newly-inferred method/type combinations needed by your package–regardless of where those methods were defined–can now be cached in the precompile file, as long as they are inferrably called by a method owned by your package (#43990).

Let's break down what [this pull request](https://github.com/JuliaLang/julia/pull/43990) is actually doing.
Assume we have the `MyPackage` package from before:

```julia
module MyPackage
f(x,y) = x * y

import SnoopPrecompile
SnoopPrecompile.@precompile_all_calls begin
  f(1.0,1.0)
  f(1,1)
  f(Int32(1),1)
  f(1.0,Int128(1))
end
end
```

and now assume we build a package which builds on top of the functionality of `MyPackage`:

```julia
module MyPackage2
g(x,y) = f(x,y) + x
end
```

Now, just like before, I want to reduce the time to first calls of `g` by forcing precompilation.
Let's do it the same way as on `MyPackage`:

```julia
module MyPackage2
g(x,y) = f(x,y) + x

import SnoopPrecompile
SnoopPrecompile.@precompile_all_calls begin
  g(1.0,1)
end
end
```

Before Julia v1.8, this will *not* cause `g(::Float64, ::Int)` to be a precompiled method, and the
reason is ownership. Our `MyPackage` has precompiled the methods `f(::Float64, ::Float64)`,
`f(::Int, ::Int)`,  `f(::Int32, ::Int)`, and `f(::Float64, ::Int128)`. However, because 
`g(::Float64, ::Int)` needs the method `f(::Float64, ::Int)` which is not part of the `MyPackage`
precompilation, this would mean it does not have the necessary components to precompile and would
discard the precompilation. 

The reason for this potential ownership issue is because `f` belongs to `MyPackage`, while the
types in the signature, `Float64` and `Int`, belongs to Base. Because none of these entities
belong to `MyPackage2`, the precompiled function cannot belong to `MyPackage2`, and because
`MyPackage2` was the first to request this precompiled function it would then be discarded.
This was the rule before Julia v1.8. The reason for this rule is because if this precompilation
is invoked later in the process at the `MyPackage2` time, in order to not invalidate the
precompilation of `MyPackage`, the new precompiled code would need to live with `MyPackage2`.
"So just put it in `MyPackage2`?" The reason to be a bit conservative here is because if this
precompiled function only exists in `MyPackage2`, you could have methods which duplicate.
For example, `MyPackage3` might depend on `MyPackage` (and importantly, not depend on `MyPackage2`)
and might ask to precompile the same method `f(::Float64, ::Int)`. If the precompiled file is
to live with the first package to request it, you have two choices: either don't precompile
`f(::Float64, ::Int)` at all, or have the precompiled `f(::Float64, ::Int)` in both `MyPackage2`
and `MyPackage3`.

For the earlier versions of the Julia precompilation system, the conservative approach of simply
discarding such methods was the right approach. Because the number of precompiled functions
increases the time to precompile and the time to load (`using`) a package, who knows what the 
effect would be on the true first `solve` time? A priori it's impossible to predict because it
depends on how the packages decide to ask for precompilation. However, in 2022 we have much
deeper dependency stacks, some packages having Base functionality defined 30 packages down, and
if one package in the system misses the method that is required, much of precompilation could then
be discarded. The question is then an empirical one: in our current package environment,
is discarding such methods beneficial or detrimental? Tim Holy implemented a mechanism for
packages to hold onto such "external CodeInstances" (methods whose types are owned by a separate
package) and [performed an empirical analysis in the PR](https://github.com/JuliaLang/julia/pull/43990).

![](https://user-images.githubusercontent.com/1525481/154699530-b22023c9-8ad8-4329-a14c-ba354564bb29.png)

What this shows is that by moving from the v1.7 master behavior ("master") to either full precompilation
("full") or a pruned version ("prune"), more is precompiled with the package `.ji` files, the load
times are increased, and the "time to first x" (i.e. the time to the first significant call, so for
example the total time for the first solve as is measured at the top of this post) is decreased. In other
words, while this does lead to an increase in load times, the existence of the precompilation is
beneficial enough to that the total startup time is still very significantly decreased. For this reason,
the ownership requirement was dropped and now on Julia v1.8 and above, `f(::Float64, ::Int)` will get
precompiled by the downstream packages.

This leads us to two important conclusions for this section of the conversion: 

1. Julia v1.8 is required for precompilation to easily have the wished upon effects, as with the older   
   ownership issues one had to deduce which package is missing a given method and ensure that package accept
   the required method into the package.
2. On Julia v1.8 and higher, load times can be reduced by ensuring that core packages (packages used by
   many other packages) snoop the precompilation of methods which are widely used downstream. This will
   help ensure that as few methods as possible are duplicated, which will ultimately decrease the package
   load times for the ecosystem.

## The Next Step: Improving Using Times via Requires.jl Removal and Package Splitting

With SnoopPrecompile and the new changes in Julia v1.8, the full RecursiveFactorization call, along with
the FastBroadcast.jl dispatches, finally precompiled. This dropped the total first `solve` call dropped
from 22 seconds to 3 seconds when not accounting for `using` times. But, given that the precompilation
ownership changes greatly increased the amount of precompiled code, `using` times began to matter a lot more
and thus this started entering the measurements. Thus the "real" time went from around 30 seconds to around
15 seconds. Thus if we were going to make the new precompilation improvements more useful, we needed to
start focusing on the `using` times as well.

Luckily (or rather, it wasn't much of a coincidence) as the using times became more important, a new feature
landed on the Julia v1.8 master in order [to better profile the `using` times](https://docs.julialang.org/en/v1/NEWS/#InteractiveUtils):

> New macro @time_imports for reporting any time spent importing packages and their dependencies, highlighting compilation and recompilation time as percentages per import (#41612,#45064).

This is what it looked like on a small package [RecursiveArrayTools.jl](https://github.com/SciML/RecursiveArrayTools.jl)
which defines some important array types used in the differential equation solvers:

```julia
julia> @time_imports using RecursiveArrayTools
     10.7 ms    ┌ MacroTools
     19.2 ms  ┌ ZygoteRules
      2.8 ms  ┌ Compat
      1.4 ms  ┌ Requires
    123.4 ms  ┌ FillArrays
    507.7 ms  ┌ StaticArrays
     17.8 ms      ┌ Preferences
     19.6 ms    ┌ JLLWrappers
    184.0 ms  ┌ LLVMExtra_jll
      5.1 ms      ┌ CEnum
    108.6 ms    ┌ LLVM
      1.9 ms    ┌ Adapt
    804.4 ms  ┌ GPUArrays
      5.8 ms  ┌ DocStringExtensions
      1.3 ms  ┌ IfElse
     39.8 ms  ┌ RecipesBase
     40.6 ms    ┌ Static
    504.1 ms  ┌ ArrayInterface
     73.6 ms  ┌ ChainRulesCore
   2332.6 ms  RecursiveArrayTools
```

Yes, over 2 seconds to load what was one of the "small" dependencies. But how did we get here?

The major steps that led to this were of course the precompilation changes, but that's only part of the
story. Some of these core packages like [ArrayInterface.jl](https://github.com/JuliaArrays/ArrayInterface.jl)
define interface functions which require many downstream dependencies. For example, "does this array type
have fast indexing?" is a question that needs to be asked an answered on every array type you want to use
the `fast_scalar_indexing(T)` function on, so therefore `ArrayInterface.jl` needs to have depenencies on
all of the array types one might use, from 
[BlockBandedMatrices.jl](https://github.com/JuliaMatrices/BlockBandedMatrices.jl) to 
[ComponentArrays.jl](https://github.com/jonniedie/ComponentArrays.jl). 

For this reason, `ArrayInterface.jl` used to make use of the 
[Requires.jl](https://github.com/JuliaPackaging/Requires.jl) system for conditional dependencies. However,
packages which are used in an `@requires` block are incompatible with precompilation, since their load
does not occur at the `using` time of the given package but at the `using` time of the downstream package,
something which has not been specialized in the precompilation system. The first step to improve
precompilation was thus to remove all conditional module loading and make it explicit. 

However, this led to many "unnecessary" dependencies propagating downstream. For example, in the
RecursiveArrayTools.jl example, you see `804.4 ms  ┌ GPUArrays`, i.e. a large portion of the 
RecursiveArrayTools load time was due to needing to define one method:

```julia
# Allow converting a VectorOfArray to a GPU-based Array
Base.convert(T::Type{<:GPUArrays.AbstractGPUArray}, VA::AbstractVectorOfArray) = T(VA)
```

However, this led to the observation that there is no need for the abstract types like 
`GPUArrays.AbstractGPUArray` to live in the "functionality" package. In a sense, there is room for
"interface" packages to define the core interfaces, functions like "this is an abstract GPU array",
which is separate from a package that defined "this is how you do math on a GPU array". The former
is would be a small package with almost 0 load time, while the latter is "all of the hard work" and
only required by packages which want to do GPU computing. 

So without further ado, the great splitting of 2022 was commenced. The main packages which needed
this treatment were:

* ArrayInterface.jl, which could split the interface definitions from its instantiations on 
  downstream packages
* GPUArrays.jl, which could split the definition of a GPU array from the instantiation of
  GPU-based functionality. This would allow packages to be able to query "is this a GPU array?"
  with almost no load time penalty, allowing for easy separate GPU-safe code paths. This is
  important because GPUs do not support fast scalar indexing, i.e. `A[1]` is not a good operation
  on GPUs, so it's something you want to query and avoid.
* StaticArrays.jl, which could split the definition of a static array from the implementation
  of static array functionality. This would allow packages to be able to query for "is this array
  a static array?", which is important because static arrays do not support `setindex!`, i.e.
  `A[1] = x`. The actual static array package load times are rather intense because it defines
  many size-specialized versions of arithmetic functions.

This lead to the development of 
[ArrayInterfaceCore.jl](https://github.com/JuliaArrays/ArrayInterface.jl/tree/master/lib/ArrayInterfaceCore) ([relevant issue](https://github.com/JuliaArrays/ArrayInterface.jl/issues/211)),  
[GPUArraysCore.jl](https://github.com/JuliaGPU/GPUArrays.jl/tree/master/lib/GPUArraysCore) ([relevant issue](https://github.com/JuliaGPU/GPUArrays.jl/issues/409)),
and [StaticArraysCore.jl](https://github.com/JuliaArrays/StaticArraysCore.jl) ([relevant issue](https://github.com/JuliaArrays/StaticArrays.jl/issues/1023)).

Now the overload became:

```julia
import GPUArraysCore
# Allow converting a VectorOfArray to a GPU-based Array
Base.convert(T::Type{<:GPUArraysCore.AbstractGPUArray}, VA::AbstractVectorOfArray) = T(VA)
```

As a result, the load time of RecursiveArrayTools.jl [decreased dramatically](https://github.com/SciML/RecursiveArrayTools.jl/pull/217):

```julia
@time_imports using SciMLBase
    10.4 ms    ┌ MacroTools
     19.0 ms  ┌ ZygoteRules
      3.8 ms  ┌ Compat
      1.5 ms    ┌ Adapt
      3.7 ms    ┌ ArrayInterfaceCore
      2.0 ms    ┌ StaticArraysCore
      9.7 ms  ┌ ArrayInterfaceStaticArraysCore
    123.1 ms  ┌ FillArrays
      5.0 ms  ┌ DocStringExtensions
     18.2 ms  ┌ RecipesBase
     51.3 ms  ┌ ChainRulesCore
      4.0 ms  ┌ GPUArraysCore
    292.7 ms  RecursiveArrayTools
```

There is still work to be done (a FillArraysCore.jl is probably required), but one can see the massive
effect this has on the ecosystem.

#### A Note on Total Using Times

Now an astute reader may look at this and go "but wait, if I am going to use static arrays, won't I still
need to pay the full price of StaticArrays.jl loading at some time?" Yes you will, but it turns out that
delaying large overloading imports as late as possible leads to larger than expected loading time improvements.
One big reason is because it reduces the amount of code that gets invalidated: we will get to invalidations
right after this. But the second reason is simple. StaticArrays.jl adds a bunch of methods for `+` between 
different array sizes. `+(::SVector{Size N, T},::SVector{Size N, T})` for every size `N` is added, 
combinations between `MArray` and `SArray`, etc. are added. It adds overloads to `lu`, `qr`, ...: 
StaticArrays adds something to everything. Thus when the compiler is looking up what method to use for
`lu` downstream, there ends up being a lot of "StaticArrays junk" to sift through, and this increases
the compile times. This is thus reduced by not adding these extra methods until they are necessary.

So with the move to using core interface packages separated from the functionality, one chunk of the
using time gains was due to removing functionality that was only used by a small subset of users
(for example, the 1 second of extra using time on RecursiveArrayTools that was only due to allowing
GPU support), while the other chunk was due to delaying large imports until further down in the process.
good question good reader! Now back to the regularly scheduled programming.

## The Story of Invalidations: How You Accidentally Delete All of Your Good Precompilation Work

Even with all of these changes, in some cases the cost of `using` could remain high. The reason is
invalidations. To illustrate where invalidations can come from, let's look at the following example.
Let's say in package MyPackage I define the function:

```julia
f(x::Number) = x isa AbstractFloat
```

and then I use it in a function `g`:

```julia
g(a::AbstractArray) = sum(f,a)
```

`g` is thus a function that checks whether every element of some AbstractArray `a` is an `AbstractFloat`.
Now, for strongly typed arrays `a`, such as `a::Array{Float64,2}`, `f(x)` always returns a `Bool` based
on `eltype(a)`. and thus `f(a[i])` always returns a `Bool`, and thus the `sum` function ends up iterating
`tmp = f(a[i])` where `tmp::Int`, accumulating the booleans. But what if `a::Array{Number,2}`? In this
case, the element type of `a` is not concrete, so with `a = Number[1.0, 1, 1f0]`, one cannot deduce at
compile time the element type of `a[i]`. However, even though all one knows is that 
`typeof(a[i]) <: Number`, it turns out that for every `T <: Number`, `T isa AbstractFloat` returns a
Bool. Thus in some sense, at the compiler level, we can deduce that `f(a::Number)::Bool`. Given this
fact, even without concrete type information on the elements of `a` we can still deduce the at
`f(a[i])::Bool` and make sure the return of `f` is unboxed, making this loop still be relatively fast
by removing dynamic dispatch. 

This assumption is known colloquially (by very few people) as the world-splitting optimization.
Essentially, if the method table has 4 or fewer potential output types, then Julia's compiler can
generate code that uses explicit branching instead of dynamic dispatch. This is important because
dynamic dispatch involves checking the global method table for matching types and resolving
dispatches at runtime, a very expensive process in comparison to `if T isa Number`. 

However, the existence of this world-splitting leaves Julia's compiler open to having to invalidate
old cached code if the assumptions change. One major example we have found is that the default
`!` function in Julia (`!x` is "not x") always expects `!(::Bool)::Bool`, and thus the compiler
specializes on the fact that the return should always be a `Bool`. But what happens if someone
violates this assumption? For example, what if someone created a 
[Static.jl](https://github.com/SciML/Static.jl) with a static compile-time type-based `False` and
`True` type? If that's the case then it would make sense that `!(::False) = True()` and 
`!(::True) = False()`. But what needs to be recompiled if we do this?

```julia
julia> show(trees[end-1])
inserting !(::Static.False) in Static at C:\Users\accou\.julia\packages\Static\sVI3g\src\Static.jl:427 invalidated:
   mt_backedges:   1: signature Tuple{typeof(!), Any} triggered MethodInstance for !=(::AbstractFloat, ::AbstractFloat) (0 children)
2: signature Tuple{typeof(!), Any} triggered MethodInstance for Base.isbadzero(::typeof(min), ::AbstractFloat) (0 children)
3: signature Tuple{typeof(!), Any} triggered MethodInstance for Base.CoreLogging.var"#handle_message#2"(::Base.Pairs{Symbol, V, Tuple{Vararg{Symbol, N}}, NamedTuple{names, T}} where {V, N, names, T<:Tuple{Vararg{Any, N}}}, ::typeof(Base.CoreLogging.handle_message), ::Base.CoreLogging.SimpleLogger, ::Base.CoreLogging.LogLevel, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any) (0 children)
4: signature Tuple{typeof(!), Any} triggered MethodInstance for Base.CoreLogging.var"#handle_message#2"(::Base.Pairs{Symbol, _A, Tuple{Symbol}, NamedTuple{names, T}} where {_A, names, T<:Tuple{Vararg{Any, N}}}, ::typeof(Base.CoreLogging.handle_message), ::Base.CoreLogging.SimpleLogger, ::Base.CoreLogging.LogLevel, ::LazyString, ::Any, ::Symbol, ::Any, ::Any, ::Any) (0 children)
5: signature Tuple{typeof(!), Any} triggered MethodInstance for Base.CoreLogging.var"#handle_message#2"(::Base.Pairs{Symbol, _A, Tuple{Symbol}, NamedTuple{names, T}} where {_A, names, T<:Tuple{Vararg{Any, N}}}, ::typeof(Base.CoreLogging.handle_message), ::Base.CoreLogging.SimpleLogger, ::Base.CoreLogging.LogLevel, ::String, ::Any, ::Symbol, ::Any, ::Any, ::Any) (0 children)

.
.
.
```

I cut this short because [it ends up being >180 method signatures which get invalidated](https://github.com/SciML/DifferentialEquations.jl/issues/786#issuecomment-1221515190)
What this means is that after this method is added, the any method which specialized on the fact that
that the output has to be `::Bool` now can no longer make this assumption, and has to be recompiled.
That means that any precompilation cache which hits any of these methods needs to be discarded. Ouch!

Note that this does not mean that every use of `!` is discarded. Only cases where Julia's compiler
could not infer the type of `!` need to be invalidated, since if it can infer that `x::Bool`, then
it can still know that `!x::Bool` and thus no invalidation occurs. This is one principle to take away from
this discussion:

**Invalidations and other bad compile-time things have a bigger chance of occuring on uninferred code**

In other words, making sure that code is type-stable and easy to infer can have many different compile-time
benefits.

#### Quick Note About Invalidation Sources

While we have found the world-splitting optimization to be one of the most common ways that large-scale
invalidations can occur, it is by no means the only way. If someone implements a function 
`g(x::Number,y::Number) = f(x) + y` where `f(x::Number)` is the only definition that exists, and some 
other package comes along and adds a dispatch `f(x::Float64)`, such a dispatch can invalidate the
previous definitions of `g(::Float64,::Number)` by changing its behavior. This means another major source
of invalidations is 
[type-piracy, which is something you shouldn't do](https://docs.julialang.org/en/v1/manual/style-guide/#Avoid-type-piracy). Thus, avoid type-piracy and try to make code as well-inferred as possible and
invalidations as an issue are fairly minimized. Now back to the show.

### Profiling and Fixing Sources of Invalidations

Now knowing that the effect of invalidations is to throw away for hardworking precompilation caches, fixing
first call times definitely requires identifying if there are any invalidation sources which require
removal. The following code uses SnoopCompile to profile the invalidation sources:

```julia
using SnoopCompile
invalidations = @snoopr begin
    using OrdinaryDiffEq

    function lorenz(du, u, p, t)
        du[1] = 10.0(u[2] - u[1])
        du[2] = u[1] * (28.0 - u[3]) - u[2]
        du[3] = u[1] * u[2] - (8 / 3) * u[3]
    end
    u0 = [1.0; 0.0; 0.0]
    tspan = (0.0, 100.0)
    prob = ODEProblem{true,false}(lorenz, u0, tspan)
    alg = Rodas5()
    tinf = solve(prob, alg)
end;

trees = SnoopCompile.invalidation_trees(invalidations);

@show length(SnoopCompile.uinvalidated(invalidations)) # show total invalidations

show(trees[end]) # show the most invalidated method

# Count number of children (number of invalidations per invalidated method)
n_invalidations = map(trees) do methinvs
    SnoopCompile.countchildren(methinvs)
end

import Plots
Plots.plot(
    1:length(trees),
    n_invalidations;
    markershape=:circle,
    xlabel="i-th method invalidation",
    label="Number of children per method invalidations"
)
```

Here's the result of the two snapshots. December 24th, 2021:

![](https://user-images.githubusercontent.com/1814174/147303586-573258fc-cd0c-4548-b95d-b11dce55604a.png)

August 21st, 2022:

![](https://user-images.githubusercontent.com/1814174/185786190-28a1d8b5-2027-475c-8112-b9388230daaa.png)

The invalidation reductions generally were as simple as removing a dispatch from some package. Generally
these dispatches were so weird that we could find no code actually using the dispatch. Some cases were:

* [An `==` for a specific type that was only used in ChainRulesCore testing](https://github.com/JuliaDiff/ChainRulesCore.jl/pull/524)
* [A Unitful dispatch that broke standard rules of element type promotion](https://github.com/PainterQubits/Unitful.jl/pull/509)
* [A `reduce_empty` overload that had a comment "Not used in Transducers.jl ATM"](https://github.com/JuliaFolds/InitialValues.jl/pull/64)

Generally, dispatches which do weird things are not useful because they break the convention of the
function they are overloading, and thus are hard to actually make use of in generic code. Thus the
biggest invalidators tend to be signs of bad coding anyways, and these fixes simply led to greener
pastures along with better compile times. There are a few tricker ones, like 
[the removal of `!` overloads from Static.jl removing a key features](https://github.com/SciML/Static.jl/pull/78)
which was instead [mitigated by PRs to Base](https://github.com/JuliaLang/julia/pull/46490) which
[add explicit `::Bool` type assertions where it is assumed](https://github.com/JuliaLang/julia/pull/46491)
in [order to make the dispatches](https://github.com/JuliaLang/julia/pull/46481) not recompile when
`!(::True)::Bool` is added. 

However, for the most part, a few improvements and a few changes to Base made the biggest invalidators
go away. While this didn't have a major effect on the test code from the start of this post, it did have
a major effect on the related problem of automatic differentiation on the solver. In that case, if we
wanted to take the gradient of the solution to the ODE:

```julia
using OrdinaryDiffEq, SnoopCompile, ForwardDiff

lorenz = (du,u,p,t) -> begin
        du[1] = 10.0(u[2]-u[1])
        du[2] = u[1]*(28.0-u[3]) - u[2]
        du[3] = u[1]*u[2] - (8/3)*u[3]
end

u0 = [1.0;0.0;0.0]; tspan = (0.0,100.0);
prob = ODEProblem(lorenz,u0,tspan); alg = Rodas5();
tinf = @snoopi_deep ForwardDiff.gradient(u0 -> sum(solve(ODEProblem(lorenz,u0,tspan),alg)), u0)
tinf = @snoopi_deep ForwardDiff.gradient(u0 -> sum(solve(ODEProblem(lorenz,u0,tspan),alg)), u0)
```

then we saw that before handling the invalidations, almost all precompilation caches were discarded:

```julia
#First
InferenceTimingNode: 1.849625/14.538148 on Core.Compiler.Timings.ROOT() with 32 direct children

#Second
InferenceTimingNode: 1.531660/4.170409 on Core.Compiler.Timings.ROOT() with 12 direct children
```

while after invalidations were handled, the precompilation caches were mostly kept and thus inference
time dropped dramatically:

```julia
#First
InferenceTimingNode: 1.181086/3.320321 on Core.Compiler.Timings.ROOT() with 32 direct children

#Second
InferenceTimingNode: 0.998814/1.650488 on Core.Compiler.Timings.ROOT() with 11 direct children
```

That's about 11 seconds chopped off the first solve time for the gradient case. But what about those
"direct children"?

#### Quick Note: Many Invalidations Don't Matter

Invalidations happen. If a single method is invalidated, it's not a big deal. If it's a core method
that's then invalidating 1000's of children calls, that's a huge compile-time deal. Thus track down
the major invalidations, but most cases are simply fine to leave alone.

## Ambiguity Resolution

Before we get to the direct children, I do want to add in a bit that 
[ambiguity resolution can adversely effect compile times](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1750).
This doesn't seem to be documented anywhere (this issue was opened by Jameson Nash, one of the core
Julia developers, and this is the only case I know of which mentions this fact before this blog post), 
but it makes sense  because finding and resolving ambiguities would require quite a bit of search code 
to be ran, and thus simply avoiding any of these searches will lead to an improvement. 

Method ambiguities arise when a potential function call is undefined in the sense of multiple dispatch. 
The reason is because Julia always picks the "most specific" method available. For example, let's say
we have:

```julia 
f(x::Number,y::Number) = 2x + y
f(x::AbstractFloat,y::Number) = x*y
```

then for `f(2.0,3)`, the code that will be called is `x*y` because `AbstractFloat <: Number` is a more
specific type choice. However, if there is no well-ordered form, an ambiguity occurs. This would
occur for example if we add the method:

```julia
f(x::Number,y::AbstractFloat) = x/y
```

Now if we call `f(2.0,3.0)`, is `f(x::Number,y::AbstractFloat)` or `f(x::AbstractFloat,y::Number)` a
better fit? The former is a better fit in `y` while the latter is a better fit in `x`, so therefore it's
ambiguous which method to choose. Thus if you actually call this in the REPL you will see:

```julia
julia> f(2.0,3.0)
ERROR: MethodError: f(::Float64, ::Float64) is ambiguous. Candidates:
  f(x::AbstractFloat, y::Number) in Main at REPL[35]:1
  f(x::Number, y::AbstractFloat) in Main at REPL[36]:1
Possible fix, define
  f(::AbstractFloat, ::AbstractFloat)
Stacktrace:
 [1] top-level scope
   @ REPL[37]:1
```

Notice that there is nothing wrong with simply having these three method definitions if you know
`f(::Float64,::Float64)` is never called. It's only an issue when the ambiguous case occurs. This means
that ambiguous cases can exist within methods defined in a package and things can work just fine. However,
if an uninferred code ever shows up and hits this function, the added code for resolving the ambiguity
could in theory increase the compile times. 

Thankfully, Julia's `Test` module has a method `detect_ambiguities` which returns all possible ambiguities
of a module. When we first applied this to OrdinaryDiffEq, we got 1702 cases:

```julia
julia> using Test; Test.detect_ambiguities(OrdinaryDiffEq)
1702-element Vector{Tuple{Method, Method}}:
 (initialize!(nlsolver::OrdinaryDiffEq.NLSolver{<:NLNewton, false}, integrator) @ OrdinaryDiffEq ~/.julia/packages/OrdinaryDiffEq/SmImO/src/nlsolve/newton.jl:3, initialize!(integrator, cache::OrdinaryDiffEq.LowStorageRK5RPCache) @ OrdinaryDiffEq ~/.julia/packages/OrdinaryDiffEq/SmImO/src/perform_step/low_storage_rk_perform_step.jl:755)
 (initialize!(nlsolver::OrdinaryDiffEq.NLSolver{<:NLNewton, true}, integrator) @ OrdinaryDiffEq ~/.julia/packages/OrdinaryDiffEq/SmImO/src/nlsolve/newton.jl:13, initialize!(integrator, cache::OrdinaryDiffEq.CG3Cache) @ OrdinaryDiffEq ~/.julia/packages/OrdinaryDiffEq/SmImO/src/perform_step/linear_perform_step.jl:156)
 ```

 All of these were due to "bad interface ideas", using the same function to mean a bunch of different
 things. Just bad code in general. Thus we split functions which had "different meanings", brought this
 to zero, and added unit tests on ambiguities 
 [in one quick PR](https://github.com/SciML/OrdinaryDiffEq.jl/pull/1753). Easy peasy, lemon squeezy.

## Improving Inference and Connection to Function Specialization

Now with everything precompiling well and no longer invalidating (as much), it's time to address the
second question that we posed a few hundred lines earlier:

> How do we improve the compile-times of things which are not precompiled?

While it is still currently hard to profile this direct question, it turns out that there is one major
thing you can do to further improve your code: help make sure inference is specializing correctly.
If we go back above to the SnoopCompile statistics:

```julia
InferenceTimingNode: 1.460777/16.030597 on Core.Compiler.Timings.ROOT() with 46 direct children
```

the number of "direct children" are the number of spots where a dynamic dispatch occurs. Recall that
most invalidations only occur on code which is not fully inferred and note that's a sign of trouble.
But now also bring in the fact uninferred calls don't precompile. Thus if you have major calls which
are not inferred, this will further decrease the effectiveness of precompilation.

#### Quick Note About One Major Difference From v1.7

In the core [compile-time tracking thread](https://github.com/SciML/DifferentialEquations.jl/issues/786)
it was noted that lack of inference ends up disabling precompilation for downstream calls. Much of the
work for improving compile times was thus centered around first improving inference so that
RecursiveFactorization.jl could precompile. However, 
[this is one of the things that SnoopPrecompile solves](https://discourse.julialang.org/t/ann-new-package-snoopprecompile/84778/4?u=chrisrackauckas).
Thus while it is still a good idea to improve inference to reduce invalidations and ensure more
precompilation, it's not as major of an issue as before. tl;dr: before all code downstream of an
inference issue would be discarded from precompilation, now with SnoopPrecompile calls downstream
of an inference issue that are well-inferred are precompiled (while the "current" method might
be discarded for an inference issue).

Now back to fixing inference issues.

### The Most Common Easily Fixable Inference Issues

The [standard Julia performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/) lead
to more statically inferred code, and thus those should be followed diligently for both good compile
and run times. But pay special attention to
[Be aware of when Julia avoids specializing](https://docs.julialang.org/en/v1/manual/performance-tips/#Be-aware-of-when-Julia-avoids-specializing).
The tl;dr is that if you have a function which takes in a type, like:

```julia
f(T, x) = T(x)
f(Float32, 1.0)
```

then this function will specialize on `x` but not on `T` by default. Thus if you want inference to
specialize on this function (and thus infer the output type as T!), you need to change DataType
dispatches to the form:

```julia
f(::Type{T}, x) where T = T(x)
```

A similar case arises with functions. If you have:

```julia
f(g::Function, x) = g(x)
```

By default Julia will attempt to reduce the amount of compilation by not specializing on the function
`g`. However, if you are looking to improve the amount of precompilation that occurs, then you want
this function to be specialized and compiled on the function `g`, and therefore:

```julia
f(g::G, x) where G = g(x)
```

will improve specialization, inference, and thus lead to more compilation. We will dig into this
specific case in a little bit more detail, so hold onto your thoughts here!

### Okay, But How Do I Identify What Methods Might Need Such a Treatment?

Good question. If you go back to the SnoopCompile call:

```julia
@show tinf
InferenceTimingNode: 1.460777/16.030597 on Core.Compiler.Timings.ROOT() with 46 direct children
```

You see that this counts the number of uninferred calls as "direct children". You can query this
via `inference_triggers` to figure out where those inference triggers occur. For example, in a
[much earlier version](https://github.com/SciML/DiffEqBase.jl/pull/698#issuecomment-896984234) we saw:

```julia
itrigs = inference_triggers(tinf)

itrigs[5]

Inference triggered to call (::FiniteDiff.var"#finite_difference_jacobian!##kw")(::NamedTuple{(:dir,), Tuple{Bool}}, ::typeof(FiniteDiff.finite_difference_jacobian!), ::Matrix{Float64}, ::Function, ::Vector{Float64}, ::FiniteDiff.JacobianCache{Vector{Float64}, Vector{Float64}, Vector{Float64}, UnitRange{Int64}, Nothing, Val{:forward}(), Float64}, ::Vector{Float64}) from jacobian_finitediff_forward! (C:\Users\accou\.julia\dev\OrdinaryDiffEq\src\derivative_wrappers.jl:89) with specialization OrdinaryDiffEq. jacobian_finitediff_forward!(::Matrix{Float64}, ::Function, ::Vector{Float64}, ::FiniteDiff.JacobianCache{Vector{Float64}, Vector{Float64}, Vector{Float64}, UnitRange{Int64}, Nothing, Val{:forward}(), Float64}, ::Vector{Float64}, ::OrdinaryDiffEq.ODEIntegrator{Rodas5{0, false, DefaultLinSolve, Val{:forward}}, true, Vector{Float64}, Nothing, Float64, SciMLBase.NullParameters, Float64, Float64, Float64, Float64, Vector{Vector{Float64}}, ODESolution{Float64, 2, Vector{Vector{Float64}}, Nothing, Nothing, Vector{Float64}, Vector{Vector{Vector{Float64}}}, ODEProblem{Vector{Float64}, Tuple{Float64, Float64}, true, SciMLBase.NullParameters, ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Base.Pairs{Symbol, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}, SciMLBase.StandardODEProblem}, Rodas5{0, false, DefaultLinSolve, Val{:forward}}, OrdinaryDiffEq.InterpolationData{ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Vector{Vector{Float64}}, Vector{Float64}, Vector{Vector{Vector{Float64}}}, OrdinaryDiffEq.Rosenbrock5Cache{Vector{Float64}, Vector{Float64}, Vector{Float64}, Matrix{Float64}, Matrix{Float64}, OrdinaryDiffEq.Rodas5Tableau{Float64, Float64}, SciMLBase.TimeGradientWrapper{ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Vector{Float64}, SciMLBase.NullParameters}, SciMLBase.UJacobianWrapper{ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Float64, SciMLBase.NullParameters}, DefaultLinSolve, FiniteDiff.JacobianCache{Vector{Float64}, Vector{Float64}, Vector{Float64}, UnitRange{Int64}, Nothing, Val{:forward}(), Float64}, FiniteDiff.GradientCache{Nothing, Vector{Float64}, Vector{Float64}, Float64, Val{:forward}(), Float64, Val{true}()}}}, DiffEqBase.DEStats}, ODEFunction{true, 
typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, OrdinaryDiffEq.Rosenbrock5Cache{Vector{Float64}, Vector{Float64}, Vector{Float64}, Matrix{Float64}, Matrix{Float64}, OrdinaryDiffEq.Rodas5Tableau{Float64, Float64}, SciMLBase.TimeGradientWrapper{ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Vector{Float64}, SciMLBase.NullParameters}, SciMLBase.UJacobianWrapper{ODEFunction{true, typeof(lorenz), LinearAlgebra.UniformScaling{Bool}, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, typeof(SciMLBase.DEFAULT_OBSERVED), Nothing}, Float64, SciMLBase.NullParameters}, DefaultLinSolve, FiniteDiff.JacobianCache{Vector{Float64}, Vector{Float64}, Vector{Float64}, UnitRange{Int64}, Nothing, Val{:forward}(), Float64}, FiniteDiff.GradientCache{Nothing, Vector{Float64}, Vector{Float64}, Float64, Val{:forward}(), 
Float64, Val{true}()}}, OrdinaryDiffEq.DEOptions{Float64, Float64, Float64, Float64, PIController{Rational{Int64}}, typeof(DiffEqBase.ODE_DEFAULT_NORM), typeof(LinearAlgebra.opnorm), Nothing, CallbackSet{Tuple{}, Tuple{}}, typeof(DiffEqBase.ODE_DEFAULT_ISOUTOFDOMAIN), typeof(DiffEqBase.ODE_DEFAULT_PROG_MESSAGE), typeof(DiffEqBase.ODE_DEFAULT_UNSTABLE_CHECK), DataStructures.BinaryHeap{Float64, DataStructures.FasterForward}, DataStructures.BinaryHeap{Float64, DataStructures.FasterForward}, Nothing, Nothing, Int64, Tuple{}, Tuple{}, Tuple{}}, Vector{Float64}, Float64, Nothing, OrdinaryDiffEq.DefaultInit})
```

(Note that this can be annoyingly long, but `itrigs` is just a `Vector`, so you can index it like `itrigs[5]`
to only show the 5th inference trigger. Also, you can use  [Cthulhu](https://github.com/JuliaDebug/Cthulhu.jl) 
with `ascend(itrigs[5])` to further debug the inference issue in detail, if you know Cthulhu)

With some practice you can quickly read this and see:

```julia
OrdinaryDiffEq.jacobian_finitediff_forward!(::Matrix{Float64}, ::Function, ...
```

at `jacobian_finitediff_forward! (C:\Users\accou\.julia\dev\OrdinaryDiffEq\src\derivative_wrappers.jl:89)`,
oh wait a minute that code was missing a `::F) where F` specialization on the function which is the
second argument.

**Now if you handle those and did everything else before, you're in precompilation heaven. Congratualations,
your inference time should be close to zero and you should only be left with LLVM time**

But wait a minute, we're still missing one last piece:

## Handling Higher Order Functions: Controlling Specialization

For most packages, you're done. This last piece is rather specific to codes like those in SciML which
have higher order functions. Let's revisit one piece from the improving inference section. I mentioned
that if you pass a function to another function, then Julia will not specialize by default.

```julia
f(g::Function, x) = g(x)
```

> By default Julia will attempt to reduce the amount of compilation by not specializing on the function
> `g`. However, if you are looking to improve the amount of precompilation that occurs, then you want
> this function to be specialized and compiled on the function `g`, and therefore:

```julia
f(g::G, x) where G = g(x)
```

The reason for this behavior is because every function in Julia is a new type. 

```julia
julia> typeof(f)
typeof(f) (singleton type of function f, subtype of Function)

julia> h = (x) -> 2x
#5 (generic function with 1 method)

julia> typeof(h)
var"#5#6"
```

Here `#5` is just a counter (using `gensym`) saying this is the type for the 5th anonymous function
created in my REPL. Every single one is a different type, and each of those types are subtypes of
`::Function`. Thus `::Function` is a supertype, like `Number`, and is not the concrete type of functions.

This has some very important consequences. An astute reader may have already noticed the issue: before
I mentioned how precompilation happens on the method signatures of the function, and the method signatures
are defined by the input types. But if the input type is a function, then every unique function has a
unique method, and thus while forcing specialization `f(g::G, x) where G = g(x)` may allow for precompilation,
the precompiled method will be **only that specific `g`, not all possible functions**. For example,
that would be like precompiling the ODE solver only for the `f` you happened to put into the
SnoopPrecompile.jl statement. Maybe that works for some use cases where the model does not change,
but for an ODE solver, if you have to recompile every single method that touches `f` for every new
ODE someone wants to solve, then you are still throwing away the vast majority of precompilation work.

The simplest answers are: you either fully specialize on higher order functions or you don't. An easy
way to force this through a whole codebase is to simply wrap the function in a struct. The "don't specialize
it anywhere" case looks like:

```julia
struct FWrap
  f
end
(F::FWrap)(x...) = F.f(x...)

ff = FWrap(f)
## ff now acts just like `f`, but its type is constant `FWrap`
```

This minimizes the surface of which function specialization rules are applied, and can be an easy way
to enforce no specialization. Since the types are always the same, the functions which only see `FWrap`
will see constant types and precompile just fine. However, a major downside is that since `F.f` is not
inferred, the output of `F.f` is not inferred, and thus `ff(x)` can easily be type-unstable. One way
to make this easier to handle is to simply require an API of mutation, i.e. `ff!(out,x)` which returns
`nothing` can have `(F::FWrap)(x...) = (F.f(x...); return nothing)` enforce that the return is always
`nothing` and thus world-splitting optimizations will ensure that calls to `ff` do not break inference.
This is one of the easier ways to balance the trade-off of inference and specialization for higher
order functions. 

On the other hand, one can make a type that fully specializes:

```julia
struct FWrap{F}
  f::F
end
(F::FWrap)(x...) = F.f(x...)

ff = FWrap(f)
## ff now acts just like `f`, but its type is non-constant `FWrap{typeof(f)}`
```

This will now fully specialize everywhere (note: do not put `struct FWrap{F} <: Function` since then the
specialization rules for `Function`s will apply to `FWrap` as well!). But is there a middle ground?

The middle ground would be to specialize on the input/output types: treating functions like function
pointers in C. This can be done via a package known as 
[FunctionWrappers.jl](https://github.com/yuyichao/FunctionWrappers.jl). For example, if we have the
function `f(x,y) = round(x*y)`, we can do `ff = FunctionWrapper{Int, Tuple{Float64, Float32}}(f)` and this
will make a `FunctionWrapper{Int, Tuple{Float64, Float32}}`. This is a type of function which only
allows two inputs, (x::Float64, y::Float32), and returns a single output `Int`. In other words, `ff`
can be thought of as a function with only a single dispatch `ff(x::Float64, y::Float32)::Int`. It does
not matter that `f` was compatible with more dispatches: once the function is wrapped its wrapped form
can only call that specific type signature. All functions which are wrapped under the same signature
share the same type, so `g(x,y) = ceil(x*y); gg = FunctionWrapper{Int, Tuple{Float64, Float32}}(g)` has 
that `typeof(ff) === typeof(gg)`, even though ff(x,y) is not necessarily the same as `gg(x,y)`. Thus if
one can ensure that all dispatches have the same constraint on the input/output types, a `FunctionWrapper`
can be used to force specialization on the input/output types in a way that is not specific to a given
function.

Note that FunctionWrappers.jl only supports single method dispatches, so therefore a wrapper package
[FunctionWrappersWrappers.jl](https://github.com/chriselrod/FunctionWrappersWrappers.jl) exists
to allow for defining a `FunctionWrappersWrappers` which is a list of FunctionWrappers wrapped into
a single function that performs a limited subset dispatch on the input arguments (with inferred outputs).
This looks like: `FunctionWrappersWrapper(+, (Tuple{Float64,Float64}, Tuple{Int,Int}), (Float64,Int))`,
i.e. you give a tuple of input argument tuples and output arguements. But the same applies in that this
will now build functions with `n` pre-defined many dispatches in a way that specializes and thus allows
for precompilation.

### Automating the Function Wrapping Process

While the user of the package could themselves wrap the function and thus achieve total precompilation
with function specialization, we found that in our packages we could design the package so that the
user did not have to muck with any `FunctionWrappersWrappers` nonsense but still achieve the full
precompilation. To see how this was done, let's take a closer look at our stiff ODE solve example:

```julia
using OrdinaryDiffEq
function lorenz(du,u,p,t)
    du[1] = 10.0(u[2]-u[1])
    du[2] = u[1]*(28.0-u[3]) - u[2]
    du[3] = u[1]*u[2] - (8/3)*u[3]
end
u0 = [1.0;0.0;0.0]; tspan = (0.0,100.0)
prob = ODEProblem(lorenz,u0,tspan)
solve(prob,Rodas5())
```

In this case, the user provides us a model in the form of a function `lorenz`. This function is a mutating
function, and from the ODE definition we have that `u0 isa Vector{Float64}`, `eltype(tspan) isa Float64`,
and there are no parameters (and thus `typeof(p) isa SciMLBase.NullParameters`). From these facts we
know that internal to the ODE solver when automatic differentiation is not being used, the type of `u`
and the type of `du` match the `typeof(u0)` (we can also deduce the types required for automatic 
differentiation, but that's a longer story which I will leave for the appendix). Therefore it is at the
point of the `ODEProblem` construction that we have all of the information to do the function wrapping.

We can thus have the `ODEProblem` call itself specialize on the input function `lorenz`, but immediately
compute the wrapper as follows:

```julia
# Since the function mutates, make a wrapper that always throws away
# the return and gives nothing, just in case the user accidentally forgets!
struct Void{F}
  f::F
end

function (f::Void{F})(x) where F
  f.f(x)
  nothing
end

FunctionWrapper{Nothing,Tuple{Vector{Float64},Vector{Float64},SciMLBase.NullParameters,Float64}}(Void(lorenz))
```

Thus the very first method of the call stack will have to recompile for every new ODE, but that's a trivial
<100 microseconds call short call. All of the real functionality is then behind the next call, like:

```julia
function ODEProblem(f,u0,tspan,p;kwargs...)
  _ODEProblem(wrapfunction(f),u0,tspan,p;kwargs...)
end
```

so then all of the "real work" is precompiled. If this is done, then if `f` changes the `typeof(prob)`
stays constant, and thus `solve` can be fully precompiled. In SciML we called this 
[`SciMLBase.FunctionWrapperSpecialize`](https://scimlbase.sciml.ai/dev/interfaces/Problems/#Specialization-Levels).
However, the difficulty with this form is that we have to commit to the `FunctionWrapper` very early.
If `ODEProblem` is then attempted to be solved with some new solver that uses some new automatic
differentiation technique, it may break when it sees the `FunctionWrapper`, so you may need to manually
unwrap (`SciMLBase.unwrapped_f(prob.f)`) and it becomes a nightmare to maintain. Thus the real question
is, how much specialization do you really need to avoid?

Since the vast majority (`>99%`) of the compile time lives in the `solve(prob,Rodas5())` call, avoiding
respecializing the rest of the `ODEProblem` call was simply over-engineering. Thus we found that a similar
strategy could hold in the `solve` call itself. This looks like:

```julia
function solve(prob,alg)
  # Pseudocode
  if alg is okay with having the function wrapped
    _prob = wrapped_f_prob(prob)
  else
    _prob = prob
  end

  __solve(prob,alg)
end
```

In other words, we can wait to apply the function wrapping until we really know that we want it, allow
for doing things like promoting `t` from `Int` etc., and thus have something very robust without ever
forcing any other solver to be compatible with the `FunctionWrappersWrappers` types. This is what we
implemented as the `AutoSpecialize` mode. And from 
[a quick benchmark](https://github.com/SciML/SciMLBase.jl/pull/242) we see that there's almost no 
difference:

```julia
using OrdinaryDiffEq, SnoopCompile, Profile, ProfileView
function lorenz(du, u, p, t)
    du[1] = 10.0(u[2] - u[1])
    du[2] = u[1] * (28.0 - u[3]) - u[2]
    du[3] = u[1] * u[2] - (8 / 3) * u[3]
end

@time begin
    lorenzprob = ODEProblem{true, SciMLBase.AutoSpecialize}(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0), Float64[])
    sol = solve(lorenzprob, Rosenbrock23())
end

# FunctionWrapperSpecialize:
# 1.475326 seconds (83.83 k allocations: 3.442 MiB, 99.79% compilation time)
# 0.000184 seconds (458 allocations: 40.070 KiB)
# AutoSpecialize:
# 1.597643 seconds (958.02 k allocations: 49.979 MiB, 99.85% compilation time)
# 0.000182 seconds (467 allocations: 40.203 KiB
```

(that is stochastic from one run of each called twice. The difference is usually closer to 0.05 
seconds, and the runtime is "exactly" the same).

Thus SciML defaults now to a strategy of delayed wrapping (`AutoSpecialize`) to make maintanance
easy but avoid respecializing the solver unneccessarily. By default, the ODE solvers then precompile
for `AutoSpecialize` with the standard `Float64` and `Vector{Float64}` types, so the entire solver
precompiles. This gets the first solve time down to ~1.5 seconds, sans `using` time.

**Remember, we started this at 22 seconds, and now this is down to ~1.5 seconds!** (both sans using time)

### How much runtime overhead do FunctionWrappers add?

Almost none! `lorenz` is a pretty cheap function call, so it's a good baseline of "something that would
have more overhead that larger cases". In 
[the development PR there were some benchmarks](https://github.com/SciML/DiffEqBase.jl/pull/736#issuecomment-1221502113)

```julia
using OrdinaryDiffEq
function f(du, u, p, t)
    du[1] = 0.2u[1]
    du[2] = 0.4u[2]
end
u0 = ones(2)
tspan = (0.0, 1.0)
prob = ODEProblem{true,false}(f, u0, tspan, Float64[])

function lorenz(du, u, p, t)
    du[1] = 10.0(u[2] - u[1])
    du[2] = u[1] * (28.0 - u[3]) - u[2]
    du[3] = u[1] * u[2] - (8 / 3) * u[3]
end
lorenzprob = ODEProblem{true,false}(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0), Float64[])
typeof(prob) === typeof(lorenzprob) # true

@time sol = solve(lorenzprob, Rosenbrock23())
# 0.847580 seconds (83.25 k allocations: 3.404 MiB, 99.75% compilation time)

@time sol = solve(lorenzprob, Rosenbrock23(autodiff=false))
# 0.701598 seconds (499.23 k allocations: 28.846 MiB, 99.73% compilation time)

@time sol = solve(lorenzprob, Rosenbrock23())
# 0.000113 seconds (457 allocations: 39.828 KiB)

@time sol = solve(lorenzprob, Rosenbrock23(autodiff=false))
# 0.000147 seconds (950 allocations: 45.547 KiB)

lorenzprob2 = ODEProblem(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0), Float64[])

@time sol = solve(lorenzprob2, Rosenbrock23())
# 8.587653 seconds (24.77 M allocations: 3.581 GiB, 5.37% gc time, 99.99% compilation time)

@time sol = solve(lorenzprob2, Rosenbrock23(autodiff=false))
# 1.122847 seconds (3.69 M allocations: 211.491 MiB, 2.45% gc time, 99.98% compilation time)

@time sol = solve(lorenzprob2, Rosenbrock23())
# 0.000120 seconds (455 allocations: 39.531 KiB)

@time sol = solve(lorenzprob2, Rosenbrock23(autodiff=false))
# 0.000138 seconds (950 allocations: 45.188 KiB)
```

`lorenzprob2` is the full specialization form, and `lorenzprob` is the function wrapped form. We could
not descern a meaningful difference.

#### Small Detail on Wrapper Performance with ForwardDiff

Though note that needs a caveat on it. When forward-mode automatic differentiation via ForwardDiff.jl
is used, the chunk size is a part of the type. Having a larger chunk size can improve the performance
of the method, but the allowed values are dependent on the number of ODEs. Thus if one was only going
to pick a single chunk size, the only valid answer is `1`, which can be less performant than some other
cases. We could in theory setup the wrapper for all chunk sizes, though this increases the number of
dispatches in the `FunctionWrappersWrappers` by an order of magnitude, and thus the precompilation time
as well. Therefore, the function wrapper that is built sets the allowed chunk sizes to only be `1`, and
takes a bit of a performance (usually no greater than 2x) to cut down on the total precompilation time.
This trade-off can then be managed by the user specifying they want `SciMLBase.FullSpecialize` form
instead (which we recommend in any case where top-notch runtime is necessary).

So conclusion, performance of function wrappers are fine, though there can be edge cases.

## What's Left? Using Time, LLVM Time, and System Images

Now what we're left with is 1.5 seconds which is almost all LLVM compile time, since all of the inference
time was removed by precompilation, and we still have the `using OrdinaryDiffEq` time. 
`using OrdinaryDiffEq` still takes quite a good chunk of time (I think about 5 seconds on the desktop 
that was measuring everything? It's hard to measure since my laptop is much slower and it's at about 8
seconds, so to keep the timings consistent, all others used the desktop and that's my best guess right now).
That `using OrdinaryDiffEq` will come down considerably since Julia's Base v1.8.2 has some major
invalidation fixes, and [two major](https://github.com/SciML/Static.jl/pull/78) invalidation
[sources remain](https://github.com/JuliaDiff/ChainRulesCore.jl/issues/576) unaddressed. I think the
same desktop will get to around 2-3 seconds `using` time after that. FillArrays.jl needs to split out
a core, NonlinearSolve needs to not recompile RecursiveFactorization.jl, etc. but these are all things
you know how to do now. So the baseline "user does nothing else to their installation" should soon be
at about 3.5 seconds total (according to what the profiles show is easy to drop).

Thus how do we get down to 0.1 seconds? This last part requires forcing caching the resolution of
invalidations and caching the LLVM/native bytecode. While 
[Tim Holy and Valentin Churavy have plans for how to automate this in upcoming Julia releases](https://www.youtube.com/watch?v=GnsONc9DYg0), currently there is no way to make precompilation stash these pieces.

However, this is where system images come into play. If Julia's Base code never stashed any native
bytecode, Julia would have a terribly first time to run anything. But it does have a way to do this, and
that's called the system image. The system image is a bundle of the LLVM compiler, Julia's runtime,
and a precompiled binary with "all of the code that existed at system image build time". By default,
Julia's system image build includes Julia itself and the standard library. However, there is a tool
in the package ecosystem, [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl),
which allows for adding more code to the system image. 

PackageCompiler usage normally states that you need to give a representative set of functions etc., but
it turns out that, since our precompile files are complete we don't need to do anything. All we need
to do is tell PackageCompiler to compile a list of packages which includes our package. For example:

```julia
using PackageCompiler
create_sysimage(["OrdinaryDiffEq"], sysimage_path="DiffEqSysImage.so")
```

and then we run it, and tada that's the 0.1 seconds GIF at the top.

![](https://user-images.githubusercontent.com/1814174/185794444-34a99f53-646a-4cbb-81a3-678bb2e13a17.gif)

Moral of the story, this last step is still being worked on in order to be further automated. But,
it's now only one line of code to get full compilation, so please do it. Like seriously, I'm now using
some nice custom system images all of the time. One you have all of your precompilation well-snooped, it's
a beauty. Start using them today.

#### Note About System Images

System images are not the be-all end-all solution here. The function specialization changes, inference
improvements, etc. are all needed in order to get this final result. A few months ago the time post
system image was still >10 seconds. So while system images do some heavy lifting, all of these
"good compile time practices" were required to really get that final system image actually removing
all compilation.

#### Note About VS Code

VS Code has 
[tools to make building system images easier](https://www.julia-vscode.org/docs/stable/userguide/compilesysimage/).
Use them.

## Conclusions and Lasting Thoughts

Nothing is complete, but huge strides have been made. Major thanks to Tim Holy who put together the
tools required to make these changes as part of the CZI work. Also major kudos to Chris Elrod, Jeff
Bezanson, and Jameson Nash at Julia Computing who helped complete the story with ambiguity
handling and function specialization pieces as part of the (yet to be made public) grant work. All of
this was a culmination of package developers working with the compiler developers to get the tools
that are needed to solve the real problems.

SciML's packages can thus serve as a source of inspiration for the Julia community. Here's a set of
packages which had some of the largest compile times just a year ago, and now the REPL feels instantanious.
These steps are reproducible to other packages and just need someone to roll up their sleeves. We have
the tools, let's go for it!

A tl;dr of our current position is as follows:

* Every package should setup a SnoopPrecompile.jl block. While the precompilation ownership changes
  allow for downstream usage to precompile without such a block, covering the standard cases will
  allow the ecosystem to reduce the total amount of compilation caches and thus improve precompile
  times and reduce using times.
* Julia could use a better conditional module loading system in future versions. That would help lower
  package loading times. For now, sectioning off "core" portions of a package and making diligent use
  of subpackaging can be helpful. Avoid Requires.jl when possible.
* Delay large loads until as late as possible.
* Help the Julia ecosystem by profiling and identifying major invalidation sources. Most are trivial
  to fix and give a nice performance boost. Not all invalidations are worth fixing though!
* Use `Test.detect_ambiguities` to identify ambiguities. Add it to your CI tests!
* Better interfaces in Julia Base would reduce the dependency tree requirements downstream as more
  AbstractArray and Number packages would have consistently compile-time queriable information. Upstreaming
  of portions of ArrayInterface to Base and changing the 
  [Base AbstractArray Interface](https://docs.julialang.org/en/v1/manual/interfaces/) would thus
  facilitate better code with more explicit checking of assumptions and reduce package load times. 
* Use `inference_triggers` to find all inference issues, and fix them.
* Understand the function specialization behaviors if your package deals with higher order functions.
* Once precompilation is all setup, PackageCompiler system image building is just one line of code.
  Thus if packages all setup their compilation practices appropriately, PackageCompiler is a piece of
  cake and everyone should use it!

As for improvements coming soon:

* There are more improvements coming soon to Base, such as LLVM code caching, which will further 
  reduce the need for PackageCompiler and system images. Until then, you can at least eliminate 
  everything that is inference time via precompilation, reduce using times, and then use system images.
* Most of the remaining issues in SciML are due to the JuliaSIMD stack, specifically LoopVectorization.jl
  and its usage in RecursiveFactorization.jl. It's just a big generated code and therefore its LLVM
  time is long. New packages are being developed in the JuliaSIMD stack which alleviate this and further
  bring down the "no system image first solve time".
* Precompilation of uninferred calls and reduction of world-splitting optimizations have been identified
  as two improvements to Julia's Base that could further help compile times. We've upstreamed these
  needs and should hopefully hear some good news in the future.

And that's all for now. It's still on-going work, but there's no reason to not get started yourself.

# Appendix

## Using Preferences to Control Local Precompilation Choices

While the ability for a `SnoopPrecompile.@precompile_all_calls` block to precompile all well-inferred
calls is a good thing, in some cases users may want to control the amount that is precompiled. Moreso
than users, this is helpful to developers who may need to frequently recompile the package. To make
the precompilation choices more flexible, [Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)
can be used to set compile-time preference controls on what to precompile. For example, with
OrdinaryDiffEq.jl there are controls on whether to precompile the non-stiff, stiff, and auto-switching
ODE solvers. This is done for example like:

```julia
SnoopPrecompile.@precompile_all_calls begin
    function lorenz(du, u, p, t)
        du[1] = 10.0(u[2] - u[1])
        du[2] = u[1] * (28.0 - u[3]) - u[2]
        du[3] = u[1] * u[2] - (8 / 3) * u[3]
    end

    nonstiff = [BS3(), Tsit5(), Vern7(), Vern9()]

    stiff = [Rosenbrock23(), Rosenbrock23(autodiff = false),
             Rodas4(), Rodas4(autodiff = false),
             Rodas5(), Rodas5(autodiff = false),
             Rodas5P(), Rodas5P(autodiff = false),
             TRBDF2(), TRBDF2(autodiff = false),
             KenCarp4(), KenCarp4(autodiff = false),
             QNDF(), QNDF(autodiff = false)]

    autoswitch = [
        AutoTsit5(Rosenbrock23()), AutoTsit5(Rosenbrock23(autodiff = false)),
        AutoTsit5(TRBDF2()), AutoTsit5(TRBDF2(autodiff = false)),
        AutoVern9(KenCarp47()), AutoVern9(KenCarp47(autodiff = false)),
        AutoVern9(Rodas5()), AutoVern9(Rodas5(autodiff = false)),
        AutoVern9(Rodas5P()), AutoVern9(Rodas5P(autodiff = false)),
        AutoVern7(Rodas4()), AutoVern7(Rodas4(autodiff = false)),
        AutoVern7(TRBDF2()), AutoVern7(TRBDF2(autodiff = false))]

    solver_list = []

    if Preferences.@load_preference("PrecompileNonStiff", true)
        append!(solver_list, nonstiff)
    end

    if Preferences.@load_preference("PrecompileStiff", true)
        append!(solver_list, stiff)
    end

    if Preferences.@load_preference("PrecompileAutoSwitch", true)
        append!(solver_list, autoswitch)
    end

    prob_list = []

    if Preferences.@load_preference("PrecompileDefaultSpecialize", true)
        push!(prob_list, ODEProblem(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0)))
        push!(prob_list, ODEProblem(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0), Float64[]))
    end

    if Preferences.@load_preference("PrecompileAutoSpecialize", false)
        push!(prob_list,
              ODEProblem{true, SciMLBase.AutoSpecialize}(lorenz, [1.0; 0.0; 0.0],
                                                         (0.0, 1.0)))
        push!(prob_list,
              ODEProblem{true, SciMLBase.AutoSpecialize}(lorenz, [1.0; 0.0; 0.0],
                                                         (0.0, 1.0), Float64[]))
    end

    if Preferences.@load_preference("PrecompileFunctionWrapperSpecialize", false)
        push!(prob_list,
              ODEProblem{true, SciMLBase.FunctionWrapperSpecialize}(lorenz, [1.0; 0.0; 0.0],
                                                                    (0.0, 1.0)))
        push!(prob_list,
              ODEProblem{true, SciMLBase.FunctionWrapperSpecialize}(lorenz, [1.0; 0.0; 0.0],
                                                                    (0.0, 1.0), Float64[]))
    end

    if Preferences.@load_preference("PrecompileNoSpecialize", false)
        push!(prob_list,
              ODEProblem{true, SciMLBase.NoSpecialize}(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0)))
        push!(prob_list,
              ODEProblem{true, SciMLBase.NoSpecialize}(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0),
                                                       Float64[]))
    end

    for prob in prob_list, solver in solver_list; solve(prob, solver)(5.0); end
end
```

Then in the user's startup profile, precompilation amount can be toggled using the UUID of the
OrdinaryDiffEq.jl package:

```julia
using Preferences, UUIDs
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileNonStiff" => true)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileStiff" => false)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileAutoSwitch" => false)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileAutoSwitch" => false)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileDefaultSpecialize" => true)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileAutoSpecialize" => false)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileFunctionWrapperSpecialize" => false)
set_preferences!(UUID("1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"), "PrecompileNoSpecialize" => false)
```

## Bonus Extra Profiling Tool

I couldn't figure out where else to put this, so if you want to know the compile time contributions
per method instance that is getting invalidated, you can print this out via:

```julia
julia> show(stdout,MIME"text/plain"(),staleinstances(tinf))
45-element Vector{SnoopCompileCore.InferenceTiming}:
 InferenceTiming: 0.000051/0.010410 on ForwardDiff.var"#s10#33"(::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.000442/0.010359 on ForwardDiff.tupexpr(#34::ForwardDiff.var"#34#35", ::Any)
 InferenceTiming: 0.000990/0.008745 on collect(::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#34#35"}} where _A)
 InferenceTiming: 0.002431/0.004820 on Base.collect_to_with_first!(::AbstractArray, ::Expr, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#34#35"}} where _A, ::Any)
 InferenceTiming: 0.000351/0.006221 on ForwardDiff.tupexpr(#34::ForwardDiff.var"#34#35", ::Int64)
 InferenceTiming: 0.000057/0.000622 on Base.cconvert(::Type{Int32}, ::Enum{T2}) where T2<:Integer
 InferenceTiming: 0.000170/0.000565 on Int32(::Enum)
 InferenceTiming: 0.000114/0.000175 on Static.var"#s3#1"(::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.000129/0.000199 on Static.var"#s3#2"(::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.000117/0.000180 on Static.var"#s3#3"(::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.000129/0.000193 on Static.var"#s3#5"(::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.005421/0.011408 on getindex(::Core.SimpleVector, ::AbstractArray)
 InferenceTiming: 0.000917/0.000917 on Base.IteratorSize(::AbstractArray)
 InferenceTiming: 0.009340/0.014736 on ArrayInterface.var"#s13#18"(::Any, ::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.000730/0.002170 on (::Colon)(::Int64, ::Static.StaticInt{U}) where U
 InferenceTiming: 0.001248/0.001248 on ArrayInterface.OptionallyStaticUnitRange(::Int64, ::Union{Int64, Static.StaticInt})
 InferenceTiming: 0.000192/0.000192 on ArrayInterface.OptionallyStaticUnitRange(::Int64, ::Integer)
 InferenceTiming: 0.001313/0.002110 on ArrayInterface.var"#s13#21"(::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.000906/0.001342 on ArrayInterface.var"#s13#22"(::Any, ::Any, ::Any, ::Any, ::Type, ::Any)
 InferenceTiming: 0.001090/0.001946 on Static.var"#s3#27"(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.002478/0.004839 on ArrayInterface.var"#s49#45"(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Type, ::Type, ::Any)
 InferenceTiming: 0.001974/0.002299 on ArrayInterface.rank_to_sortperm(::Tuple{Vararg{Static.StaticInt, N}}) where N
 InferenceTiming: 0.000070/0.015091 on ForwardDiff.var"#s10#21"(::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.000489/0.015021 on ForwardDiff.tupexpr(#22::ForwardDiff.var"#22#23", ::Any)
 InferenceTiming: 0.001327/0.013339 on collect(::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#22#23"}} where _A)
 InferenceTiming: 0.000279/0.000279 on Base._array_for(::Type{Symbol}, ::Any, Base.HasLength()::Base.HasLength)
 InferenceTiming: 0.002368/0.007726 on Base.collect_to_with_first!(::AbstractArray, ::Symbol, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#22#23"}} where 
_A, ::Any)
 InferenceTiming: 0.002375/0.005359 on Base.collect_to!(::AbstractArray, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#22#23"}} where _A, ::Any, ::Any)    
 InferenceTiming: 0.002984/0.002984 on Base.setindex_widen_up_to(::AbstractArray, ::Symbol, ::Any)
 InferenceTiming: 0.000394/0.006532 on ForwardDiff.tupexpr(#22::ForwardDiff.var"#22#23", ::Int64)
 InferenceTiming: 0.000053/0.010643 on ForwardDiff.var"#s10#42"(::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.000459/0.010590 on ForwardDiff.tupexpr(#43::ForwardDiff.var"#43#44", ::Any)
 InferenceTiming: 0.001090/0.008975 on collect(::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#43#44"}} where _A)
 InferenceTiming: 0.002429/0.004903 on Base.collect_to_with_first!(::AbstractArray, ::Expr, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#43#44"}} where _A, ::Any)
 InferenceTiming: 0.000367/0.006414 on ForwardDiff.tupexpr(#43::ForwardDiff.var"#43#44", ::Int64)
 InferenceTiming: 0.000088/0.032105 on ForwardDiff.var"#s10#45"(::Any, ::Any, ::Any)
 InferenceTiming: 0.000833/0.032017 on ForwardDiff.tupexpr(#46::ForwardDiff.var"#46#47", ::Any)
 InferenceTiming: 0.001881/0.011196 on collect(::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#46#47"}} where _A)
 InferenceTiming: 0.002700/0.005390 on Base.collect_to_with_first!(::AbstractArray, ::Expr, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#46#47"}} where _A, ::Any)
 InferenceTiming: 0.000511/0.007142 on ForwardDiff.tupexpr(#46::ForwardDiff.var"#46#47", ::Int64)
 InferenceTiming: 0.000059/0.011278 on ForwardDiff.var"#s10#48"(::Any, ::Any, ::Any, ::Any, ::Any, ::Any)
 InferenceTiming: 0.000487/0.011219 on ForwardDiff.tupexpr(#49::ForwardDiff.var"#49#50", ::Any)
 InferenceTiming: 0.001180/0.009389 on collect(::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#49#50"}} where _A)
 InferenceTiming: 0.002482/0.004950 on Base.collect_to_with_first!(::AbstractArray, ::Expr, ::Base.Generator{_A, ForwardDiff.var"#16#17"{ForwardDiff.var"#49#50"}} where _A, ::Any)
 InferenceTiming: 0.000393/0.007056 on ForwardDiff.tupexpr(#49::ForwardDiff.var"#49#50", ::Int64)
 ```

## Constant Type Handling for Automatic Differentiation with ForwardDiff.jl

If one naively uses ForwardDiff.jl inside of their solver package, then there are two things that will
not be easily handled in the wrapper: the tag type and the chunk size. I already mentioned above that one
simple hack is to always force chunk size equal to one. For the tag type, you will need to setup
a [package tag](https://www.stochasticlifestyle.com/improved-forwarddiff-jl-stacktraces-with-package-tags/)
so that the automatic differentiation is not dependent on the the function type and is instead constant
for the package. I highly recommend using 
[SparseDiffTools.jl instead](https://github.com/JuliaDiff/SparseDiffTools.jl), since its higher level
calls allow for setting the tag and chunk sizes more directly.

Once that is done, you can directly compute all of the possible method dispatchs
with and without automatic differentiation, and generate the FunctionWrappersWrapper to handle all of
the combinations. For DiffEqBase this looks like:

```julia
function wrapfun_iip(ff,
                     inputs::Tuple{T1, T2, T3, T4}) where {T1, T2, T3, T4}
    T = eltype(T2)
    dualT = dualgen(T)
    dualT1 = ArrayInterfaceCore.promote_eltype(T1, dualT)
    dualT2 = ArrayInterfaceCore.promote_eltype(T2, dualT)
    dualT4 = dualgen(promote_type(T, T4))

    iip_arglists = (Tuple{T1, T2, T3, T4},
                    Tuple{dualT1, dualT2, T3, T4},
                    Tuple{dualT1, T2, T3, dualT4},
                    Tuple{dualT1, dualT2, T3, dualT4})

    iip_returnlists = ntuple(x -> Nothing, 4)

    fwt = map(iip_arglists, iip_returnlists) do A, R
        FunctionWrappersWrappers.FunctionWrappers.FunctionWrapper{R, A}(Void(ff))
    end
    FunctionWrappersWrappers.FunctionWrappersWrapper{typeof(fwt), false}(fwt)
end
```

Note that we use the `ArrayInterfaceCore.promote_eltype(T1, dualT)` function to find out how to
promote `Vector{Float64}` to `Vector{Dual{...}}` in a generic way. Given the promotions that
have to happen for automatic differentation support, we need to safeguard this dispatch by
requiring that the promotion rules exist. We check for these method dispatches at compile time
using [Tricks.jl](https://github.com/oxinabox/Tricks.jl), and thus the safe version does not 
wrap if these don't exist:

```julia
f = if f isa ODEFunction && isinplace(f) && !(f.f isa AbstractDiffEqOperator) &&
        # Some reinitialization code still uses NLSolvers stuff which doesn't
        # properly tag, so opt-out if potentially a mass matrix DAE
        f.mass_matrix isa UniformScaling &&
        # Jacobians don't wrap, so just ignore those cases
        f.jac === nothing &&
        ((specialize === SciMLBase.AutoSpecialize && eltype(u0) !== Any &&
          RecursiveArrayTools.recursive_unitless_eltype(u0) === eltype(u0) &&
          one(t) === oneunit(t) &&
          Tricks.static_hasmethod(ArrayInterfaceCore.promote_eltype,
                                  Tuple{Type{typeof(u0)}, Type{dualgen(eltype(u0))}}) &&
          Tricks.static_hasmethod(promote_rule,
                                  Tuple{Type{eltype(u0)}, Type{dualgen(eltype(u0))}}) &&
          Tricks.static_hasmethod(promote_rule,
                                  Tuple{Type{eltype(u0)}, Type{typeof(t)}})) ||
        (specialize === SciMLBase.FunctionWrapperSpecialize &&
          !(f.f isa FunctionWrappersWrappers.FunctionWrappersWrapper)))
    return unwrapped_f(f, wrapfun_iip(f.f, (u0, u0, p, t)))
else
    return f
end
```

Note that since we are not wrapping the `jac` type, there's no reason to wrap `f` since it will recompile
anyways. That's just a current limitation of the design which can get lifted after I'm done spending too
much time writing blog posts.

Tada! Take care all.