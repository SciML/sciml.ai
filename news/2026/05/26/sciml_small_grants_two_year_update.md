@def rss_pubdate = Date(2026,5,26)
@def rss = """SciML Small Grants Program: Two Years In, Eight More Projects Funded and Shipped"""
@def published = " 26 May 2026 "
@def title = "SciML Small Grants Program: Two Years In, Eight More Projects Funded and Shipped"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Small Grants Program: Two Years In, Eight More Projects Funded and Shipped

Last July we [recapped the first year](https://sciml.ai/news/2025/07/20/sciml_small_grants_year_one_success/) of the [SciML Small Grants Program](https://sciml.ai/small_grants/): 13 projects initiated, 8 completed, around \$2,400-2,600 in payouts. In the ten months since, eight more projects have closed out, several active grants have been claimed, and the project list itself has been refreshed with new high-priority work. This post walks through what's shipped, in the order the completion PRs landed in [sciml.ai](https://github.com/SciML/sciml.ai).

## Completed Grants Since July 2025

### Simple Handwritten PDEs as ODEs Benchmark Set (\$400) — Arjit Seth

[**PR #171**](https://github.com/SciML/sciml.ai/pull/171), merged August 2, 2025.

The "Simple Handwritten PDEs as ODEs" benchmark set had been bit-rotting since the 2022 linear solve syntax migration. Arjit took the project further than the original scope: not only did the benchmarks come back to life on the modern linear solve interface, the four PDE test problems were reformulated as more realistic benchmarks, both finite-difference and pseudospectral implementations were improved, and the new benchmarks were tested against many solvers. The bounty was bumped from the original amount to \$400 after discussion with the reviewers, reflecting the expanded scope.

### DAE Problem Benchmarks — NAND Gate (\$100) — Jayant Pranjal

[**PR #168**](https://github.com/SciML/sciml.ai/pull/168), merged August 4, 2025.

The DAE benchmark project is structured as \$100 per added benchmark, and stays open in the project list so multiple contributors can chip away at the [list of standard DAE problems](https://github.com/SciML/SciMLBenchmarks.jl/issues/359). Jayant added the NAND Gate problem ([SciMLBenchmarks.jl PR #1303](https://github.com/SciML/SciMLBenchmarks.jl/pull/1303)) in a combined claim-and-completion PR — the work was done before the formal request, so both happened in one merge.

### LoopVectorization.jl Julia v1.12 Compatibility (\$200) — Maximilian Pochapski

[**PR #185**](https://github.com/SciML/sciml.ai/pull/185), merged October 8, 2025.

Julia v1.12 made opaque pointer mode the default and changed Julia pointers to LLVM pointers instead of integers. That broke `llvmcall`s across the JuliaSIMD ecosystem. Maximilian (a repeat contributor — he also wrapped PyCMA last cycle) updated LoopVectorization.jl and VectorizationBase.jl so the ecosystem keeps working on v1.12 ([VectorizationBase.jl PR #121](https://github.com/JuliaSIMD/VectorizationBase.jl/pull/121), [LoopVectorization.jl PR #557](https://github.com/JuliaSIMD/LoopVectorization.jl/pull/557)). Funded by an earmarked donation from the JuliaLang project administered through the small grants program.

### EvoTrees.jl GPU Backend Training Performance (\$2,250) — Aditya Pandey

[**PR #189**](https://github.com/SciML/sciml.ai/pull/189), merged October 27, 2025.

The largest single grant in the program's history. EvoTrees.jl's CPU implementation is competitive with XGBoost, but the GPU backend lagged badly. Aditya's work ([EvoTrees.jl PR #299](https://github.com/Evovest/EvoTrees.jl/pull/299)) brought training time into the target range against XGBoost on the 1M and 10M observation benchmarks, with partial migration to [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl) so the path is open for AMD GPU support. The original bounty was \$2,000 with a \$500 KA.jl premium; the partial KA.jl migration earned an intermediate \$250 premium for \$2,250 total. This was also a second successful grant for Aditya, who completed the SciPy wrapper earlier in 2025.

### CurveFit.jl Enhancements (\$300) — Andreja Ristivojevic

[**PR #207**](https://github.com/SciML/sciml.ai/pull/207), merged January 6, 2026.

CurveFit.jl sits in an underserved part of the ecosystem — high-level curve fitting — and the existing alternatives (e.g. LsqFit.jl) lean on inefficient and unstable algorithms. CurveFit.jl's NonlinearSolve.jl foundation already fixed the numerical core; this grant filled in the feature gaps tracked in [issue #41](https://github.com/SciML/CurveFit.jl/issues/41). This was one of the projects added in the December 2025 high-priority refresh (see below) and was claimed and completed within a month.

### DataInterpolations.jl BSpline Derivatives Fix (\$100) — Utsav Ojha

[**PR #211**](https://github.com/SciML/sciml.ai/pull/211), merged January 26, 2026.

The BSplineInterpolation in DataInterpolations.jl had bugs in control point placement and derivative calculation. The fix ([DataInterpolations.jl PR #502](https://github.com/SciML/DataInterpolations.jl/pull/502)) mirrored the approach taken earlier in [DataInterpolationsND.jl](https://github.com/SciML/DataInterpolationsND.jl/pull/20) and re-enabled the derivative tests that had been disabled. Small bounty, but a real correctness fix in a heavily-used SciML package.

### DAE Problem Benchmarks — Eight More Systems (\$800) — Singh Harsh Rahulkumar

[**PR #227**](https://github.com/SciML/sciml.ai/pull/227), merged March 13, 2026.

The biggest single push on the open-ended DAE benchmarks project. Across eight SciMLBenchmarks PRs ([#1459](https://github.com/SciML/SciMLBenchmarks.jl/pull/1459), [#1461](https://github.com/SciML/SciMLBenchmarks.jl/pull/1461), [#1480](https://github.com/SciML/SciMLBenchmarks.jl/pull/1480), [#1481](https://github.com/SciML/SciMLBenchmarks.jl/pull/1481), [#1483](https://github.com/SciML/SciMLBenchmarks.jl/pull/1483), [#1484](https://github.com/SciML/SciMLBenchmarks.jl/pull/1484), [#1485](https://github.com/SciML/SciMLBenchmarks.jl/pull/1485), [#1486](https://github.com/SciML/SciMLBenchmarks.jl/pull/1486)), Singh added Slider-Crank, Two-Bit Adding Unit, Fekete, Water Tube, Charge Pump, Car Axis, Andrews' Squeezing Mechanism, and Wheelset — covering mass-matrix, residual DAE, and ModelingToolkit index-reduced formulations, each generating work-precision diagrams. This single project nearly doubled the DAE benchmark coverage in SciMLBenchmarks.

### NeuroTabModels.jl TabM Architecture + Enzyme Migration (\$1,800) — Aditya Pandey

[**PR #228**](https://github.com/SciML/sciml.ai/pull/228), merged March 21, 2026.

A larger architecture-and-AD-stack project: add the [TabM](https://arxiv.org/abs/2410.24210) architecture to NeuroTabModels.jl while migrating off Zygote.jl. The implementation actually went further than the original scope — instead of Flux+Enzyme, the migration landed on Lux.jl and Reactant.jl ([PR #25](https://github.com/Evovest/NeuroTabModels.jl/pull/25)), which fits the SciML stack better, with TabM and the numerical embeddings module added on top ([PR #29](https://github.com/Evovest/NeuroTabModels.jl/pull/29)). This is Aditya's third completed small grant.

## Program Changes

Two notable governance / project-list changes since the year-one post:

**Project list refresh ([PR #191](https://github.com/SciML/sciml.ai/pull/191) and [PR #192](https://github.com/SciML/sciml.ai/pull/192), December 2025).** Stale claims were removed and three new high-priority projects were added: GPU CI scripts for SciMLBenchmarks, fixing OrdinaryDiffEq's downgrade tests, and the CurveFit.jl enhancements (which was claimed and completed within five weeks of being posted). The justification in PR #192 is worth quoting:

> The GPU benchmarking queue is something we've wanted for at least 5 years. The demand for CurveFit.jl is high but I have been lacking in that space. The downgrade CI is a PITA. Maybe someone wants to just sit down and do it for a small reward.

**AI usage policy ([PR #214](https://github.com/SciML/sciml.ai/pull/214), February 2026).** A note was added to the [SciML Developer Programs page](https://sciml.ai/dev/) clarifying that AI usage is allowed but must be disclosed, with undisclosed usage being grounds for disqualification from future programs. The note also makes explicit that the projects on offer have already been attempted with state-of-the-art AI tooling, so a contributor relying on AI alone without expert guidance is unlikely to succeed.

## Currently Active Projects

Five projects are claimed and in flight as of this writing:

- **LoopVectorization.jl Apple ARM (\$200)** — Khushmagrawal ([claim PR #201](https://github.com/SciML/sciml.ai/pull/201)). The follow-up to Maximilian's v1.12 work: get all tests passing on M-series Macs.
- **SciMLBenchmarks GPU CI (\$300)** — divital-coder ([claim PR #196](https://github.com/SciML/sciml.ai/pull/196), [extended via PR #206](https://github.com/SciML/sciml.ai/pull/206) and [PR #215](https://github.com/SciML/sciml.ai/pull/215)). The long-standing GPU benchmarking queue project.
- **OrdinaryDiffEq Downgrade Tests (\$100)** — Param Thakkar ([claim PR #216](https://github.com/SciML/sciml.ai/pull/216)). Param's fourth grant — he previously completed both the OrdinaryDiffEq sub-package refactor and the SciMLBenchmarks compat bumps.
- **CUTEst.jl on the Optimization.jl Interface (\$200)** — Jash Ambaliya ([claim PR #208](https://github.com/SciML/sciml.ai/pull/208)). The CUTEst integration originally claimed by a different contributor in 2025 has been re-claimed by Jash, who previously completed the Symbolics ↔ SymPy backend work.
- **OrdinaryDiffEq Tableau Refactor — SDIRK set (\$100/set)** — Krish Gaur. Refactoring the SDIRK `perform_step!` implementations into a single tableau-based loop.

## Updated Totals

Adding the eight completed projects since July 2025:

- **\$400** PDE benchmarks (Seth)
- **\$100** NAND gate DAE (Pranjal)
- **\$200** LoopVectorization v1.12 (Pochapski)
- **\$2,250** EvoTrees.jl GPU (Pandey)
- **\$300** CurveFit.jl (Ristivojevic)
- **\$100** DataInterpolations BSpline (Ojha)
- **\$800** DAE benchmark suite (Rahulkumar)
- **\$1,800** NeuroTabModels.jl TabM (Pandey)

That's **\$5,950 in additional payouts over ten months**, bringing the running total to roughly **\$8,400-8,600** across the lifetime of the program. The completion mix has also shifted upward — last year's projects averaged in the \$200-600 range; the last ten months include two grants over \$1,800, reflecting the program's willingness to fund larger architecture-level work where the scope justifies it.

A few patterns worth noting:

- **Repeat contributors continue to dominate the high end.** Aditya Pandey (now three completed grants), Maximilian Pochapski (two), Param Thakkar (two completed and a third in progress), and Jash Ambaliya (one completed, second in progress) account for a large share of total payouts. The program's design of giving exclusive declared time periods, with extension support, evidently works for sustaining multi-grant contributor relationships.
- **Open-ended "per-benchmark" projects scale well.** The DAE benchmark project alone has now been worked by Marko Polic, Jayant Pranjal, and Singh Harsh Rahulkumar across multiple cycles, with Singh's eight-system push being the single largest contribution to SciMLBenchmarks from the program.
- **Scope expansions get rewarded.** The PDE benchmark bounty was bumped on completion. The EvoTrees.jl bounty was bumped for partial KA.jl work. The pattern of trusting contributors to push past the original spec and adjusting payment afterward has held up.

## Get Involved

The [current project list](https://sciml.ai/small_grants/) is live with five open projects. If you want to claim one, open a PR against [sciml.ai](https://github.com/SciML/sciml.ai) modifying `small_grants.md` per the [declaration instructions](https://sciml.ai/small_grants/#declaring_for_a_project).

To support the program financially, [donate via NumFOCUS](https://numfocus.org/donate-to-sciml) — donations can be earmarked for specific projects with steering council approval, which is how the LoopVectorization.jl Julia v1.12 work was funded.

---

*Thanks to all the contributors above, to the reviewers who shepherded these PRs through, and to NumFOCUS and the SciML donor community for keeping the program funded.*
