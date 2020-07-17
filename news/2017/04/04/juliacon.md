@def rss_pubdate = Date(2017, 4, 4)
@def rss = """ DifferentialEquations.jl Workshop at JuliaCon 2017 """
@def published = "4 April 2017"
@def title = "DifferentialEquations.jl Workshop at JuliaCon 2017"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

[There will be a workshop on DifferentialEquations.jl at this year's JuliaCon!](https://juliacon.org/2017/talks.html)
The title is "The Unique Features and Performance of DifferentialEquations.jl".
The goal will be to teach new users how to solve a wide variety of differential
equations, and show how to achieve the best possible performance. I hope to lead
users through an example problem: start with ODEs and build a simple model. I
will show the tools for analyzing the solution to ODEs, show how to choose the
best solver for your problem, show how to use non-standard features like arbitrary
precision arithmetic. From there, we seamlessly flow into more in-depth
analysis and models. We will start estimating parameters of the ODEs, and then
make the models more realistic by adding delays, stochasticity (randomness), and
Gillespie models (discrete stochastic models related to differential equations),
and running stochastic Monte Carlo experiments in parallel (in a way that will
automatically parallelizes across multiple nodes of an HPC!).

I am planning on ending by showing off the most unique feature of DifferentialEquations.jl:
its comprehensive event handling. I want to show you how to build models which
incorporate discontinuous changes at pre-planned (or stochastic) timepoints,
apply events when specific condtions are met (bounce a ball when it hits the ground),
and use the integrator interface to have complete control over the system, doing
things like changing the size of the differential equation and dynamically
modifying the equations that are being solved.

The purpose of the workshop is to show you how this ecosystem doesn't "just" solve
differential equations, but instead show how you can use these tools as a core
simulation engine solving the models you encounter in your research. I hope that
excites you! See you at JuliaCon 2017.
