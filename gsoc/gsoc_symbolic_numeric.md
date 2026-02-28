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

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

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

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Acausal Modeling Compiler Optimizations for ModelingToolkit.jl

[ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) is an acausal
modeling compiler that transforms high-level component-based physical models into
efficient numerical code. This project focuses on implementing new compiler
passes and optimizations that improve the robustness, performance, and
capabilities of the compilation pipeline. Possible subtasks include:

@@tight-list
- **Pryce's algorithm for DAE index reduction**: Implement [Pryce's structural analysis](https://link.springer.com/article/10.1023/A:1021998624799) as an alternative to the Pantelides algorithm, providing a different approach to determining the index of DAE systems and performing index reduction. See also [this analysis](https://inria.hal.science/hal-03104030v2/document) for a comparison of the two approaches.
- **Inline integration**: Implement [inline integration](https://people.inf.ethz.ch/fcellier/Pubs/OO/esm_95.pdf), a technique from the Modelica community where certain fast subsystems are integrated analytically during the compilation phase, allowing larger time steps in the numerical solver without loss of accuracy.
- **Automated detection of events from discontinuities**: Automatically detect discontinuities (e.g., `if` statements, `abs`, `min`, `max`) in ODE/DAE definitions and generate appropriate event (callback) functions, improving solver robustness for models with switching behavior.
- **Specialized nonlinear solvers based on strongly connected components**: After tearing, the remaining nonlinear systems can be decomposed into strongly connected components (SCCs). Implement specialized solution strategies that solve each SCC independently, reducing the size of the nonlinear systems and improving convergence.
- **Common subexpression elimination in symbolic code generation**: Improve the generated code by detecting and eliminating common subexpressions across the system equations, reducing redundant computation in the generated ODE/DAE right-hand side functions.
@@

These optimizations are motivated by the needs of industrial-scale acausal
models (e.g., hydraulic systems, HVAC, battery models) as taught in MIT's
[18.S191 ModelingToolkit course](https://github.com/SciML/ModelingToolkitCourse).

**Recommended Skills**: Background in compiler design or symbolic computation,
familiarity with differential-algebraic equations, and the ability (or eagerness
to learn) to write Julia code. Experience with ModelingToolkit.jl or Modelica is
helpful but not required.

**Expected Results**: Production-quality implementations of two or more compiler
optimizations as pull requests to ModelingToolkit.jl, with tests demonstrating
correct behavior on representative acausal models.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Aayush Sabharwal](https://github.com/AayushSabharwal)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Symbolic Transformations for Analysis and Uncertainty Quantification

ModelingToolkit.jl's symbolic representation of differential equation systems
opens the door to powerful automated transformations that go beyond basic model
simplification. This project focuses on implementing transformations that enable
new analysis capabilities:

@@tight-list
- **Symbolic generation of sensitivity analysis equations**: Automatically derive the [forward sensitivity equations](https://docs.sciml.ai/SciMLSensitivity/stable/manual/differential_equation_sensitivities/) directly from the symbolic IR, avoiding the overhead of numerical differentiation. This produces exact sensitivity systems that can be compiled alongside the original model. See [ModelingToolkit.jl issue #39](https://github.com/SciML/ModelingToolkit.jl/issues/39).
- **Polynomial chaos expansions for fast uncertainty quantification**: Implement symbolic generation of [polynomial chaos expansion](https://en.wikipedia.org/wiki/Polynomial_chaos) systems from a stochastic ODE/DAE model, transforming uncertain parameters into a deterministic system of equations for the expansion coefficients, enabling fast uncertainty propagation without Monte Carlo sampling.
- **Automated Laplace and Fourier transforms**: Implement symbolic Laplace and Fourier transforms operating on ModelingToolkit systems, enabling transfer function analysis, frequency-domain modeling, and automatic conversion between time-domain and frequency-domain representations of linear and linearized systems.
- **Automated function transformation of observables**: Implement automated variable transformations (e.g., log-transform states to enforce positivity, logit-transform for bounded variables) at the symbolic level, automatically deriving the transformed equations via the chain rule and maintaining correct observable mappings. See also the [Lamperti transformation for SDEs](https://github.com/SciML/ModelingToolkit.jl/issues/140).
@@

**Recommended Skills**: Background in differential equations and numerical
analysis. Some familiarity with sensitivity analysis, uncertainty quantification,
or transform methods is helpful. Ability to write Julia code.

**Expected Results**: Production-quality implementations of one or more symbolic
transformations in ModelingToolkit.jl, with documentation and tests on standard
models.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Aayush Sabharwal](https://github.com/AayushSabharwal)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Symbolic Code Generation and Domain-Specific Transformations

The symbolic representations built by Symbolics.jl and ModelingToolkit.jl can be
compiled into efficient code targeting different backends and application domains.
This project covers extending the code generation capabilities and adding
domain-specific symbolic transformations:

@@tight-list
- **Extendable C code generation from Symbolics.jl**: Extend the [Symbolics.jl code generation infrastructure](https://github.com/JuliaSymbolics/Symbolics.jl) with a plugin-based C code generation system, allowing users to register custom C implementations for domain-specific symbolic operations and generating standalone C code for deployment on embedded systems or integration with C/C++ simulation environments.
- **Disciplined convex programming (DCP) for OptimizationSystem**: Implement [DCP analysis](http://cvxr.com/cvx/doc/dcp.html) on ModelingToolkit's OptimizationSystem, automatically verifying convexity of optimization problems and transforming them into standard convex form for efficient solution by convex solvers like ECOS, SCS, or Clarabel.jl.
- **Direct-quadrature-zero (DQZ) transformation for multibody systems**: Implement the [DQZ transformation](https://en.wikipedia.org/wiki/Direct-quadrature-zero_transformation) as a symbolic pass in ModelingToolkit, automatically transforming three-phase electrical or mechanical systems into decoupled direct, quadrature, and zero components for more efficient simulation of multibody systems and robotics.
- **Automated conversion of distributed delay equations into ODEs**: Implement the [linear chain trick](https://link.springer.com/article/10.1007/s10928-018-9570-4) and related methods to symbolically convert distributed delay differential equations into equivalent expanded ODE systems that can be solved with standard ODE solvers. See [ModelingToolkit.jl issue #45](https://github.com/SciML/ModelingToolkit.jl/issues/45).
@@

**Recommended Skills**: Background in symbolic computation or code generation.
Domain knowledge in one of the application areas (control systems, optimization,
multibody dynamics) is helpful but not required. Ability to write Julia code.

**Expected Results**: Production-quality implementations of one or more code
generation or transformation features, with tests and documentation.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Aayush Sabharwal](https://github.com/AayushSabharwal)

**Expected Project Size**: 350 hour.

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

**Expected Project Size**: 350 hour.

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

**Expected Project Size**: 350 hour.

**Difficulty**: Easy to Hard depending on the chosen subtasks.
