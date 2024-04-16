@def rss_pubdate = Date(2024,4,16)
@def rss = """NumFOCUS small development grant: Collocation Methods for Boundary Value Differential-Algebraic Equations"""
@def published = " 16 April 2024 "
@def title = "NumFOCUS small development grant: Collocation Methods for Boundary Value Differential-Algebraic Equations"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a> and <a href="https://github.com/ErikQQY">Qingyu Qu</a>"""

# NumFOCUS small development grant: Collocation Methods for Boundary Value Differential-Algebraic Equations

The SciML organization is pleased to announce that we have received a [small development grant](https://numfocus.org/programs/small-development-grants) from [NumFOCUS](https://numfocus.org/) to integrate Collocation Methods for Boundary Value Differential-Algebraic Equations to DifferentialEquations.jl.

At present, for boundary value problems, there are Mono-Implicit Runge-Kutta(MIRK) methods and Shooting methods for first-order BVPs, MIRKN methods for second-order BVPs in [BoundaryValueDiffEq.jl](https://github.com/SciML/BoundaryValueDiffEq.jl). While these solvers can cover many common boundary value problems and outperform some famous BVP solvers such as BVPSOL, BVP_SOLVER and COLNEW in [benchmarks](https://docs.sciml.ai/SciMLBenchmarksOutput/stable/), it is still not adequate for some complex scenarios involving differential-algebraic equations. Though SciML offers [powerful solvers](https://docs.sciml.ai/DiffEqDocs/stable/tutorials/dae_example/) for systems of DAEs solving, there are no robust solvers for boundary value DAEs even in well-built tools like MATLAB or Mathematica. With this grant, SciML will deliver powerful BVDAE solvers to address the current problems and provide a more comprehensive solution for complex numerical simulations. 

The grant would have two important deliverables:

1. Efficient boundary value differential-algebraic equations solvers for nonlinear systems of semi-explicit DAEs of index at most 2.
2. Thorough benchmarks and documentation, demonstrate the performance and robustness of the new solvers.

The person being funded is [Qingyu Qu](https://github.com/ErikQQY), an active contributor to SciML with a focus on numerical methods for differential equations and machine learning.

Qingyu will be working on a part-time basis throughout the upcoming year and will present an update at JuliaCon 2024.
