@def rss_pubdate = Date(2021,8,26)
@def rss = """SciML Common Interface Expansion"""
@def published = " 26 August 2021 "
@def title = "SciML Common Interface Expansion"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: Expansion of the Common Interface

JuliaCon showcased a many SciML users demonstrating how they were using the
libraries for automated discovery of physical parameters from videos, for
simulation of single-cell biology, and more. However, we continue to extend our
interfaces and thus help these scientists grow into new domains. In this ecosystem
update there was a lot of focus on expanding the SciML Common Interface, making
the "one stop shop" interfaces seen in DifferentialEquations.jl expand to domains
such as nonlinear solvers and optimization. This all now has a specification
and documentation at a high level, and over the next few releases we will be
working to ensure that the full common interface covers all of the relevant
solvers in an automatic differentiation compatible manner.

Let's dive in.

## NonlinearSolve.jl: Common Interface for Nonlinear Solving

[NonlinearSolve.jl](https://github.com/SciML/NonlinearSolve.jl) is the package
for the common interface over nonlinear rootfinding, i.e. `f(x)=0` problems and
solvers. It now has a documentation which shows how to use NLsolve.jl, MINPACK,
Sundials, and other NonlinearSolve.jl unique methods for solving such equations
in a high performance manner. This interface is fitted with the
[adjoint sensitivities of a nonlinear solve](https://math.mit.edu/~stevenj/18.336/adjoint.pdf), which is able to compute the derivatives without differentiating
through the iterations of the solving method. This library has integrations
with ModelingToolkit.jl, so `NonlinearSystem`s can generate `NonlinearProblem`s
which are then solved via the common interface provided here. And similar to
the other interfaces like DifferentialEquations.jl, it's type-dependent, allowing
the user to compose the with all of the functionality of the Julia ecosystem.

For a test of the flexibility, here's a high-performance small linear solve
which uses StaticArrays to improve the performance:

```julia
using NonlinearSolve, StaticArrays

f(u,p) = u .* u .- p
u0 = @SVector[1.0, 1.0]
p = 2.0
probN = NonlinearProblem{false}(f, u0, p)
solver = solve(probN, NewtonRaphson(), tol = 1e-9)
```

## SciML Common Interface Documentation

With the common interface covering so many domains, we have put together a
[SciML Common Interface Documentation](https://scimlbase.sciml.ai/dev/) which
outlines the core tenants of the SciML common interfaces, how they interact,
what packages are associated as the user-facing front to the interfaces, and more.
We plan to use this to ensure that the interfaces for optimization, quadrature,
ODE solving, nonlinear solving, etc. all look and feel the same, with the same
integration with automatic differentiation and similar naming schemes to all
of the shared arguments. By doing so, we hope this will further lower the
barrier to entry for new Julia users interested in technical computing.

## SBMLToolkit.jl: Read SBML Models to ModelingToolkit

SBML files are commonly used throughout systems biology and systems pharmacology
for allowing exchange of ODE models. In this ecosystem release we showcase
SBMLToolkit.jl as the tool which integrates the SciML ecosystem with this world
of model exchange, allowing users to easily import models from SBML sources like
[the SBML Biomodels Repository](https://www.ebi.ac.uk/biomodels/) and SimBiology.
For more details on this topic, see the JuliaCon 2021 video
[Systems Biology in ModelingToolkit](https://www.youtube.com/watch?v=DL0Xw7ETZsE).

## `sciml_train` and Adjoint Heuristics

DiffEqFlux.jl and DiffEqSensitivity.jl now include a load of heuristics for
automatically choosing optimal adjoint methods for the derivative calculation.
Thus we now recommend that users do not generally choose the sensealg, i.e.
choices like `solve(prob,Tsit5(),sensealg=QuadratureAdjoint(autojacvec=ReverseDiffVJP(true)))`
since in many cases the automatic selection algorithm will be able to outperform
the user, in which case `solve(prob,Tsit5())` should now be a lot faster! This
will intelligently switch between forward and reverse mode, choose vector-Jacobian
product techniques most applicable to the code, and use compiler-based analyses
to enable extra optimizations. We hope most users notice improved performance
without having to do anything!

## Array Symbolics

One of the major problems in ModelingToolkit.jl was the scaling of symbolic
analyses. If every variable had to be explicitly represented, then it requires
O(n) memory and O(n) compute to handle analyses, code generation, and more.
Array symbolics allows for representing arrays as a single symbol in an alternative
algebra (i.e. no commutativity in general matrices). Now `@variables x[1:10000000]`
runs in O(1) time, and actions like `sum(x)` are represented lazily and transform
into looping code. Array symbolics still needs more work to be fully functional,
but users can see a lot of wins even at this stage.

Note that if user code is upgrading, scalaring the symbolic array can be done
by iterating the indexing into an array, i.e. `collect(x)` will act like the
previous representation using a standard Julia `Array` filled with symbolic
values.

## Forward and adjoint shadow sensitivities

The DiffEqSensitivity.jl derivative overloads are now able to handle chaotic
dynamical systems via forward and adjoint sensitivity analysis methods. For
more information on these techniques, see [Frank's blog post on their development](https://frankschae.github.io/post/shadowing/).

## Accumulation points in events

The event handling detection in the DiffEq solvers has improved enough to now
be able to have handling of accumulation points. The
[new tutorial](https://diffeq.sciml.ai/dev/features/callback_functions/#Handling-Accumulation-Points)
shows how to make approximately infinitely many events be handled with ease!

![](https://user-images.githubusercontent.com/1814174/122675006-89677580-d1a5-11eb-9ba2-fd83c14dbb3e.png)

## Enzyme Integration in DiffEqFlux.jl/DiffEqSensitivity.jl

The sensitivity analysis methods can now make use of the
[Enzyme.jl](https://github.com/wsmoses/Enzyme.jl) automatic differentiation
package in its vector-Jacobian product calculations. Importantly, this library
able to efficiently handle mutating code, making some of the most common
high-performance coding styles for large-scale ODEs and PDEs be something that
now has high-performance adjoints without modifications to the original code!
Turning this on is done simply by the `autojacvec=EnzymeVJP()` option, though
as noted above an automated heuristic will be able to detect Enzyme compatibility
and automatically use the `EnzymeVJP` when applicable.

## IPOPT MOI Integration into GalacticOptim.jl

GalacticOptim.jl now interfaces with
[MathOptInterface.jl](https://github.com/jump-dev/MathOptInterface.jl), the solver
backend behind the JuMP libraries. This means that many new solvers, such as
[IPOPT](https://github.com/jump-dev/Ipopt.jl), can now be used from the same
interface that is commonly used for applications like neural ODEs. 
