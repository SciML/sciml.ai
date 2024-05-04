@def title = "SciML Small Grants Program Current Project List"
@def tags = ["home", "sciml", "diffeq"]

# SciML Small Grants Program Current Project List

The following is the current project list for the SciML Small Grants Program.

## Rules and Regulations

The small grant projects are decided by the SciML Steering Council and candidates
can choose to take on projects from the project list. This is similar to
"bounty programs" seen in other open source environments, though it is driven
by SciML in a manner that is designed to give better outcomes to both
contributors and maintainers of the project. In order to remove a hostile
competitive atmosphere, **candidates must declare to the committee interest
before solving the chosen issue** and, upon approval by the selection committee,
are given an exclusive time  interval (defaulting to one month) to solve the issue.
Payout is done upon completion of the chosen project and acceptance by the steering
council.

All projects are expected to contribute the code to repositories in the SciML Github
organization. Code which is not contributed to the open source repositories will not
be considered in the approval evaluations.

## Declaring for a Project

To declare for a small grant program, send an email to sciml@julialang.org with:

* Full legal name
* CV
* Link to Github account
* Short bio / background about your experience in the topic
* Description of which project you're interested in

The potential reviewers will then get in touch to clarify details of the project and
establish a clear work statement. Once clarifed, steering council will then respond with
whether the application is accepted and commence the work under the supervision of the
reviewer. When the reviewer accepts and merges the appropriate PRs, the grant will be
determined as completed and the payout will commence. The grants are project based and
payout will only occur upon acceptance by the reviewer.

Note that information about ongoing projects will be tracked as public information
below in order to give clear information to other contributors about what projects
are taken. Completed projects will be added to a projects archive.

## Donating to the Program

If you wish to donate to the SciML Small Grants Program,
[please donate via NumFOCUS](https://numfocus.org/donate-to-sciml). SciML via NumFOCUS
is a 501(c)(3) public charity in the United States. Your donation is tax-deductible
to the extent provided by US law. General donated funds are used for the developer
programs such as the small grants program and the SciML Fellowship.

Donations can be earmarked towards specific projects. In order for an earmarked
project to become a part of the SciML Small Grants program it must be
approved by the SciML Steering Council. The reason why all chosen projects must be
vetted by the Steering Council is that we want to be fair to the potential contributors,
and this means we must ensure that the suggested projects will have a prompt review
process and proper maintanance beyond the timeframe of the project. For this reason,
we suggest discussing with maintainers in the official Slack/Zulip before making
an earmarked donation.

## Commitments from Reviewers

Reviewers are committed to giving timely feedback and reviews. It is expected that you keep
in constant touch with the reviewer during the duration of the project, discussing on
one of the community chat channels at least a few times a week until project completion.
Discussions should take place in the SciML Slack or Zulip channels (#diffeq-bridged or
#sciml-bridged) to allow for other contributors to give feedback. Reviews of PRs should be
expected within a few days to ensure the contributor can complete the project in the
allotted time frame.

It is expected that the contributor can work fairly independently with guidence from the
reviewer.

# List of Current Projects

## Fix and Update the "Simple Handwritten PDEs as ODEs" Benchmark Set (\$200)

The "Simple Handwritten PDEs as ODEs" benchmarks have been failing for awhile.
They need to be updated to the "new" linear solve syntax introduced in 2022.
When updated, these benchmarks should serve as a canonical development
point for PDE-specific methods, such as implicit-explicit (IMEX) and
exponential integrators.

**Information to Get Started**: The
[Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. Half of the benchmarks are setup
using hand-discretized finite difference stencils for the PDE, the other
half use ApproxFun.jl in order to do a pseudospectral discretization.
A direct pseudospectral discretization via manual FFTs and operator
construction would also be fine.

**Related Issues**: [https://github.com/SciML/SciMLBenchmarks.jl/issues/929](https://github.com/SciML/SciMLBenchmarks.jl/issues/929)

**Success Criteria**: Pull requests which [update the benchmarks in the
folder](https://github.com/SciML/SciMLBenchmarks.jl/tree/master/benchmarks/SimpleHandwrittenPDE)
to be sucessful with current Julia and package version (v1.10) without
erroring, generating work-precision diagrams. In addition, these should be updated
to give a more clear definition of the PDE being solve, adding a LaTeX
description of the equations to the top of the file.

**Recommended Skills**: Basic (undergrad-level) knowledge of finite difference and pseudospectral
PDE discretiations.

**Reviewers**: Chris Rackauckas

## Update BlackBoxOptimizationBenchmarking.jl to the Optimization.jl Interface and Add to SciMLBenchmarks (\$300)

[BlackBoxOptimizationBenchmarking.jl](https://github.com/jonathanBieler/BlackBoxOptimizationBenchmarking.jl)
is a very interesting set of benchmarks between global optimization tools. However,
it has not been updated in years. It would be useful to the community if this
set of benchmarks was updated to the modern SciML interfaces and benchmarking tools
so it can make use of the full set of methods in Optimization.jl and drive further
developments and recommendations to users.

**Information to Get Started**: The
[Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. It is expected that the benchmarks are
updated to use the [Optimization.jl](https://docs.sciml.ai/Optimization/stable/)
interface, which is an interface over most optimizers in Julia. Not all of the
optimizers are covered in this interface: simply remove the optimizers which
are not wrapped into Optimization.jl

**Related Issues**: [https://github.com/SciML/SciMLBenchmarks.jl/issues/640](https://github.com/SciML/SciMLBenchmarks.jl/issues/640)

**Success Criteria**: The benchmarks should be turned into a loop over Optimization.jl
solvers in a standard SciMLBenchmarks benchmark build.

**Recommended Skills**: Basic (undergrad-level) knowledge of using numerical optimizers

**Reviewers**: Chris Rackauckas and Vaibhav Dixit

## Update CUTEst.jl to the Optimization.jl Interface and Add to SciMLBenchmarks (\$200)

[CUTEst.jl](https://github.com/JuliaSmoothOptimizers/CUTEst.jl)
is a repository of constrained and unconstrained nonlinear programming problems for testing
and comparing optimization algorithms. We would like to be able to repurpose this work for
improving Optimization.jl's performance and tracking the performance of optimizers. It would
be useful to the community if this set of benchmarks was updated to the modern SciML
interfaces and benchmarking tools so it can make use of the full set of methods in
Optimization.jl and drive further developments and recommendations to users.

This would likely turn into either contributions to CUTEst or wrappers to CUTEst (hosted in
SciML) which which transform the NLPModels form into Optimization.jl, and a benchmarking
script that loops over all optimization problems and applies a set of optimizers to each of
them, computing summary statistics at the bottom.

**Information to Get Started**: The
[Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. It is expected that the benchmarks are
updated to use the [Optimization.jl](https://docs.sciml.ai/Optimization/stable/)
interface, which is an interface over most optimizers in Julia. Not all of the
optimizers are covered in this interface: simply remove the optimizers which
are not wrapped into Optimization.jl

**Related Issues**: [https://github.com/SciML/SciMLBenchmarks.jl/issues/935](https://github.com/SciML/SciMLBenchmarks.jl/issues/935)

**Success Criteria**: The benchmarks should be turned into a loop over Optimization.jl
solvers in a standard SciMLBenchmarks benchmark build.

**Recommended Skills**: Basic (undergrad-level) knowledge of using numerical optimizers

**Reviewers**: Chris Rackauckas and Vaibhav Dixit

## Refactor OrdinaryDiffEq.jl to use Sub-Packages of Solvers (\$300)

It's no surprise to anyone to hear that DifferentialEquations.jl, in particular the
OrdinaryDiffEq.jl solver package, is very large and takes a long time to precompile.
However, this is because there are a lot of solvers in the package. The goal would
be to refactor this package so that sets of solvers are instead held in subpackages
that are only loaded on-demand. Since many of the solvers are only used in more
niche applications, this allows for them to be easily maintained in the same repo
while not imposing a loading cost on the more standard appliations.

**Information to Get Started**: The OrdinaryDiffEq.jl solvers are all found in
[the Github repository](https://github.com/SciML/OrdinaryDiffEq.jl) and
the format of the package is docmented in the
[developer documentation](https://docs.sciml.ai/DiffEqDevDocs/stable/)

**Related Issues**: [https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177)

**Success Criteria**: The independent solver packages are registered and released,
and a breaking update to OrdinaryDiffEq.jl is released which reduces the loading
time by not including all solvers by default. This success also requires updating
package documentation to reflect these changes.

**Recommended Skills**: Since all of the code for the solvers exists and this a refactor,
no prior knowledge of numerical differential equations is required. Only standard software
development skills and test-driven development of a large code base is required.

**Reviewers**: Chris Rackauckas

## Refactor OrdinaryDiffEq.jl Solver Sets to Reuse perform_step! Implementations via Tableaus (\$100/solver set)

The perform_step! implementations per solver in OrdinaryDiffEq.jl are often "bespoke", i.e.
one step implementation per solver. The reason is because the package code grew organically
over time and this is the easiest way to ensure performance and write out a new method.
However, many of the methods can be collapsed by class into a single solver set using a
tableau implementation that loops over coefficients. Because of the nuances in performance
and implementation, we have avoided doing this refactoring until a few more pieces were
set in stone.

Note that this should be done based on classes of solvers, as documented in the code
as files in the `perform_step!` implementations (though the explicit Runge-Kutta methods
are split across a few files and should all be a single tableau). Solver set should
be discussed before starting the project.

It is recommended that implicit methods such as Rosenbrock and SDIRK integrators are
done first, as the extra intricacies of their algorithm make this refactor simpler
because the nuances of the implementation are less likely to noticably impact performance.

**Information to Get Started**: The OrdinaryDiffEq.jl solvers are all found in
[the Github repository](https://github.com/SciML/OrdinaryDiffEq.jl) and
the format of the package is docmented in the
[developer documentation](https://docs.sciml.ai/DiffEqDevDocs/stable/). The key to doing
this right is to note that it is just a refactor, so all of the methods are there in
the package already. However, note that some methods can be a bit nuanced, for example,
BS5 and DP8 use fairly non-standard error estimators for an explicit Runge-Kutta method,
while Verner methods have a twist with laziness. Because of this, the key is to be
careful to add points to dispatch to alternative based on the nuances of the given algorithms.

**Related Issues**: [https://github.com/SciML/OrdinaryDiffEq.jl/issues/233](https://github.com/SciML/OrdinaryDiffEq.jl/issues/233)

**Success Criteria**: The independent solver packages are registered and released,
and a breaking update to OrdinaryDiffEq.jl is released which reduces the loading
time by not including all solvers by default. This success also requires updating
package documentation to reflect these changes.

**Recommended Skills**: Since all of the code for the solvers exists and this a refactor,
no prior knowledge of numerical differential equations is required. Only standard software
development skills and test-driven development of a large code base is required.

**Reviewers**: Chris Rackauckas

## Update LoopVectorization to Support Changes in Julia v1.12 (\$200)

[LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl) is a
central package for the performance of many Julia packages. Its internals make
use of many low-level features and manual SIMD that can make it require significant
maintanance to be optimized for new versions of the compiler.

**Information to Get Started**: 

With Julia v1.12:
 - [opaque pointer mode](https://releases.llvm.org/17.0.1/docs/OpaquePointers.html) is now the default
 - [Julia pointers are now LLVM pointers](https://github.com/JuliaLang/julia/pull/53687) instead of integers, as they were in earlier Julia versions.

The purpose of this project is to update LoopVectorization.jl, VectorizationBase.jl,
SLEEFPirates.jl and the rest of the JuliaSIMD ecosystem so that all the `llvmcall`s
use opaque pointers, and any `Ptr` arguments or returns are llvm `ptr`s instead of
integers. LoopVectorization.jl tests should pass under `--depwarn=error`.

Note that the funds for this project as given by earmarked donations to the JuliaLang project
which SciML will help administer through the small grants program.

**Success Criteria**: LoopVectorization.jl runs on v1.12's latest release.

**Recommended Skills**: This requires some low-level knoweldge of LLVM IR and familiarity with `llvmcall`. The changes should be routine.

**Reviewers**: Chris Elrod
