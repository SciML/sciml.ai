@def rss_pubdate = Date(2016, 12, 21)
@def rss = """ PDEs Update """
@def published = "21 December 2016"
@def title = "PDEs Update"
@def authors = """<a href="https://github.com/Chris Rackauckas">Chris Rackauckas</a>"""  


Tags since the last blog post:

- https://github.com/JuliaLang/METADATA.jl/pull/7396
- https://github.com/JuliaLang/METADATA.jl/pull/7415
- https://github.com/JuliaLang/METADATA.jl/pull/7417
- https://github.com/JuliaLang/METADATA.jl/pull/7418

The first three are all related to changes to the PDE libraries. Essentially,
FiniteElementDiffEq.jl was in the stone ages: it had an old API which did not
match the rest of DiffEq due to age, had some performance issues, and it
did not do well with dependency handling. This was all addressed.
FiniteElementDiffEq.jl was split to make DiffEqPDEBase.jl, a Base library
for holding all of the PDE components, separate from FiniteElementDiffEq.jl.

DiffEqPDEBase.jl is a developer library that lets us isolate the dependencies
of the PDE solvers, like DiffEqBase. Where it differs is that it offers the
common finite element tools (like meshing) and the types associated with
PDEs, so this way other dev libraries which need these tools (like DiffEqDevTools.jl)
do not require a solver (and thus all of the solver dependencies). This doesn't
have much of an actual change to users of DifferentialEquations.jl, but what
it does mean is that test dependencies are now much more isolated. Also, by
keeping the PDE setup separate from DiffEqBase, this will allow it to be
much more dynamic, where as DiffEqBase is made to be a very stable library
which just provides base functionality for ODEs/SDEs/DAEs/DDEs.

This new setup shows how one can add PDE libraries to the setup. The PDE
problems are defined in DiffEqPDEBase.jl. There's current a problem type
for specifying a Poisson equation, and one for a Heat equation. More types
of PDEs should be added, so please feel free to open a PR with new equation
types (even before we have solvers for them). Additionally, notice that the
`mesh` is held in the problem definition. This means that the `Problem` type
is a full computational specification of the problem to be solved, which allows
for it to properly dispatch to the correct libraries and solvers. The `mesh`
is parameteric, meaning that different `mesh`es can be specified and dispatched
on. For example, a `FDMMesh` could be made to hold finite difference meshes, and
then one could specify a finite difference heat problem by a change of mesh.
Solvers can then dispatch based on the type of the mesh. Conversions between
meshes can be done automatically to expand the reach of solvers (within reason).

FiniteElementDiffEq.jl then got a bit of an internal revamp. It got rid of a lot
of dynamic dispatching, allowed for the familiar `solve(prob,alg;kwargs...)`
form, and was just generally modernized / made to work well on v0.5 and v0.6.
However, the solvers are still "special-purpose". In the future, I will be
getting rid of the special purpose solvers, and instead write them as calls
to the ODE solver libraries, which will increase the performance given how
well optimized those libraries are.

Lastly, DiffEqParamEstim.jl got some updates which make it work in more cases.
Essentially, if the parameters went into a bad zone, the ODE solvers would diverge,
and this would cause an error. Now, this is treated as a parameter set with
very high (infinite) cost, and therefore the optimization routines will still
work naturally. The methods still have the limitation that they are made only
for local minimization schemes using a non-weighted loss function (local
nonlinear least squares), so they are still sensitive to initial conditions.
However, given this setup they should be easy to map over global optimization
schemes. Bindings for MathProgBase/JuMP are coming soon which will allow for this.

Next on the docket is the `integrator` interface. You'll see docs for this come
live very shortly. Essentially, you can control ODEs step by step, and callbacks/
event handling got a major boost in applicability. This may be the new strongest
part of the JuliaDiffEq. A separate post will handle this.
