@def title = "SciML Symbolic-Numeric Computing Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Symbolic-Numeric Computing Projects – Google Summer of Code

## Automated Model Order Reduction

Model order reduction is a technique for automatically finding a small model which approximates
the large model but is computationally much cheaper. We plan to use the infrastructure built
by ModelingToolkit.jl to [implement a litany of methods](https://github.com/SciML/ModelingToolkit.jl/issues/58)
and find out the best way to accelerate differential equation solves.

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of model order reduction methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Automated symbolic manipulations of differential equation systems

Numerically solving a differential equation can be difficult, and thus it can be helpful for
users to simplify their model before handing it to the solver. Alas this takes time... so
let's automate it! [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) is
a project for automating the model transformation process. Various parts of the library are
still open, such as:

@@tight-list
- Support for DAEs, DDEs, and SDEs
- Pantelides algorithm for DAE index reduction
- Lamperti transforms
- Automatic construction of adjoint solutions
- Tearing in nonlinear solvers
- Solving distributed delay equations
@@

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of model transformation methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Yingbo Ma](https://github.com/YingboMa)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Symbolic chemistry and calculating reaction rate coefficients

Catalyst is a great tool to model chemical reactions, but often reaction rate coefficients
are usually suspect. There are well established methods to calculate what these coefficients
should be given the activation energy of a reaction. We want to automate part of this modeling,
allowing the user to provide atom-bond graphs and have coefficients determined for free.

@@tight-list
- Data structures to represent chemical species, compounds, ions, and isotopes
- Arrhenius equation calculation of reaction rate coefficients k(T)
- Automatically balancing reactions using above data structures
- Verifying conservation of energy for each Reaction in a ReactionSystem
@@

**Recommended Skills**: Strong understanding of chemistry and Julia open-source programming,
particularly [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

**Expected Results**: Define an interface for providing a Symbolics.jl object that contains relevant metadata for calculating activation energy and reaction rate coefficients using the Arrhenius equation.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Anand Jain](https://github.com/anandijain) and [Samuel Isaacson](https://github.com/isaacsas)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Medium depending on the chosen subtasks.

## Symbolic Analysis and Transformations of Chemical Reaction Networks

Catalyst.jl provides the ability to create symbolic models of chemical reaction networks, generate symbolic differential equation and stochastic process models from them, and offers some limited ability to analyze the symbolic chemical reaction networks. There are a variety of ways Catalyst.jl's core capabilities could be expanded, including adding

@@tight-list
- tooling for detecting and classifying steady-states and their equilibria for mass-action systems (i.e. polynomial ODE systems).
- tooling to infer from reaction network graph representations possible dynamic and equilibrium behaviors using chemical reaction network theory.
- methods to reduce the size of reaction networks via the elimination of conserved species.
- support for elimination of aliased species between different Catalyst model components to enable more modular composition of Catalyst-based models.
- new ModelingToolkit-based systems to represent τ-leaping and/or abstract master equation representations, along with translation layers to generate such systems from Catalyst reaction network models.
- new ModelingToolkit-based representations for hybrid systems mixing reactions across modeling scales (ODEs, SDEs, jump processes), along with translation layers to generate such systems from Catalyst reaction network models.
- the ability for Catalyst reactions to allow random variables or general parameters to encode reaction stoichiometry, with updates to ModelingToolkit and Symbolics to support the generation of corresponding ODE, SDE and jump process models.

**Recommended Skills**: Strong understanding of ODE models for chemical systems and Julia open-source programming,
particularly [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

**Expected Results**: Extend Catalyst with one or more of the preceding features, with corresponding ModelingToolkit updates, enabling users to build, analyze, and simulate Catalyst-derived models incorporating the new components.

**Mentors**: [Samuel Isaacson](https://github.com/isaacsas) and [Chris Rackauckas](https://github.com/ChrisRackauckas).

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

@@
