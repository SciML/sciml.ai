@def title = "SciML Symbolic-Numeric Computing Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Symbolic-Numeric Computing Projects – Google Summer of Code

## Parameter identifiability analysis

Parameter identifiability analysis is an analysis that describes whether the
parameters of a dynamical system can be identified from data or whether they
are redundant. There are two forms of identifiability analysis: structural
and practical. Structural identifiability analysis relates changes in the
solution of the ODE directly to other parameters, showcasing that it is
impossible to distinguish between parameter A being higher and parameter B
being lower, or the vice versa situation, given only data about the solution
because of how the two interact. This could be done directly on the symbolic
form of the equation as part of
[ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).
Meanwhile, practical identifiability analysis looks as to whether the parameters
are non-identifiable in a practical sense, for example if two parameters are
numerically indistinguishable (given possibly noisy data). In this case, numerical
techniques being built in DiffEqSensitivity.jl, such as a
[nonlinear likelihood profiler](https://github.com/SciML/DiffEqSensitivity.jl/issues/109)
or an
[information sensitivity measure](https://github.com/SciML/DiffEqSensitivity.jl/issues/108)
can be used to showcase whether a parameter has a unique enough effect to be determined.

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of parameter identifiability
methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 350 hour.

**Difficulty**: Hard.

## Model Order Reduction

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

## Symbolic Analysis and Transformations of Chemical Reaction Networks

Catalyst.jl provides the ability to create symbolic models of chemical reaction networks, generate symbolic differential equation and stochastic process models from them, and offers some functionality to analyze symbolic chemical reaction networks. There are a variety of ways Catalyst.jl's core capabilities could be expanded, including adding

@@tight-list
- additional tooling to infer from reaction network graph representations possible dynamic and equilibrium behaviors using chemical reaction network theory.
- support for elimination of aliased species between different Catalyst model components to enable more modular composition of Catalyst-based models.
- adding more τ-leaping solvers in StochasticDiffEq, and corresponding symbolic interfaces in ModelingToolkit and Catalyst.
- expanding FiniteStateProjection.jl chemical master equation solvers, along with symbolic representations in ModelingToolkit and Catalyst.
- hybrid models mixing reactions across modeling scales (ODEs, SDEs, τ-leaping, jump processes), along with translation layers to generate such systems from Catalyst reaction network models.
    - methods for dynamically moving species/reactions between these scales during a simulation.
- network-free modeling capabilities and associated JumpProcess.jl solvers.

**Recommended Skills**: Strong understanding of ODE models for chemical systems and Julia open-source programming,
particularly [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) and [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

**Expected Results**: Extend Catalyst with one or more of the preceding features, with corresponding ModelingToolkit updates, enabling users to build, analyze, and simulate Catalyst-derived models incorporating the new components.

**Mentors**: [Samuel Isaacson](https://github.com/isaacsas) and [Chris Rackauckas](https://github.com/ChrisRackauckas).

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

@@
