@def rss_pubdate = Date(2020,8,10)
@def rss = """ SciML Ecosystem Update: Neural PDEs, Lie Groups, and Stochastic Delay Differential Equations"""
@def published = " 10 August 2020 "
@def title = " SciML Ecosystem Update: Neural PDEs, Lie Groups, and Stochastic Delay Differential Equations"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: Neural PDEs, Lie Groups, and Stochastic Delay Differential Equations

NeuralPDE.jl
Lie Group Integrators
Stochastic Delay Differential Equations
Causal components in ModelingToolkit
Automated Ensemble Parallelism in DiffEqFlux
Major performance improvements to parallelized extrapolation methods
New surrogates: gradient-enhanced kriging

# Next Directions

The next directions are going to be highly tied to the directions that
we are going with the latest Google Summer of Code, so here are a few
things to look forward to:

- Higher efficiency low-storage Runge-Kutta methods with a demonstration
  of optimality in a large-scale climate model (!!!).
- Continued improvements to parallel and sparse automatic differentiation
