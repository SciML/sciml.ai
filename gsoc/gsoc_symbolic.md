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

## Improved interfacing between ModelingToolkit.jl and GalacticOptim.jl

GalacticOptim.jl wraps multiple optimization packages local and global to provide a common interface.
GalacticOptim.jl adds a few high-level features, such as integrating with automatic differentiation, to make its usage fairly simple for most cases, while allowing all of the options in a single unified interface.
Currently ModelingToolkit.jl is provided as one of the AD backend options and can also be used to define the optimization problem symbolically directly. Thsi support is currently limited and doesn't cover things like constraints yet, but there is tremendous value to be gained by leveraging symbolic simplification possible with ModelingToolkit. This project would also cover integrating into MathOptInterface to by using the symbolic expressions generated from MTK, in addition to the current MOI wrapper available in GalacticOptim.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. Familiarity with the relevant packages, ModelingToolkit, GalacticOptim and MathOptInterface would be helpful to get started.

**Expected Results**: Feature complete symbolic optimization problem interface.

**Mentors**: [Vaibhav Dixit](https://github.com/Vaibhavdixit02), [Chris Rackauckas](https://github.com/ChrisRackauckas)

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

@@