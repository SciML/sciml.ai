@def rss_pubdate = Date(2025,4,28)
@def rss = """State of SciML 2025: Julia Equation Solvers and AI for Science"""
@def published = "4 April 2025"
@def title = "State of SciML 2025"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# State of SciML 2025

Video:

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/SZZ0lT8DVRo?si=LrcV0QT2kHSu_AdV" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
~~~

## Abstract

SciML is huge. If I say "I am using a SciML package", that could mean DifferentialEquations.jl, but it could also mean NonlinearSolve.jl, or ExponentialUtilities.jl, MuladdMacro.jl, or anything in the long tail. Yet it is treated, maintained, and documented as a cohesive whole. But in terms of maturity, that is definitely not the case. This talk will highlight and put firm grading on the maturity of different parts of the project, where pieces like the ODE solvers are highly mature while other aspects like GPU-based optimizers or high index DAEs have a medium level of maturity, while other promising and popular libraries such as MethodOfLines.jl have a lot Discourse discussion but are knowingly at an immature stage. Part of this talk is to paint in broad strokes a picture of the current state of the ecosystem to help the general user base better understand the current state of the project.

But I think another major point is really, what's next? Some pieces that are immature are the main focus of the current development, especially aspects like boundary value problems, complementary problems, and parallelism in nonlinear optimization. Other areas such as uncertainty quantification schemes have been progressing but comparatively lack the team activity in comparison to some of the other focus areas. We hope to outline the lay of the land but also provide some perspective on the driving forces behind this progression to both highlight our near future goals but also indicate the road blocks that potential contributors can use as a starting point for helping the project themselves.