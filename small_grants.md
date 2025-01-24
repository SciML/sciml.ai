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




* Arushi Gupta 
* Drive Link to my CV - https://drive.google.com/file/d/1VOc7QIArQLAlne1gg92luZpQh9-VgsOA/view?usp=sharing
* I am currently in my third year of undergraduate studies of Instrumentation and Control Engineering at NIT Jalandhar where I have built a good understanding of programming, mathematical modeling, and AI/ML. I have worked on machine learning models and workflows as evidenced by my projects such as GenSolve Curvetopia where I was able to perform curve regularization with soft functions on synthetic data to achieve high accuracy. Although my understanding of Physics Informed Neural Networks is at an undergraduate level, I am enthusiastic about engaging in more practical work. Furthermore, I have experience in performance optimization through Python and data analysis, and I have a basic understanding of GPU-based computations, which will allow me to effectively participate in the improvement of NeuralPDE.
* NeuralPDE is a package for training Physics Informed Neural Networks based on Lux.jl. It was originally developed from Flux and while updating to Lux, several older bits were left inplace. These need to be updated to a more Lux style approach.

If some anonymity is requested, you may instead send this information to sciml@julialang.org.

The potential reviewers will discuss the current-ness of the small grant project, the
availability of reviewers, and the willingness to review. The small grant project
is accepted when a majority of the steering council approves of the project and the PR
is merged. At that point the work will commence under the supervision of the
reviewer. When the reviewer accepts and merges the appropriate PRs, the grant will be
determined as completed and the payout will commence. The grants are project based and
payout will only occur upon acceptance by the reviewer.

Note that information about ongoing projects will be tracked as public information
below in order to give clear information to other contributors about what projects
are taken. Completed projects will be added to a projects archive.

## Going Over the One-Month Time Budget

Each project is given a one month exclusive period for the purpose of decreasing competition.
The difference between the small grants program and a standard bounty program is that we wish
to discourage "sniping" bounties from others, i.e. someone working for a few weeks on a project
before suddenly someone else appears with a complete solution and takes the payout. While this
is not impossible to prevent, as an open source community there may be others who happen to
be working the same project independently, to reduce the occurrences of this phonomena we have
a policy that payouts will only occur for declared projects. This policy can be overriden on
special circumstances by a majority vote of the steering council.

In order to discourage "spotting", i.e. claiming projects to sit on them indefinitely and thus
blocking other contributors, only one month exclusive periods are granted. If the project seems
to be going beyond this one month timeframe, the contributor should ask for an extension by
making a new pull request to bump the time window, which would then need to pass by a majority
vote of the steering council. If a new claim PR is opened after the time window has passed
without the contributor formally bumping the time window, then the new claim PR will be reviewed
under the assumption that the project is not currently active.

Note that unsuccessful small grants projects, i.e. claims of potential projects where the
contributor disappears and does not end up with a PR, will be used in the criteria of whether
further requests are accepted.

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

## Adding Projects to the List

If you wish to add a project to the small grants list, open a pull request in the 
[https://github.com/SciML/sciml.ai](https://github.com/SciML/sciml.ai) in the
`small_grants.md` file with a full description of the project and the suspected monetary
payout. New projects require approval by a steering committee member. The justification
for the funding is required. If it is a personal donation, it is recommended that personal
donation is made prior to the PR, though for known members of the community this requirement
can be waived. Some of the projects can be covered through prior grant funds and other
donations made to the SciML project, though it should not be assumed that this will be the
case for any project without review by a steering committee member.

## Commitments from Reviewers

Reviewers are committed to giving timely feedback and reviews. It is expected that you keep
in constant touch with the reviewer during the duration of the project, discussing on
one of the community chat channels at least a few times a week until project completion.
Discussions should take place in the SciML Slack or Zulip channels (#diffeq-bridged or
#sciml-bridged) to allow for other contributors to give feedback. Reviews of PRs should be
expected within a few days to ensure the contributor can complete the project in the
allotted time frame.

However, it is also expected that the contributor can work fairly independently with
guidance from the reviewer. Contributors are expected to be comfortable enough in the area
of expertise to work through the errors and test failures on their own. The SciML Small Grants
Program is not a training program like Google Summer of Code or the SciML Fellowship,
and thus the reviewer is not expected to mentor or teach the contributor how to solve the
problem. The reviewer is in no obligation to help the contributor work through tests, bug
fixing, etc. as these projects were chosen due to the fact that the maintainers have not been
able to find the time to cover these areas. The obligation of the reviewer is to give a
timely feedback on what the requirements for merging would be (i.e. what tests are required
to be added, whether certain code meets style demands, etc.) so that the contributor can
achieve a mergable PR within the time frame, but there is no expectation that the reviewer
will "go the extra mile" to teach the contributor how the package or mathematics works.

# List of Current Projects

## Update NeuralPDE to be more maintainable (\$300)

NeuralPDE is a package for training Physics Informed Neural Networks based on Lux.jl.
It was originally developed from Flux and while updating to Lux, several older bits
were left inplace. These need to be updated to a more Lux style approach.

**Information to Get Started**: The linked issue describes in detail what needs to be
done.

**Related Issues**: https://github.com/SciML/NeuralPDE.jl/issues/900

**Recommended Skills**: Basic (undergrad-level) knowledge of Physics Informed Neural
Networks and GPUs

**Reviewers**: Avik Pal, Chris Rackauckas

## Rewrite the NeuralPDE parser (\$300)

NeuralPDE is a package for training Physics Informed Neural Networks (PINNs) uses a
symbolic representation for problems which are then lowered into generated code for
the user, fully automating the PINN experience. However, the previous formulation of the
codegen process used pre-built kernels that can be difficult to debug. The goal of this
project is to rewrite the loss function generator to instead generate a Symbolics.jl
expression, which can be analyzed an generate code through `build_function`.

**Information to Get Started**: A partial uncompleted pull request https://github.com/SciML/NeuralPDE.jl/pull/877 can be used as a starting point.

**Recommended Skills**: Basic (undergrad-level) knowledge of Physics Informed Neural
Networks, and symbolic computing.

**Reviewers**: Chris Rackauckas

## Update SciMLOperators.jl to allow for different defining vectors from actions (\$500)

SciMLOperators.jl is a package for defining lazy operators `A(u,p,t)*v` which can be used
throughout the ecosystem. However, many of the operators incorrectly make the assumption
that `u = v`, i.e. `A(u,p,t)*u` is the operation. While this is the only case required
for some ODE integrators, this oversimplification limits the full usage of the library.
It is expected that this is a breaking change (with a major release bump) and is the
major change required for the v1.0 release.

**Information to Get Started**: The documentation of https://github.com/SciML/SciMLOperators.jl
should be sufficient.

**Recommended Skills**: Basic (undergrad-level) knowledge of linear operators and multiple dispatch
in Julia.

**Reviewers**: Chris Rackauckas

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

## SciMLBenchmarks Compatability Bump for Benchmark Sets (\100 each set)

**In Progress**: Both sets claimed by Param Umesh Thakkar for the time period of January 21st - February 21st.

The [SciMLBenchmarks](https://github.com/SciML/SciMLBenchmarks.jl) are a large set of benchmarks maintained
by the SciML organization. As such, keeping these benchmarks up-to-date can be a time-consuming task.
In many cases, we can end up in a situation where there are many package bumps that need to happen. Sometimes
no code needs to be updated, in other cases the benchmark code does need to be updated. The only way to tell
is to start the update process, bump the project and manifest tomls, and start digging into the results.

These bumps are done in subsets. The currently identified subsets are:

#### ParameterEstimation

* [https://github.com/SciML/SciMLBenchmarks.jl/pull/799](https://github.com/SciML/SciMLBenchmarks.jl/pull/799)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1063](https://github.com/SciML/SciMLBenchmarks.jl/pull/1063)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1064](https://github.com/SciML/SciMLBenchmarks.jl/pull/1064)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1065](https://github.com/SciML/SciMLBenchmarks.jl/pull/1065)

#### PINNs

* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1062](https://github.com/SciML/SciMLBenchmarks.jl/pull/1062)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1061](https://github.com/SciML/SciMLBenchmarks.jl/pull/1061)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1044](https://github.com/SciML/SciMLBenchmarks.jl/pull/1044)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/877](https://github.com/SciML/SciMLBenchmarks.jl/pull/877)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1060](https://github.com/SciML/SciMLBenchmarks.jl/pull/1060)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1059](https://github.com/SciML/SciMLBenchmarks.jl/pull/1059)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/1043](https://github.com/SciML/SciMLBenchmarks.jl/pull/1043)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/876](https://github.com/SciML/SciMLBenchmarks.jl/pull/876)
* [https://github.com/SciML/SciMLBenchmarks.jl/pull/605](https://github.com/SciML/SciMLBenchmarks.jl/pull/605)

**Information to Get Started**: The
[Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. It is expected that the developer checks that the benchmarks
are appropriately ran and generating correct graphs when updated, and highlight any performance
regressions found through the update process.

**Related Issues**: See the linked pull requests.

**Success Criteria**: The benchmarks should run and give similar results to the pre-updated benchmarks,
and any regressions should be identified with an issue opened in the appropriate repository.

**Recommended Skills**: Willingness to roll up some sleaves and figure out what changed in breaking updates.

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

## DAE Problem Benchmarks (\$100 / Benchmark)

New benchmarks for differential-algebraic equation (DAE) systems would greatly improve our
ability to better tune solvers across problems. However, we are currently lacking in the
number of such benchmarks that exist. The goal would be to add standard benchmarks from
[this issue](https://github.com/SciML/SciMLBenchmarks.jl/issues/359) to the SciMLBenchmarks
system so that they can be performance tracked over time.

**Information to Get Started**: [Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. The [transition amplifier benchmark](https://github.com/SciML/SciMLBenchmarks.jl/pull/372)
and [slider crank benchmark](https://github.com/SciML/SciMLBenchmarks.jl/pull/373) were old
PRs to add a few of the problems. These could be used as starting points to solve two problems.
One would likely need to modify the structural simplification to turn dummy derivative off
as well, that can be discsused with Chris in the PR review.

**Related Issues**: [https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177)

**Success Criteria**: New benchmarks with the DAE systems.

**Recommended Skills**: Prior knowledge in modeling with differential-algebaic equations
would be helpful for debugging.

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

# Successful Projects Archive

These are the previous SciML small grants projects which have successfully concluded and payed out.

## Refactor OrdinaryDiffEq.jl to use Sub-Packages of Solvers (\$600)

#### Note: Bounty increase to \$600 from \$300 (7/20/2024)

**In Progress**: Claimed by Param Umesh Thakkar for the time period of June 18th, 2024 - August 18th 2024. Extended due to scope and cost extension.

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

## DAE Problem Benchmarks (\$100 / Benchmark)

**In Progress**: Completed by Marko Polic in the time period of June 18th, 2024 - July 18th 2024.
The transistor amplifier benchmark was added [https://github.com/SciML/SciMLBenchmarks.jl/pull/1007](https://github.com/SciML/SciMLBenchmarks.jl/pull/1007).
Project is kept open for other benchmarks.
