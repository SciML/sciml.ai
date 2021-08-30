@def rss_pubdate = Date(2021,8,30)
@def rss = """SciML Receives Chan Zuckerberg Institute Funding: Spatial SSAs, Identifiability, and Compile Times"""
@def published = " 30 August 2021 "
@def title = "SciML Receives Chan Zuckerberg Institute Funding: Spatial SSAs, Identifiability, and Compile Times"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Receives Chan Zuckerberg Institute Funding: Spatial SSAs, Identifiability, and Compile Times

The NumFOCUS-sponsored SciML organization is pleased to announce that we have received a
[Chan Zuckerberg Initiative Essential Open Source Software for Science](https://chanzuckerberg.com/rfa/essential-open-source-software-for-science/)
grant as part of Cycle 4! As a leading organization developing the mathematical
techniques being used in [software for clinical pharmacology by top firms like Moderna](https://pumas.ai/),
[demonstrating 175x accelerations in preclinical analysis by firms like Pfizer](https://juliacomputing.com/case-studies/pfizer/),
and [an core part of the Heta language tools from InSysBio](https://hetalang.github.io/#/),
SciML and the Julia programming language have become a standard in the field of
pharmacology. This grant is to accelerate the open source development in ways
that improve the ecosystem for this essential industry.

As part of this grant, [Professor Samuel
Isaacson](http://math.bu.edu/people/isaacson/) and his lab will work to expand
SciML's biological and chemical modeling functionality to enable the study of
spatially distributed systems. University of Washington Ph.D. student Vasily
Ilin has already begun a first effort to add spatial stochastic simulation
tooling to DiffEqJump [as part of a
GSoC](https://vilin97.github.io/posts/post5/) with Dr. Isaacson. This grant will
contribute to SciML's ability to make a sustained, multiyear effort to advance
these starter pieces to a full-fledged spatial modeling ecosystem, enabling the
investigation of cell signaling and the internal effects of drugs on cellular
processes. As a part of the SciML ecosystem, it will focus on the scalability
and performance required to handle the largest models, along with making sure to
compose with the rest of the ecosystem.

Additionally, we are pleased to announce that as part of this work we will
be funding [Dr. Tim Holy](https://neuroscience.wustl.edu/people/timothy-holy-phd/)
to help improve the compile times for these essential packages. We have already
[started to investigate and solve some of the main compile time issues, bringing
the compile times of widely used tools from 22 to 3 seconds
](https://github.com/SciML/DifferentialEquations.jl/issues/786).
With Tim onboard, we plan to comb through a large portion of the Julia ecosystem
used throughout pharmaceutical modeling and simulation to improve the general
usability of the ecosystem. Additionally, we hope to document this work through
issues and workshops to make these changes replicable by other Julia package
organizations, with a goal of changing the general developer mindset to include
compile times as a priority.

Lastly, we plan to integrate tools for identifiability analysis directly into
the analytics workflows. This will accelerate the life of scientists by making
it quick and easy to answer questions like "are there multiple sets of parameters
which equally fit the model?". We have already begun to [integrate
StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl)
into the SciML ecosystem, and with this work we will improve the methods,
documentation, and tutorials so that structural and practical identifiability
can be easy as running just a few functions on a standard `ODESystem` and
`ODEProblem`.

We thank CZI for this opportunity and hope we can make a clear difference in
the productivity of pharmaceutical science.
