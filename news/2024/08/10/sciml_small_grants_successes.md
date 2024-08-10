@def rss_pubdate = Date(2024,8,19)
@def rss = """First Successes of the SciML Small Grants Program: Faster OrdinaryDiffEq Startup and New Benchmarks"""
@def published = " 10 August 2024 "
@def title = "First Successes of the SciML Small Grants Program: Faster OrdinaryDiffEq Startup and New Benchmarks"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# First Successes of the SciML Small Grants Program: Faster OrdinaryDiffEq Startup and New Benchmarks

Earlier this year we lauched the [SciML Small Grants](https://sciml.ai/small_grants/) program
in order to get new contributors up and running in working on important projects. We are excited to
share that this program has been successful in recruiting new contributors and we have some results to
share. 

## Refactor OrdinaryDiffEq.jl to use Sub-Packages of Solvers (\$600)

Origionally set at $300, this project was expanded to two months with the bounty doubled after the full
scope of the work was found to be much larger than expected. 

- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2253
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2256
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2264
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2267
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2268
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2272
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2274
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2285
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2286
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2292
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2301
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2303
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2304
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2308
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2312

This was in conjunction with some helper PR from the library maintainers:

- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2240
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2357
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2321
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2313
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2311
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2309
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2300
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2302
- https://github.com/SciML/OrdinaryDiffEq.jl/pull/2299

Altogether, having Param Umesh Thakkar join our team as a contributor and work through this refactor has
turned into a major improvement for users of DifferentialEquations.jl because one can now install
packages which are solver-specific, greatly reducing the dependencies required and thus the installation
and load times. For example, let's check out if you want just the `Tsit5` integrator. Because of the
importance of this method, it was turned into its own solver subpackage. Prior to these changes, the
first call time was:

```julia
@time begin
    using OrdinaryDiffEq

    function lorenz(du, u, p, t)
        du[1] = 10.0(u[2] - u[1])
        du[2] = u[1] * (28.0 - u[3]) - u[2]
        du[3] = u[1] * u[2] - (8 / 3) * u[3]
    end

    lorenzprob = ODEProblem(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0))
    sol = solve(lorenzprob, Tsit5());
end;

# 2.459902 seconds (5.46 M allocations: 349.671 MiB, 3.02% gc time, 22.39% compilation time)
```

Now using the `Tsit5` specific package we get:

```julia
@time begin
    using OrdinaryDiffEqTsit5

    function lorenz(du, u, p, t)
        du[1] = 10.0(u[2] - u[1])
        du[2] = u[1] * (28.0 - u[3]) - u[2]
        du[3] = u[1] * u[2] - (8 / 3) * u[3]
    end

    lorenzprob = ODEProblem(lorenz, [1.0; 0.0; 0.0], (0.0, 1.0))
    sol = solve(lorenzprob, Tsit5());
end;
# 0.564754 seconds (975.66 k allocations: 72.982 MiB, 1.42% gc time, 15.30% compilation time: 2% of which was recompilation)
```

This can go even further in the near future. By looking at the load time statistics:

```julia
@time_imports using OrdinaryDiffEqTsit5

[ Info: Precompiling OrdinaryDiffEqTsit5 [b1df2697-797e-41e3-8120-5422d3b24e4a]
               ┌ 0.0 ms DocStringExtensions.__init__() 
     12.0 ms  DocStringExtensions 91.45% compilation time
      0.3 ms  Reexport
      5.9 ms  Preferences
      0.3 ms  PrecompileTools
      1.0 ms  ArrayInterface
      0.6 ms  StaticArraysCore
      0.4 ms  ArrayInterface → ArrayInterfaceStaticArraysCoreExt
      4.0 ms  FunctionWrappers
      0.3 ms  MuladdMacro
      2.2 ms  OrderedCollections
      0.4 ms  UnPack
      0.4 ms  Parameters
               ┌ 3.6 ms SuiteSparse_jll.__init__() 
      4.1 ms  SuiteSparse_jll
               ┌ 3.8 ms SparseArrays.CHOLMOD.__init__() 83.60% compilation time
     94.1 ms  SparseArrays 3.40% compilation time
      0.4 ms  ArrayInterface → ArrayInterfaceSparseArraysExt
      0.6 ms  Statistics
      0.3 ms  IfElse
      6.9 ms  Static
      0.6 ms  Compat
      0.3 ms  Compat → CompatLinearAlgebraExt
               ┌ 0.0 ms Requires.__init__() 
      0.5 ms  Requires
      9.2 ms  StaticArrayInterface
      0.7 ms  ManualMemory
               ┌ 0.0 ms ThreadingUtilities.__init__() 
      3.8 ms  ThreadingUtilities
      0.4 ms  SIMDTypes
      1.6 ms  LayoutPointers
      1.7 ms  CloseOpenIntervals
      5.3 ms  StrideArraysCore
      0.4 ms  BitTwiddlingConvenienceFunctions
               ┌ 0.0 ms CPUSummary.__init__() 
      1.1 ms  CPUSummary
               ┌ 0.0 ms PolyesterWeave.__init__() 
      4.1 ms  PolyesterWeave
      0.7 ms  Polyester
      0.4 ms  FastBroadcast
      5.3 ms  RecipesBase
      0.4 ms  ExprTools
      0.6 ms  RuntimeGeneratedFunctions
      5.3 ms  MacroTools
     14.5 ms  Test
      0.6 ms  InverseFunctions
      0.3 ms  InverseFunctions → DatesExt
      0.5 ms  ConstructionBase
      0.3 ms  CompositionsBase
      0.3 ms  CompositionsBase → CompositionsBaseInverseFunctionsExt
               ┌ 0.0 ms Accessors.__init__() 
      7.3 ms  Accessors
      2.1 ms  SymbolicIndexingInterface
      0.5 ms  Adapt
      0.3 ms  DataValueInterfaces
      0.6 ms  DataAPI
      0.3 ms  IteratorInterfaceExtensions
      0.4 ms  TableTraits
      5.8 ms  Tables
      1.5 ms  GPUArraysCore
      0.4 ms  ArrayInterface → ArrayInterfaceGPUArraysCoreExt
     11.3 ms  RecursiveArrayTools
      0.5 ms  RecursiveArrayTools → RecursiveArrayToolsFastBroadcastExt
               ┌ 0.0 ms TruncatedStacktraces.__init__() 
      0.5 ms  TruncatedStacktraces
      5.5 ms  Setfield
      2.9 ms  IrrationalConstants
      0.7 ms  DiffRules
      0.7 ms  DiffResults
               ┌ 1.4 ms OpenLibm_jll.__init__() 
      2.0 ms  OpenLibm_jll
      0.5 ms  NaNMath
      0.5 ms  LogExpFunctions
      0.4 ms  LogExpFunctions → LogExpFunctionsInverseFunctionsExt
      0.5 ms  JLLWrappers
               ┌ 10.0 ms CompilerSupportLibraries_jll.__init__() 26.91% compilation time
     10.7 ms  CompilerSupportLibraries_jll 25.26% compilation time
               ┌ 0.6 ms OpenSpecFun_jll.__init__() 
      1.3 ms  OpenSpecFun_jll
      4.2 ms  SpecialFunctions
      0.5 ms  CommonSubexpressions
     19.9 ms  ForwardDiff
      0.7 ms  RecursiveArrayTools → RecursiveArrayToolsForwardDiffExt
      0.6 ms  EnumX
      0.5 ms  ConcreteStructs
      0.5 ms  FastClosures
      0.7 ms  PreallocationTools
      0.6 ms  FunctionWrappersWrappers
      0.6 ms  SciMLStructures
               ┌ 0.0 ms Distributed.__init__() 
      8.0 ms  Distributed
      0.6 ms  CommonSolve
      2.1 ms  ADTypes
     51.0 ms  MLStyle 20.48% compilation time
      3.2 ms  Expronicon
      6.1 ms  SciMLOperators
               ┌ 0.0 ms SciMLBase.__init__() 
    109.4 ms  SciMLBase
      0.8 ms  Tricks
      7.4 ms  DiffEqBase
     33.8 ms  FillArrays
      1.9 ms  FillArrays → FillArraysSparseArraysExt
      0.6 ms  FillArrays → FillArraysStatisticsExt
      0.5 ms  SimpleUnPack
     16.9 ms  DataStructures
     16.6 ms  OrdinaryDiffEqCore
    213.3 ms  OrdinaryDiffEqTsit5
```

It's clear that almost all of the remaining time is in loading. SparseArrays and thus 100ms will be cut
off once Statistics.jl no longer requires SparseArrays in Julia v1.11. The SciMLBase and OrdinaryDiffEqTsit5
load times are being looked into in order to decrease it. We believe that we can get this down to around 
200ms total on the first run, basically making the explicit Runge-Kutta methods feel instant without
losing any feature support.

Again, major thanks to Param Umesh Thakkar for his hard work on this refactor.

## DAE Problem Benchmarks (\$100 / Benchmark)

Marko Polic added a benchmark for the transistor amplifiers.

- https://github.com/SciML/SciMLBenchmarks.jl/pull/1007

The built benchmark can now be found in the SciMLBenchmark documentation:

- https://docs.sciml.ai/SciMLBenchmarksOutput/dev/DAE/TransistorAmplifier/

In particular, this benchmark has highlighted some missing features in ModelingToolkit structural simplification,
namely to do with handling of singularity removal with parametric mass matrices, and also with the
cost difference of diagonalizing the mass matrix vs allowing for non-diagonal mass matrices. Thus
this benchmark will serve as an important development point for future changes to the compiler
stack!

## Interested in the Small Grants Program?

Do you want to become a contributor to the SciML Open Source Scientific Machine Learning organization?
If so, check out the [SciML Small Grants](https://sciml.ai/small_grants/) page to get started with
applying!
