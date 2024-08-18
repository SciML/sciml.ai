@def rss_pubdate = Date(2024,8,25)
@def rss = """SciML Update: Symbolic Solvers, Direct Enzyme on ODEs, and More"""
@def published = " 25 August 2024 "
@def title = "SciML Update: Symbolic Solvers, Direct Enzyme on ODEs, and More"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Update: Symbolic Solvers, Direct Enzyme on ODEs, and More

In this SciML update we have plenty of new features to check out including new symbolic
solvers, direct Enzyme support on OrdinaryDiffEq.jl, and major loading improvements
across the ecosystem. Time for the fun details!

## Symbolic Solvers: Solve Systems of Equations Symbolically with Symbolics.jl

A long-time requested feature for Symbolics.jl has been to add symbolic solvers. This is
functionality to say give a system like `x^2 - y = 5, sin(y) + cos(x) = 2`, and let it
spit out a symbolic exact solution. Well with this release it's finally here! Thanks to a
Google Summer of Code project by Yassin ElBedwihy, the 
[core pull-request adding the symbolic solver](https://github.com/JuliaSymbolics/Symbolics.jl/pull/1192)
has finally landed. With this PR, you can do things like:

```julia
using Symbolics, Groebner
@variables x y z;
eqs = [x^2 + y + z - 1, x + y^2 + z - 1, x + y + z^2 - 1]
Symbolics.symbolic_solve(eqs, [x,y,z])
```

and get the symbolic solution to the set of polynomial equations. Want to know the answer
to the above? Well install it and find it!

It comes complete with extensions that make use of the [Nemo](https://github.com/Nemocas/Nemo.jl)
Computer Algebra System (CAS), which is an abstract algebra system developed by other smart
Julia developers that specializes in "abstract algebra" like computational group theory, 
computational ring theory, and more. It mixes some of these techniques in with rule-based
techniques to give a solver that is "best of both worlds" and is easily extendable with
other submodules. For Groebner basis calculations, it uses the 
[Groebner.jl](https://github.com/sumiya11/Groebner.jl) package which is 
[demonstrated to be one of the most efficient implementations](https://arxiv.org/abs/2304.06935)
and thus serves as a solid building block.

In more detail, The `symbolic_solve` function uses 4 hidden solvers in order to solve the 
user's input. Its base, `solve_univar`, uses analytic solutions up to polynomials of 
degree 4 and factoring as its method for solving univariate polynomials. The function's `solve_multipoly` uses GCD on the input polynomials then throws passes the result
to `solve_univar`. The function's `solve_multivar` uses Groebner basis and a separating 
form in order to create linear equations in the input variables and a single high degree 
equation in the separating variable. Each equation resulting from the basis is then passed
to `solve_univar`. We can see that essentially, `solve_univar` is the building block of
`symbolic_solve`. If the input is not a valid polynomial and can not be solved by the 
algorithm above, `symbolic_solve` passes it to `ia_solve`, which attempts solving by 
attraction and isolation. This only works when the input is a single expression
and the user wants the answer in terms of a single variable. Say `log(x) - a == 0` 
gives us `[e^a]`. This attraction isolation is then extendable via rules, so down the line
we can add extensions to handle cases like LambertW.jl and SpecialFunctions.jl detection.

Its current feature completeness can be summarized as:

- [x] Linear and polynomial equations
- [x] Systems of linear and polynomial equations
- [x] Some transcendental functions
- [x] Systems of linear equations with parameters (via `symbolic_linear_solve`)
- [ ] Systems of polynomial equations with parameters
- [ ] Inequalities
- [ ] Differential Equations (ODEs)
- [ ] Integrals

With plans to continue developing and handle the next cases soon after.

## Symbolics v6 / SymbolicUtils v3 / TermInterface v2: Core Interface Improvements

A major was released on the Symbolics stack this month, signifying a breaking change. The 
major breaking change here is the re-adoption of 
[TermInterface.jl](https://github.com/JuliaSymbolics/TermInterface.jl),
which is a core interface for symbolic terms. By having all symbolic libraries extend term
interface, be it Metatheory.jl, Symbolics.jl, SymPy.jl, and more, the core interface gives
a common specification for building and translating terms, making all of them interopable.
This means that by re-adopting TermInterface, we now have bidirectional translation to and
from SymPy as a well-maintained part of the interfaces, and moving between rule-based
approaches and E-graphs based approaches is a standard part of the interfaces.

At the same time that we tacked TermInterface v2, we also tackled some of the long-standing
problems in the Symbolics ecosystem. In particular, for a symbolic term like `ex = f(x,y)`, 
while `arguments(ex) == [x,y]`, if you build a symbolic expression of `ex = x + y + z` the 
internal data structures can be optimized by assuming no ordering in such a commutative
operation. However before we guarenteed argument order on `arguments(ex)`, so then
`arguments(ex) = [x,y,z]` was enforced to always be sorted lexicographically. However, it
turns out that after building out the symbolic stack that this choice is one of the most
costly in the entire ecosystem! Thus we have changed `arguments(ex)` to not guarantee a
sorting order, allowing symbolic manipulations which specialize on commutativity to skip
spending 99% of their time calculating lexicographic sorts. In order to allow for printing
in a stable manner, we created the new interface functions such as `sorted_arguments(ex)`
which guarantee a sorting and thus take the performance hit, and this is used so that
things like Latex outputs and displays are more stable.

Another major change was a breaking change to the `maketerm` syntax to remove the `symtype`
argument. While symbolic terms like those in Symbolics.jl can still be typed, i.e.
`@variables x::Complex` which changes their behavior in things like simplification rules,
this information is now captured in the metadata instead of the term itself. This unifies
more of the implementation between Symbolics.jl and Metatheory.jl to better allow usage
of E-graphs on symbolic terms. 

SymbolicUtils.jl v3 and Symboilcs v6 thus take these interface changes as their breaking
bits. Most code should actually not be broken by these changes, we only had to update the
code of approximately 10% of the upstream libraries to allow for this change, and many of
those only because we the symbolics developers are using some deeper features. So it's
generally a small break but we get some major performance improvements and nice new features
that unify the ecosystem.

We had a few major Symbolics.jl updates, with this year having Symbolics v4, v5, and now v6,
a few with SymbolicUtils, and new a few with TermInterface. We are happy to report that we
believe TermInterface.jl is now finally stable, so these updates should have reached their
conclusion. There is a common core change to SymbolicUtils.jl which should be a major
performance improvement by changing the structure of the BasicSymbolic, however we believe this
is likely to be non-breaking. Thus the 2023-2024 stream of majors on Symbolics seems to have
come to its end and Symbolics is now in more of a feature building phase.

## Direct ODE Support with Enzyme

There are two kinds of adjoints, one is the continuous adjoint approaches which define a new
ODE problem to solve, and another which uses automatic differentiation directly through the solver.
There are pros and cons of each, as described in 
[our recent review on differentiation of ODEs](https://arxiv.org/abs/2406.09699) in exquisite
detail. 

However, improving support for both is always on the menu. With discrete adjoints, AD support
directly through the solver has been supported by ForwardDiff, ReverseDiff, and Tracker since
almost the dawn of DifferentialEquations.jl. Limited support for Zygote through specific
solvers, such as those in SimpleDiffEq.jl, has also always existed as well. But Enzyme is a
much more powerful system. We have used it rather extensively in the continuous adjoint
infrastructure for almost half a decade now, but it always lacked the capability to directly
differentiate the complexity of the ODE solvers...

Until now. As part of the JuliaCon 2024 Hackathon, the remaining issues were worked through
and now the explicit methods in OrdinaryDiffEq.jl can be directly differentiated with
Enzyme. This can be seen by using the AD passthrough setting to avoid the SciMLSensitivity
adjoint catching as follows:

```julia
using Enzyme, OrdinaryDiffEq, StaticArrays

function lorenz!(du, u, p, t)
    du[1] = 10.0(u[2] - u[1])
    du[2] = u[1] * (28.0 - u[3]) - u[2]
    du[3] = u[1] * u[2] - (8 / 3) * u[3]
end

const _saveat =  SA[0.0,0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25,2.5,2.75,3.0]

function f(y::Array{Float64}, u0::Array{Float64})
    tspan = (0.0, 3.0)
    prob = ODEProblem{true, SciMLBase.FullSpecialize}(lorenz!, u0, tspan)
    sol = DiffEqBase.solve(prob, Tsit5(), saveat = _saveat, sensealg = DiffEqBase.SensitivityADPassThrough())
    y .= sol[1,:]
    return nothing
end;
u0 = [1.0; 0.0; 0.0]
d_u0 = zeros(3)
y  = zeros(13)
dy = zeros(13)

Enzyme.autodiff(Reverse, f,  Duplicated(y, dy), Duplicated(u0, d_u0));
```

This is a major leap forward in Enzyme support. SciMLSensitivity will soon update to include
a EnzymeAdjoint option which makes use of this direct differentiation mode with automation
of the process (such as unwrapping of function pointers for `SciMLBase.FullSpecialize`, so
more standard definitions work). There are still a few details to work through in order to
get compatability with all features, in particular 
[support for ranges is the leading issue](https://github.com/EnzymeAD/Enzyme.jl/issues/274),
but these are actively being worked on.

Support for implicit methods is currently lacking in this form because Enzyme is incompatible
with PreallocationTools.jl structures due to being unable to being able to prove the
lack of aliasing. Thus Enzyme adjoint sensitivity support for implicit methods will directly 
come with the OrdinaryDiffEq v7 changes to the `autodiff` API which is planning to change
from the lagacy ForwardDiff-based Jacobian interface to using DifferentiationInterface.jl
for the Jacobian specification, which would then allow for Enzyme-based Jacobians and
will work due to Enzyme-over-Enzyme support. This is expected over the next month as mentioned
at JuliaCon.

## SciMLSensitivity Adjoint Support for General SciMLStructures Types

For many years SciMLSensitivity.jl only supported AbstractArray parameter types for its
continuous adjoints because it required being able to solve differential equations
based on the object type. This was relaxed a bit with the introduction of `GaussAdjoint`
as the new standard adjoint method in 2023, but there were still limitations. Now thanks
to a [massive effort by Dhariya](https://github.com/SciML/SciMLSensitivity.jl/pull/1057),
this limitation has been lifted. Now any type which defines the
[SciMLStructures interface](https://docs.sciml.ai/SciMLStructures/stable/) for
tunable canonicalization can automatically be supported.

One major result of this is that the `MTKParameters` object from ModelingToolkit v9 is
supported, which means that general adjoint differentiation is now compatible with MTK
models. This includes compatability with the 
[SymbolicIndexingInterface](https://docs.sciml.ai/SymbolicIndexingInterface/stable/),
meaning that lazy observed quantities can be differented with respect to, allowing all
of the symbolic simplifications of MTK to be used within the context of AD.