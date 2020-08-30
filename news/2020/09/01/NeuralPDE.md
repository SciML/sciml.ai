@def rss_pubdate = Date(2020,8,17)
@def rss = """ SciML Ecosystem Update: """
@def published = " 17 August 2020 "
@def title = " SciML Ecosystem Update: "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update:

https://nextjournal.com/kirill_zubov/physics-informed-neural-networks-pinns-solver-on-julia-gsoc-2020-final-report
Augmented neural differential equations
https://github.com/SciML/Quadrature.jl
ReactionNetworkImporters and CellML on Catalyst

## DifferentialEquations.jl Solvers Micro Tested Against Boost C++ with VCL

We thank Daniel Nagy for this demonstration testing the speed of RK4 on very small
ODEs (Lorenz) against Boost C++ with and without VCL. Thank you Chris Elrod (@celrod)
for helping maximize our vectorization in these cases. We can now demonstrate
on CPUs that we are able to outperform Boost with VCL. Note that this simply
corresponds to the cost of solving asymptotically small ODEs and does not impact
most other usage, though a lot of users who do small ODE optimization will likely
be interested in the little bits of performance gains seen in our latest updates.
Improvements along these lines for ensemble GPU methods are coming soon.

[Boost VCL vs Julia DifferentialEquations.jl](https://user-images.githubusercontent.com/1814174/91665075-1af3e280-eac1-11ea-8fce-a0f311db05de.png)

# Next Directions

The next directions are going to be highly tied to the directions that
we are going with the latest Google Summer of Code, so here are a few
things to look forward to:

- Higher efficiency low-storage Runge-Kutta methods with a demonstration
  of optimality in a large-scale climate model (!!!).
- Continued improvements to parallel and sparse automatic differentiation.
- More performance
