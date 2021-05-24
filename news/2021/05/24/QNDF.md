@def rss_pubdate = Date(2021,5,24)
@def rss = """SciML Ecosystem Update: Improved QNDF Outperforms CVODE Across the Board"""
@def published = " 24 May 2021 "
@def title = "SciML Ecosystem Update: Improved QNDF Outperforms CVODE Across the Board"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: Improved QNDF Outperforms CVODE On SciMLBenchmarks

It has been a few months so there's a lot to update, especially in terms of
performance improvements. But let's start with the announcement of how we have
solved one of the longest running issues in the SciML universe.

## QNDF Improvements Removes CVODE From All Recommendations and Defaults

For context, let's look at the previous DifferentialEquations.jl documentation
on how to choose a stiff ODE solver:

> For stiff problems at high tolerances (>1e-2?) it is recommended that you use
  Rosenbrock23 or TRBDF2...

Okay, it keeps on going and going. All of the methods it recommends are from
OrdinaryDiffEq.jl though, which is all guided by
[the SciMLBenchmark results](https://github.com/SciML/SciMLBenchmarks.jl).

But at the very end of the recommendations you see:

> For asymptotically large systems of ODEs (N>1000?) where f is very costly and
  the complex eigenvalues are minimal (low oscillations), in that case CVODE_BDF
  will be the most efficient but requires Vector{Float64}. CVODE_BDF will also
  do surprisingly well if the solution is smooth. However, this method can
  handle less stiffness than other methods and its Newton iterations may fail
  at low accuracy situations. Another good choice for this regime is lsoda.

In translation, "if you happen to be in the asymptotically big case, you still need
to make use of Sundials".

**That is no more. The king has fallen. Long live QNDF.**

For awhile, OrdinaryDiffEq.jl had a few BDF implementations, (`ABDF2`, `QBDF`, `QNDF`, etc.)
but none of them stacked up to Sundials.jl in this regime. And BDF-type methods
are just better suited for this regime than Rosenbrock, SDIRK, and FIRK methods
which OrdinaryDiffEq.jl had already heavily optimized beyond the previous software.
This domain though just keep being elusive.

In 2017 Yingbo and I had many conversations on the right approach for this, and
those ideas refined and converged over the years. Nordseick seems less numerically
stable in comparison to divided differences when done correctly. Shampine's NDF
seems like it should be an improvement over BDF, but there's no high performance
implementations. Etc. Putting all of this together, Yingbo had pieces of these
ideas implemented over 8 repos in the span of the 4 years moving towards this
idea. In 2018, a GSoC student implemented a "from the textbook" NDF, the
previous `QNDF`, which did admirably but didn't match CVODE.

But it kept marching on in many ways. OrdinaryDiffEq.jl started to use its own
[pure Julia implemented BLAS routines](https://github.com/YingboMa/RecursiveFactorization.jl),
having all sorts of [auto-optimizing SIMD](https://github.com/YingboMa/FastBroadcast.jl),
etc. Finally, on May 22, 2021, Yingbo with a new summer student, Junpeng Gao (@JunpengGao233),
cracked the code. They pair programed and ended up with [this mega PR](https://github.com/SciML/OrdinaryDiffEq.jl/pull/1411).
The result? In [the entire SciMLBenchmarks](https://github.com/SciML/SciMLBenchmarks.jl),
`QNDF` matches or outperforms `CVODE_BDF`. It ranges from 20 stiff ODEs with POLLU:

![](https://user-images.githubusercontent.com/1814174/119265210-dca0d500-bbb3-11eb-9486-9485b88db2a2.png)

to 1,000 stiff ODEs with BCR:

![](https://user-images.githubusercontent.com/17304743/119210963-6f8b2380-ba7d-11eb-839a-017423723acd.png)

and on a difficult HVAC model, we saw it taking larger steps, less Jacobians,
and factorizing less:

![](https://user-images.githubusercontent.com/1814174/119265211-dca0d500-bbb3-11eb-82f0-fd3049a64b33.png)

Across the board we saw the dream had finally come together, with all of the
pieces in handfuls of different repositories coming together to give a new great
algorithm. Because of this, the automated algorithm selection of
DifferentialEquations.jl v6.17 no longer chooses `CVODE_BDF` in any scenario.
As `CVODE_Adams` is always outperformed in the benchmarks by either `Tsit5`,
`Vern7`, `Vern9`, or `VCABM`, and `ARKODE` is outperformed by the same or
`KenCarp47` or `TRBDF2`, the benchmarks, recommendations, and automated algorithm
choices no longer make use of Sundials.jl.

The importance of this cannot be understated. Working with a C++ code binding
always had limitations in the special linear solvers that could be used,
interactions with the JIT compiler, [the ability to work with CUDA and AMDGPUs
in a automatic way](https://github.com/SciML/DiffEqGPU.jl), the ability to
differentiate through the solver. By having the dominant algorithm as pure Julia,
all of these issues are now solved as it interacts with the compiler in a native
way. This will be important as it allows automating the development of multi-GPU
MPI codes (coming soon!), further expanding the reach of "asymptotically large
systems".

Sundials is absolutely fantastic, it should be applauded that in a 300 solver
implementation effort with over 100 developers involved in many commits, with
over 100 repositories and entire funded teams and labs helping to improve
various aspects over 5 years, `CVODE_BDF` stood strong as unbeatable in an
important category even while we had repeatedly attempted to find ways to unseat
it. But, sooner or later it had to be overcome, and that time has come. We are
very thankful to the developers of Sundials as their decades of code and
writings have been immensely helpful in unpacking this subject, and we hope to
contribute to this area of ODEs as much as they have. But for now, Julia uses
can rejoice as if they are solving systems of more than 1,000 ODEs, they will
get a free speed boost, a feature boost, and a reduced dependency chain.

### Is this the end of Sundials.jl? No

Seeing these advancements, people have asked me this question pertaining to
maintenance of legacy code. Let it be stated directly:

**SciML is committed to maintaining legacy solver libraries**

In 2021 you can still use [ODE.jl on Julia v1.6](https://github.com/SciML/ODE.jl),
the solvers built 3 years before the creation of DifferentialEquations.jl. They
are locked in time giving the same answers at the same speed, allowing ease of
code updating.

Sundials.jl will likely evolve similarly. The advancement of `QNDF` means there
will likely be no attempts to connect to Sundials CUDA support, but what is there
will continue to be maintained. It's built with fancy LAPACK options, KLU
integration, etc. and it will continue to stay that way. It will be updated and
its tests will keep passing. But it will likely not capture as much developer
focus.

That said, there is one thing to make note of. There is still one place in the
entire DifferentialEquations.jl universe where a Sundials algorithm still reigns
supreme as the recommended algorithm over any pure Julia method, and that is not
in ODEs but DAEs. `IDA` is still unmatched in the pure Julia space. While it's
routinely outperformed if you have a DAE written in mass matrix form,
[giving rise to the recommendations of OrdinaryDiffEq.jl in many DAE cases](https://diffeq.sciml.ai/stable/solvers/dae_solve/#Recommended-Methods),
`IDA` is still unmatched when you have a fully-implicit DAE definition. That
will change. Junpeng Gao's summer project, under the mentorship of Yingbo, will
be to similarly build a pure Julia BDF/NDF for fully-implicit DAEs into
OrdinaryDiffEq.jl, aiming to similarly extensive benchmark and outperform `IDA`
by the end of the summer using the same tricks as `QNDF`. When that is completed,
we will finally flip the [last yellow box on DifferentialEquations.jl](https://www.stochasticlifestyle.com/comparison-differential-equation-solver-suites-matlab-r-julia-python-c-fortran/)
and end a half-decade >100 developer project to essentially have 99% of cases
most optimally use a pure Julia solver, optimized using the latest techniques
from the literature and purpose-built for the latest hardware. And that will
be a major congratulations to everyone who has been involved in this journey.

## Symbolics.jl E-Graph-Based Floating Point Cycles Minimization

If you missed the release of the new [JuliaSymbolics Organization](https://juliasymbolics.org/),
please check it out. It's a "daughter organization" with pieces spun out of
SciML since the symbolic computing became a world of its own. The [Symbolics.jl
roadmap](https://juliasymbolics.org/roadmap/) and [release announcement of
Symbolics.jl](https://discourse.julialang.org/t/ann-symbolics-jl-a-modern-computer-algebra-system-for-a-modern-language/56251)
received a ton of fanfare. We thank the community for the warm welcoming!

Since that time, Symbolics.jl has been moving rapidly with a lot of help of
Shashi Gowda (@shashi) and the new developer team that the new organization has
brought in. To highlight this, check out [the recently released publication on
Symbolics.jl](https://arxiv.org/abs/2105.03949). It showcases how E-graph
approaches of [Metatheory.jl](https://github.com/0x0f0f0f/Metatheory.jl)
combined with symbolic simplification can give rise to a mechanism for automatically
simplifying code into the form which takes the least floating point cycles. Symbolics.jl
will be a fantastic symbolic-numerics tool for the SciML community. We note that
ModelingToolkit.jl will stay in SciML, and is now built on top of the fully
documented Symbolics.jl computer algebra system.

## ModelingToolkit Outperforms Simulink by 15,000x on NASA Launch Services Application

Speaking of ModelingToolkit.jl, SciML user Jonnie Diegelman gave an enlightening
talk at SIAM CSE 2021 on how SciML tools are used by him to accelerate about
15,000x over Simulink. See the talk for yourself!

<iframe width="560" height="315" src="https://www.youtube.com/embed/tQpqsmwlfY0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Major Improvements to Adjoint Sensitivities with Ill-Conditioning (Stiffness)

Work in collaboration with the Deng Lab at MIT has lead to [advances in stiff
neural ordinary differential equations](https://arxiv.org/abs/2103.15341).
One of the main things that was shown is that you cannot just use a stiff ODE
solver with the adjoints you had before and expect it to work: you need to
use different adjoint techniques to do it stably and efficiently. We show
precisely how to tackle some classically hard stiff ODEs and train neural networks
on them using the latest techniques in [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl).
This is an extremely difficult domain but we hope to keep sharing new advances
as they are available.

## Order of Magnitude Performance Improvement in Training Neural ODEs By Differentiating the Solver

SciML developers recently published a paper at ICML showing how to improve
training performance of fast neural ODEs for machine learning applications
(image processing, natural language processing, etc.) by using differentiating
through the solver and [regularizing based on internal solver
heuristics](https://arxiv.org/abs/2105.03918). Importantly, this is not an approach
that can be done without defining something equivalent to differentiating the solver,
showcasing that the [generalized physics-informed approach through AD](http://ceur-ws.org/Vol-2587/article_8.pdf)
has applications beyond SciML problems. We thank Avik Pal (@avik-pal) for
doing a lot of the demonstrations in this work.

## Major Performance Improvements to NeuralPDE

[The recent work of Kirill Zubov](https://github.com/SciML/NeuralPDE.jl/pull/253)
mixed with CUDA.jl 3.0 has led to some pretty major performance improvements
with NeuralPDE.jl, particularly with GPUs. A formal benchmarking setup will be
built in the near future to track performance in a more concrete way.

## SciML Summer Projects to Look Forward To

As summer is starting, it's time for the yearly update of all of the exciting
announcements to expect soon. With 7 funded GSoC projects, 1
[开源软件供应链点亮计划 - 暑期2021](https://summer.iscas.ac.cn/#/org/orgdetail/julia?lang=en)
project, and many funded members across top universities and technical computing
companies dedicating their times to SciML, there is a huge list. But here's the
quickest summary:

- [Frank Shäfer](https://summerofcode.withgoogle.com/projects/?sp-page=2#5357798591823872)
  will be optimizing adjoints for neural hybrid differential equations and
  chaotic systems, as well as generalizing AD interfaces.
- [Vasily Ilin](https://summerofcode.withgoogle.com/projects/?sp-page=2#5463862406545408)
  will be creating optimized methods for representing and simulating spatial
  stochastic simulations.
- [Ilia Ilmer](https://summerofcode.withgoogle.com/projects/?sp-page=2#5493332257538048)
  will be adding routines for parameter identifiability analysis to ModelingToolkit.jl
- [Mohammed Jeeshan Sheikh](https://summerofcode.withgoogle.com/projects/?sp-page=5#4929042274320384)
  will be working with Emmanuel Lujan and Tino Sultzer to build out the
  [DiffEqOperators](http://diffeqoperators.sciml.ai/dev/) automated finite
  difference methods.
- [Ashutosh Bharambe](https://summerofcode.withgoogle.com/projects/?sp-page=2#5673227164057600),
  along with Zoe McCarthy and Kirill Zubov (and many others!) will be continuing
  the push on [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl)
  for integro-differential equations and optimizing for multi-node multi-GPU
  workflows.
- As mentioned earlier [Junpeng Gao](https://summer.iscas.ac.cn/#/org/prodetail/210370695?lang=en)
  will work with Yingbo Ma to further optimize `QNDF` and building a pure-Julia
  equivalent to IDA.
- Yingbo Ma will be ensuring that ModelingToolkit becomes a complete acausal
  language (and it already is basically there! Stay tuned for the next
  blog post!)
