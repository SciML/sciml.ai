@def rss_pubdate = Date(2022,9,21)
@def rss = """How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1"""
@def published = " 21 September 2022 "
@def title = "How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# How Julia ODE Solve Compile Time Was Reduced From 30 Seconds to 0.1

We did it. We got control of our compile times in a large-scale >100,000 line of code
Julia library. The end result looks like:

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
in the early phase of this project, the flamegraph looked like this:

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

This eludes to a simple fix: just call the methods that you need. For example, in the example `MyPackage`,
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
Let's do it the same way as on `MyPackage:

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

## The Next Step: Improving Using Times via Requires.jl Removal, Package Splitting, and Reduced Invalidations

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

### The Story of Invalidations

Even with all of these changes, in some cases the cost of `using` could remain high. The reason is
invalidations. To illustrate where invalidations can come from, let's look at the following example.
Let's say in package MyPackage I define the function:

```julia

```

## Improving Inference and Connection to Function Specialization

Now with everything precompiling well and no longer invalidating (as much), it's time to address the
second question that we posed a few hundred lines earlier:

> How do we improve the compile-times of things which are not precompiled?

## Conclusions and Lasting Thoughts

Nothing is complete, but huge strides have been made. Major thanks to Tim Holy who put together the
tools required to make these changes. A summary of our current position is as follows:

* Every package should setup a SnoopPrecompile.jl block. While the precompilation ownership changes
  allow for downstream usage to precompile without such a block, covering the standard cases will
  allow the ecosystem to reduce the total amount of compilation caches and thus improve precompile
  times and reduce using times.
* Julia could use a better conditional module loading system in future versions. That would help lower
  package loading times. For now, sectioning off "core" portions of a package and making diligent use
  of subpackaging can be helpful. Avoid Requires.jl when possible.
* Delay large loads until as late as possible.
* Better interfaces in Julia Base would reduce the dependency tree requirements downstream as more
  AbstractArray and Number packages would have consistently compile-time queriable information. Upstreaming
  of portions of ArrayInterface to Base and changing the 
  [Base AbstractArray Interface](https://docs.julialang.org/en/v1/manual/interfaces/) would thus
  facilitate better code with more explicit checking of assumptions and reduce package load times. 