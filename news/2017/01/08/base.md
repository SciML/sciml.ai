@def rss_pubdate = Date(2017, 1, 8)
@def rss = """ base """
@def published = "8 January 2017"
@def title = "base"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


A new set of tags will be going through over the next week. I am working with Tony to make sure there is no breakage, and for the most part the API has not changed. What has changed is the API for events and callbacks, there is a PR in DiffEqDocs.jl for the new API. The translation to the new API should be really easy: it's almost the exact same thing but now a type-based API instead of a macro-based API (and will be cross-package). Also included is a new "integrator" interface which gives step-wise control over integration routines, starting with support from OrdinaryDiffEq.jl.

ParameterizedFunctions.jl will be able to generate a ParameterizedFunction from an arbitary user function f(t,u,p,du) for use in parameter estimation techniques (sensitivity analysis support is coming, for now you have to define the Jacobian either yourself or via defining the dispatch to use ForwardDiff etc.).

DelayDiffEq.jl is going to be registered which gives support for solving constant lag differential delay equations (which builds off of the OrdinaryDiffEq.jl solvers which don't have lazy interpolants, so BS3, Tsit5, DP8, etc. are all extended to this case) and, if I work hard over the next day or so, could include a more general lag function solver.

Also in this group of updates is the new CompositeAlgorithm in OrdinaryDiffEq.jl. You can compose as many algorithms as you want, and define switching behavior between them. You can use this to pair stiff and nonstiff solvers and use whatever heuristic your heart desires to perform the switching (or control it yourself stepwise via the integrator interface). I will be building some multimethods using this, but the whole API is open for anyone to work with. See the docs.

The 4th order Rosenbrock scheme `rodas` was added to ODEInterfaceDiffEq.jl, making this type of method available. I'll get around to updating the benchmarks for these changes when I can.

Lastly, lots of progress is being made on DiffEqOnline which will make some basic usage of DifferentialEquations.jl available through the web browser. It will be setup so that way you can save pages with differential equations in them, making it a good display and teaching tool. We will start with only having ODEs and SDEs, and soon after some FEM (stochastic) reaction-diffusion equations. The limitation on pushing it further is that it needs to use ParameterizedFunctions.jl for the syntax translation. If its parser is improved, delay equations could be supported as well. This sounds like a perfect Google Summer of Code project...
