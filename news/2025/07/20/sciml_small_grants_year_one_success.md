@def rss_pubdate = Date(2025,7,20)
@def rss = """SciML Small Grants Program: One Year of Success and Community Growth"""
@def published = " 20 July 2025 "
@def title = "SciML Small Grants Program: One Year of Success and Community Growth"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Small Grants Program: One Year of Success and Community Growth

After more than a year of operation, the [SciML Small Grants Program](https://sciml.ai/small_grants/) has proven to be a remarkable success in fostering open-source contributions while building a vibrant community of developers. Today, we're excited to share comprehensive statistics and highlights from our journey since launching the program in April 2024.

## Program Impact by the Numbers

Since its inception, the SciML Small Grants Program has achieved impressive milestones:

- **13 total projects initiated** across various SciML ecosystem components
- **8 successfully completed projects** with full payouts
- **5 currently active projects** in progress
- **~90% success rate** for claimed projects
- **$2,400-2,600 total paid out** to contributors
- **$800+ in active project value** currently being worked on

## Success Stories: Major Contributions

### Ecosystem Integration and Optimization Wrappers

Our optimization ecosystem has been significantly enhanced through several successful projects:

**SciPy and PyCMA Integration ($400 total)** - Completed by Aditya Pandey and Maximilian Pochapski, these projects brought Python's mature optimization libraries into the Julia ecosystem via Optimization.jl, providing users with battle-tested algorithms and enabling seamless migration paths.

**Symbolics.jl Enhancement ($300)** - Jash Ambaliya successfully integrated SymPy as a fallback backend for Symbolics.jl, dramatically expanding the symbolic computation capabilities available to users when native Julia implementations hit limitations.

### Performance and Infrastructure Improvements

**OrdinaryDiffEq.jl Refactoring ($600)** - The crown jewel of our completed projects, Param Umesh Thakkar's comprehensive refactoring of OrdinaryDiffEq.jl into sub-packages has transformed the user experience. As detailed in our [previous blog post](https://sciml.ai/news/2024/08/10/sciml_small_grants_successes/), this work reduced first-time-to-solution from 2.46 seconds to 0.56 seconds - a 4.4x improvement that makes Julia's differential equation solvers feel truly instant.

**SciMLOperators.jl Modernization ($500)** - Divyansh Goyal's breaking changes to SciMLOperators.jl resolved fundamental limitations in how lazy operators handle different defining vectors, preparing the package for its v1.0 release and enabling more sophisticated use cases throughout the ecosystem.

**Benchmark Infrastructure ($600-800 estimated)** - Param Umesh Thakkar and Marko Polic have contributed extensively to maintaining and expanding SciMLBenchmarks.jl, ensuring our performance tracking infrastructure remains current with the rapidly evolving Julia ecosystem.

## Unique Program Design

What sets the SciML Small Grants Program apart from traditional bounty programs is its focus on **community development over competition**. Key features include:

- **Declaration-first approach**: Contributors must declare interest and receive approval before starting work
- **Exclusive time periods**: Typically one month of protected development time to prevent "sniping"
- **Extension support**: Projects can request additional time when scope expands
- **Mentorship component**: Active engagement with reviewers throughout development

This design has resulted in remarkably low abandonment rates and high-quality contributions that integrate well with the existing ecosystem.

## Active Projects: Current Innovation

The program continues to drive important developments with five active projects:

- **PDE Benchmarking**: Arjit Seth is updating critical handwritten PDE benchmarks to modern linear solve syntax
- **Optimization Benchmarking**: Arnav Kapoor is integrating CUTEst.jl with Optimization.jl for comprehensive solver evaluation
- **DAE Problem Expansion**: Jayant Pranjal is adding more differential-algebraic equation benchmarks
- **Solver Refactoring**: Krish Gaur is working on tableau-based SDIRK solver implementations
- **Julia v1.12 Compatibility**: Maximilian Pochapski is updating LoopVectorization.jl for the latest Julia version

## Community Growth and Contributor Success

The program has successfully attracted both new and returning contributors:

- **Multiple successful contributors**: Maximilian Pochapski and Param Umesh Thakkar have each completed multiple projects
- **International participation**: Contributors represent diverse geographic and academic backgrounds
- **Skill development**: Several contributors have continued engagement with SciML beyond their grant projects
- **High completion rate**: Once a project is claimed and approved, the vast majority reach successful completion

## Looking Forward

As we enter the program's second year, we're planning to expand in several directions:

- **Increased project diversity**: More opportunities across different technical areas
- **Larger project support**: Some infrastructure improvements warrant higher bounties
- **Community feedback integration**: Regular reviews ensure the program serves both contributors and maintainers effectively

The success of the SciML Small Grants Program demonstrates that thoughtful incentive design can build sustainable open-source communities while delivering significant technical improvements. We're grateful to all our contributors who have helped make this vision a reality.

## Get Involved

Interested in contributing to the SciML ecosystem? Check out the current opportunities on the [SciML Small Grants page](https://sciml.ai/small_grants/) and join our vibrant community of scientific computing developers.

To support the program, you can [donate via NumFOCUS](https://numfocus.org/donate-to-sciml), and donations can be earmarked for specific projects with steering council approval.

---

*The SciML Small Grants Program is made possible through the generous support of NumFOCUS and our community donors. Special thanks to all our contributors who have made this program such a success.*