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

## Improved interfacing between ModelingToolkit.jl and GalacticOptim.jl

GalacticOptim.jl wraps multiple optimization packages local and global to provide a common interface.
GalacticOptim.jl adds a few high-level features, such as integrating with automatic differentiation, to make its usage fairly simple for most cases, while allowing all of the options in a single unified interface.
Currently ModelingToolkit.jl is provided as one of the AD backend options and can also be used to define the optimization problem symbolically directly. Thsi support is currently limited and doesn't cover things like constraints yet, but there is tremendous value to be gained by leveraging symbolic simplification possible with ModelingToolkit. This project would also cover integrating into MathOptInterface to by using the symbolic expressions generated from MTK, in addition to the current MOI wrapper available in GalacticOptim.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. Familiarity with the relevant packages, ModelingToolkit, GalacticOptim and MathOptInterface would be helpful to get started.

**Expected Results**: Feature complete symbolic optimization problem interface.

**Mentors**: [Vaibhav Dixit](https://github.com/Vaibhavdixit02), [Chris Rackauckas](https://github.com/ChrisRackauckas)
