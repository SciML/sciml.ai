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
are given an exclusive time interval (defaulting to one month) to solve the issue.
Payout is done upon completion of the chosen project and acceptance by the steering
council.

All projects are expected to contribute the code to repositories in the SciML Github
organization. Code which is not contributed to the open source repositories will not
be considered in the approval evaluations.

## Declaring for a Project

To declare for a small grant program, open a pull request on the Github repo for
[https://github.com/SciML/sciml.ai](https://github.com/SciML/sciml.ai) in the
`small_grants.md` file with a declaration for the grant in the section of the
project of interest. For example:

> **In Progress**: Claimed by XXXXXX for the time period of (today) - (one month later).

In your pull request, please share:

* Full legal name
* CV
* Short bio / background about your experience in the topic
* Description of which project you're interested in

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
be working the same project independently, to reduce the occurrences of this phenomena we have
a policy that payouts will only occur for declared projects. This policy can be overridden on
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

## Getting Paid Out

After a successful project, a pull request to [https://github.com/SciML/sciml.ai](https://github.com/SciML/sciml.ai)
must be made that updates the Small Grants project page declaring the project as completed
by moving it to the completed section. This pull request then must be merged by the designated
reviewer. Once this is merged, the project is declared to be successfully completed unless
comments by the reviewer in the pull request suggest otherwise. Upon completion, open an
expense report at [https://opencollective.com/sciml/expenses/new](https://opencollective.com/sciml/expenses/new)
and follow the instructions to submit an expense. In the expense report,

We need a PDF invoice on file. Please submit an invoice using an invoice template (for example: https://create.microsoft.com/en-us/templates/invoices) that contains the following information:

* Current Date
* Unique Invoice Number
* Name and Contact Information
* Bill To Information (NumFOCUS)
* Project Name and Grant Information (if relevant)
* Period of Work Performed
* Itemized List of Work Performed
* Short description
* Hourly rate
* Total for Invoice
* Payment Terms (e.g., Net 30)

Lastly, in order to process payment, we the following should be added as a comment to the report filing:

* SWIFT/BIC#
* IFSC
* Account Number

A steering council member will review that the expense matches the approved grant and, if so, approve
the expense. This finalizes the process and the payment will be sent.

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
process and proper maintenance beyond the timeframe of the project. For this reason,
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



## Update LoopVectorization.jl to pass all tests on MacOS ARM Systems (\$200)

**In Progress**: Claimed by Khushmagrawal for the time period of January 02, 2026 - February 02, 2026.

[LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl) is a
central package for the performance of many Julia packages. Its internals make
use of many low-level features and manual SIMD that can make it require significant
maintenance to be optimized for new system architectures and versions of the compiler.

**Information to Get Started**:

LoopVectorization.jl was mainly developed having x64 Intel systems in mind and
available as testing platforms. Apple has launched the new Apple M series processors
using an ARM architecture some time ago. When updating the CI infrastructure of
LoopVectorization.jl to run tests on Apple ARM systems
(see <https://github.com/JuliaSIMD/LoopVectorization.jl/pull/563>),
several bugs were found. These test failures were marked in the PR, and the
issue <https://github.com/JuliaSIMD/LoopVectorization.jl/issues/564> has been
created.

The purpose of this project is to update LoopVectorization.jl and/or related packages
from the JuliaSIMD ecosystem so that all tests pass on all available platforms;
all broken/skipped tests (`@test_broken`, `@test_skip`) are changed backed to normal
tests (`@test`) that pass on all platforms.

Note that the funds for this project as given by earmarked donations to the JuliaLang project
which SciML will help administer through the small grants program.

**Success Criteria**: LoopVectorization.jl runs all tests on all platforms.

**Recommended Skills**: This requires some low-level knowledge of LoopVectorization.jl.

**Reviewers**: Chris Rackauckas and Oscar Smith


## Setup SciMLBenchmarks CI scripts to support GPU benchmarking (\$300)

The current SciMLBenchmarks only run on CPU. There are many cases we wish to benchmark on GPU. The goal of this project is to modify the CI scripts to support GPU benchmarking.


**In Progress**: Claimed by divital-coder for the time period of (06-12-2025) - (06-01=2026).

**Information to Get Started**: See the current scripts in https://github.com/SciML/SciMLBenchmarks.jl/tree/master/.buildkite

**Success Criteria**: Merged pull request which changes the SciMLBenchmarks CI scripts to have a GPU queue, and setting up one of the benchmarks with a GPU queue

**Recommended Skills**: Understanding of Devops tooling and CI scripts

**Reviewers**: Chris Rackauckas

## Fix OrdinaryDiffEq Downgrade tests (\$100)

The downgrade tests are a set of tests which ensure that the package can be downgraded to a previous version and still work. This is important for ensuring that the package is stable and can be used in production environments. However, these tests are currently failing in many repositories due to changes in the package dependencies or the package itself. For example, OrdinaryDiffEq and most of its sublibraries
currently fail the downgrade tests.

The purpose of this is to work through what is required for the minimum version bumping in order to ensure the downgrade tests pass on OrdinaryDiffEq and all of its sublibraries. This may require tracking down incorrect versions in dependencies as well.

**Information to Get Started**: See the test failures on master, i.e. https://github.com/SciML/OrdinaryDiffEq.jl/pull/2919 

**Success Criteria**: Merged pull request which fixes all of the downgrade tests in OrdinaryDiffEq and its sublibraries.

**Recommended Skills**: Knowledge of the Julia package system and how to use the `Pkg` standard library to downgrade packages.

**Reviewers**: Chris Rackauckas and Oscar Smith

## Fix `DataInterpolations` Bspline derivatives (\$100)

`DataInterpolations.jl` is a SciML repository for interpolating 1D data. It supports a wide number of interpolation types, as well as taking first and second derivatives of the interpolations. Specifically, the BSplineInterpoation has a few bugs with regards to where it puts the control points, and how it calculates derivatives.

**Information to Get Started**: See the issue https://github.com/SciML/DataInterpolations.jl/issues/419 describes the issue and a proposed solution. Specifically, this work will likely start by mirroring https://github.com/SciML/DataInterpolationsND.jl/pull/20 and re-enabling the derviative tests for BSpline interpolations.

**Success Criteria**: Merged pull request which fixes the numerical issues

**Recommended Skills**: Basic (undergrad-level) knowledge of calculus

**Reviewers**: Chris Rackauckas and Oscar Smith

In Progress: Claimed by ajatshatru01 for the time period of (23/12/2025) - (23/1/2026).

## Update CUTEst.jl to the Optimization.jl Interface and Add to SciMLBenchmarks (\$200)

[CUTEst.jl](https://github.com/JuliaSmoothOptimizers/CUTEst.jl)
is a repository of constrained and unconstrained nonlinear programming problems for testing
and comparing optimization algorithms. We would like to be able to repurpose this work for
improving Optimization.jl's performance and tracking the performance of optimizers. It would
be useful to the community if this set of benchmarks was updated to the modern SciML
interfaces and benchmarking tools so it can make use of the full set of methods in
Optimization.jl and drive further developments and recommendations to users.

This would likely turn into either contributions to CUTEst or wrappers to CUTEst (hosted in
SciML) which transform the NLPModels form into Optimization.jl, and a benchmarking
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
as well, that can be discussed with Chris in the PR review.

**Related Issues**: [https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177)

**Success Criteria**: New benchmarks with the DAE systems.

**Recommended Skills**: Prior knowledge in modeling with differential-algebraic equations
would be helpful for debugging.

**Reviewers**: Chris Rackauckas

## Refactor OrdinaryDiffEq.jl Solver Sets to Reuse perform_step! Implementations via Tableaus (\$100/solver set)

***In Progress:** Claimed for the SDIRK set by Krish Gaur for the time period of July 4th 2025 - August 4th, 2025*

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
because the nuances of the implementation are less likely to noticeably impact performance.

**Information to Get Started**: The OrdinaryDiffEq.jl solvers are all found in
[the Github repository](https://github.com/SciML/OrdinaryDiffEq.jl) and
the format of the package is documented in the
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

# Successful Projects Archive

These are the previous SciML small grants projects which have successfully concluded and paid out.

## CurveFit.jl Enhancements (\$300)

Completed by **Andreja Ristivojevic**

CurveFit.jl is a high-level package for fitting curves to data. It sits at a very important part of the
ecosystem which was traditionally missing, filled by packages like LsqFit.jl which used inefficient
and unstable algorithms. While CurveFit.jl's design on NonlinearSolve.jl has been a major improvement
to this space, giving accessibility to using the more sophisticated methods of the SciML solver
ecosystem, it still lacks some important features for users. The goal of this project is to add a few
of this missing features to be a feature-complete curve fitting library, built on the solid numerical
foundations of SciML.

**Information to Get Started**: This issue https://github.com/SciML/CurveFit.jl/issues/41 describes all of the current requirements

**Success Criteria**: Merged pull requests which solve all of the issues in 41.

**Recommended Skills**: Knowledge of Julia, numerical analysis, and a willness to learn some of the statistics API

**Reviewers**: Chris Rackauckas

## Update LoopVectorization to Support Changes in Julia v1.12 (\$200)

*Completed by Maximilian Pochapski Oct 8th, 2025*

[LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl) is a
central package for the performance of many Julia packages. Its internals make
use of many low-level features and manual SIMD that can make it require significant
maintenance to be optimized for new versions of the compiler.

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

**Recommended Skills**: This requires some low-level knowledge of LLVM IR and familiarity with `llvmcall`. The changes should be routine.

**Reviewers**: Chris Elrod

## DAE Problem Benchmarks (\$100 / Benchmark)

Completed by **Jayant Pranjal**

**Benchmarks added:** NAND Gate Problem benchmark

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
as well, that can be discussed with Chris in the PR review.

**Related Issues**: [https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2177)

**Success Criteria**: New benchmarks with the DAE systems.

**Recommended Skills**: Prior knowledge in modeling with differential-algebraic equations
would be helpful for debugging.

**Reviewers**: Chris Rackauckas

## Fix and Update the "Simple Handwritten PDEs as ODEs" Benchmark Set (\$400)

>Completed by Arjit Seth on August 1, 2025.

The "Simple Handwritten PDEs as ODEs" benchmarks have been failing for a while.
They need to be updated to the "new" linear solve syntax introduced in 2022.
When updated, these benchmarks should serve as a canonical development
point for PDE-specific methods, such as implicit-explicit (IMEX) and
exponential integrators.

**Information to Get Started**: The
[Contributing Section of the SciMLBenchmarks README](https://github.com/SciML/SciMLBenchmarks.jl?tab=readme-ov-file#contributing)
describes how to contribute to the benchmarks. The benchmark results are
generated using the benchmark server. Half of the benchmarks are set up
using hand-discretized finite difference stencils for the PDE, the other
half use ApproxFun.jl in order to do a pseudospectral discretization.
A direct pseudospectral discretization via manual FFTs and operator
construction would also be fine.

**Related Issues**: [https://github.com/SciML/SciMLBenchmarks.jl/issues/929](https://github.com/SciML/SciMLBenchmarks.jl/issues/929)

**Success Criteria**: Pull requests which [update the benchmarks in the
folder](https://github.com/SciML/SciMLBenchmarks.jl/tree/master/benchmarks/SimpleHandwrittenPDE)
to be successful with the current Julia and package version (v1.10) without
erroring, generating work-precision diagrams. In addition, these should be updated
to give a clearer definition of the PDE being solved, adding a LaTeX
description of the equations to the top of the file.

**Recommended Skills**: Basic (undergrad-level) knowledge of finite difference and pseudospectral
PDE discretizations.

**Reviewers**: Chris Rackauckas

## Wrap PyCMA into the Optimization.jl Interface (\$100)

*Completed by Maximilian Pochapski June 25th, 2025*

PyCMA is a very good global optimizer written in Python. It did very well in
early editions of the BlackboxOptimizationBenchmarking.jl tests (see for example
https://github.com/jonathanBieler/BlackBoxOptimizationBenchmarking.jl/tree/v0.1.0)
and thus it would be good to have available for users to call and for benchmarking new
global optimization algorithms against.  The goal of this project is to use PythonCall.jl 
to setup the wrapper subpackage OptimizationPyCMA.jl with the bells and whistles to make 
such benchmarking and usage straightforward and simple.

**Information to Get Started**: See the issue https://github.com/SciML/Optimization.jl/issues/918
which has links to starter code. PythonCall.jl is a well-documented library for calling Python
code from Julia and thus its documentation is a good starting point as well.

**Related Issues**: https://github.com/SciML/Optimization.jl/issues/918

**Success Criteria**: Merged pull request which adds a new OptimizationPyCMA.jl to 
the Optimization.jl repository.

**Recommended Skills**: Basic (undergrad-level) knowledge of calculus and Python

**Reviewers**: Chris Rackauckas

## Wrap `scipy.optimize` into the Optimization.jl Interface (\$300)

**Completed by Aditya Pandey on June 23rd, 2025**

`scipy.optimize` is a standard in Python with lots of different methods, both local
and global optimizers, that are well-tested and robust. Thus in order to improve
the benchmarking and development of native Julia solvers, it would be helpful to
have these algorithms more easily accessible on the standard optimization interface.
Additionally, it can help users who are transitioning projects to and from Julia
to have a direct way to call the previous code in order to double check the translation.
The goal of this project is to use PythonCall.jl to setup the wrapper subpackage
OptimizationSciPy.jl with the bells and whistles to make such benchmarking and usage
straightforward and simple.

**Information to Get Started**: See the issue https://github.com/SciML/Optimization.jl/issues/917
which has links to starter code. PythonCall.jl is a well-documented library for calling Python
code from Julia and thus its documentation is a good starting point as well.

**Related Issues**: https://github.com/SciML/Optimization.jl/issues/917

**Success Criteria**: Merged pull request which adds a new OptimizationSciPy.jl to 
the Optimization.jl repository.

**Recommended Skills**: Basic (undergrad-level) knowledge of calculus and Python

**Reviewers**: Chris Rackauckas

## Add SymPy.jl as an Alternative Backend for Symbolics.jl (\$300)

**Completed by Jash Ambaliya on June 20th, 2025.**

The Symbolics.jl symbolic solver covers a wide range of cases, but adding a fallback to SymPy's solver provides broader coverage with minimal effort. This project implemented a backend integration using SymPy.jl via automatic conversion between Symbolics and SymPy representations. It introduced helper functions for converting expressions, solving them using SymPy, and converting results back.

**Goals Achieved** :

- Documented and tested the Symbolics <-> SymPy roundtrip conversion.
- Implemented wrappers in `SymbolicsSymPyExt.jl` for the following SymPy-based operations:
  - `linear_solve`
  - `algebraic_solve`
  - `integrate`
  - `limit`
  - `simplify`

This enhancement expands Symbolics.jl’s solving capabilities by leveraging the mature SymPy backend when native solutions are insufficient.

**Information to Get Started** :

The project used the existing `symbolics_to_sympy` function and the SymPy exchange mechanism. Reference discussions included:

- [Symbolics.jl #1223](https://github.com/JuliaSymbolics/Symbolics.jl/issues/1223)
- [SymPyCore.jl #88](https://github.com/jverzani/SymPyCore.jl/pull/88)
- [Symbolics.jl #1551](https://github.com/JuliaSymbolics/Symbolics.jl/issues/1551)

**Success Criteria** : Pull requests adding the five requested functions to the [SymbolicsSymPyExt.jl](https://github.com/JuliaSymbolics/Symbolics.jl/blob/master/ext/SymbolicsSymPyExt.jl).

**Recommended Skills** : Basic (undergrad-level) knowledge of calculus, symbolic computation, and Python interop in Julia.

**Reviewers** : Chris Rackauckas

## Refactor OrdinaryDiffEq.jl to use Sub-Packages of Solvers (\$600)

#### Note: Bounty increase to \$600 from \$300 (7/20/2024)

**Completed by Param Umesh Thakkar for the time period of June 18th, 2024 - August 18th 2024. Extended due to scope and cost extension.**

It's no surprise to anyone to hear that DifferentialEquations.jl, in particular the
OrdinaryDiffEq.jl solver package, is very large and takes a long time to precompile.
However, this is because there are a lot of solvers in the package. The goal would
be to refactor this package so that sets of solvers are instead held in subpackages
that are only loaded on-demand. Since many of the solvers are only used in more
niche applications, this allows for them to be easily maintained in the same repo
while not imposing a loading cost on the more standard applications.

**Information to Get Started**: The OrdinaryDiffEq.jl solvers are all found in
[the Github repository](https://github.com/SciML/OrdinaryDiffEq.jl) and
the format of the package is documented in the
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

**Completed by Marko Polic in the time period of June 18th, 2024 - July 18th 2024.**
The transistor amplifier benchmark was added [https://github.com/SciML/SciMLBenchmarks.jl/pull/1007](https://github.com/SciML/SciMLBenchmarks.jl/pull/1007).
Project is kept open for other benchmarks.

## SciMLBenchmarks Compatibility Bump for Benchmark Sets (\$100 each set)

**Completed by Param Umesh Thakkar for the time period of January 21st - February 21st. Extended from February 21st to March 21st. Extended due to the project's complexity and final refinements.**

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

**Recommended Skills**: Willingness to roll up some sleeves and figure out what changed in breaking updates.

**Reviewers**: Chris Rackauckas

## Update SciMLOperators.jl to allow for different defining vectors from actions (\$500)

**Completed by Divyansh Goyal on May 17th, 2025.**

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

## Improve training performance of GPU backend in EvoTrees.jl (\$2000)

#### Note: Bounty was decided to be \$2250 due to partial KA.jl work

**Completed by Aditya Pandey on October 25th, 2025.**
(Extended from September 1,2025 due to integration of work with main branch and adding features)

EvoTrees.jl[https://github.com/Evovest/EvoTrees.jl] is an efficient pure-Julia 
implementation of boosted trees. Performance on CPU is competitive and even superior to 
peers such as XGBoost. However, the GPU backend is lagging.

The objective of this project is to improve the GPU backend to bring the training benchmarks to 
in a competitive range to XGBoost. A premium of \$500 will be awarded if the solution is implemented 
with [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl), allowing the support for AMD gpus.

**Information to Get Started**: A key bottleneck is assumed to be the important overhead 
from the large number of kernels launched as the depth of the tree grows. Also, only the gradients
and histograms are computed on the GPU, while gains and best node split could also be computed on the GPU
and reduce the GPU to CPU communications. Potential solution paths and preliminary work initiative is
discussed in this [issue](https://github.com/Evovest/EvoTrees.jl/issues/288).

**Success Criteria**: A PR is merged to EvoTrees.jl which brings the benchmarked GPU training time to 
less than 125% that of XGBoost for the 1M and 10M observations benchmarks as discussed in the core 
[issue](https://github.com/Evovest/EvoTrees.jl/issues/288).

It should be reproducible on either a 3090, 4090 or a RTX A4000.
The solution should be purely Julia based, and not result in a significant increase in code complexity / LoCs.

**Recommended Skills**: Experience in kernel development on GPU, preferably with CUDA.jl or [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl).
General performance optimization and multi-threading.

**Reviewers**: [Jeremie Desgagne-Bouchard](https://github.com/jeremiedb)

