@def title = "SciML Numerical Differential Equations Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Scientific Machine Learning Projects – Google Summer of Code

## Modelingtoolkit based Parser for Physics Informed Neural Networks (PINNs)

[NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl) uses [ModelingTookit.jl](https://github.com/SciML/ModelingToolkit.jl) to define differential equations for solving PINNs. Currently, the loss functions for PINNs are constructed manually, which limits their applicability to a specific subset of systems. By utilizing ModelingToolkit.jl, loss functions could be generated symbolically, enabling broader generalization across diverse systems and improving flexibility. To achieve this, parsing the equations symbolically is essential.

**Recommended Skills**: Background knowledge in symbolics and machine learning.

**Expected Results**: New Parser for lowering from Modelingtoolkit systems to loss functions.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Sathvik Bhagavan](https://github.com/sathvikbhagavan)

## Improvements to Physics-Informed Neural networks (PINN) for solving differential equations

Neural networks can be used as a method for efficiently solving difficult partial differential equations.
Efficient implementations of physics-informed machine learning from recent papers are being explored as
part of the [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl) package.
The [issue tracker](https://github.com/SciML/NeuralPDE.jl/issues) contains links to papers which
would be interesting new neural network based methods to implement and benchmark against classical techniques.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New neural network based solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Sathvik Bhagavan](https://github.com/sathvikbhagavan)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

## Improvements to Neural and Universal Differential Equations

[Neural ordinary differential equations](https://arxiv.org/abs/1806.07366) have
been shown to be a way to use machine learning to learn differential equation
models. Further improvements to the methodology, like
[universal differential equations](https://arxiv.org/abs/2001.04385) have incorporated
physical and biological knowledge into the system in order to make it a data and
compute efficient learning method. However, there are many computational aspects
left to explore. The purpose of this project is to enhance the universal
differential equation approximation abilities of [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl),
adding features like:

- Improved adjoints for DAEs and SDEs
- [Non-neural network universal approximators](https://github.com/SciML/DiffEqFlux.jl/issues/173)
- Various [improvements to](https://github.com/SciML/DiffEqFlux.jl/issues/133) [minibatching](https://github.com/SciML/DiffEqFlux.jl/issues/118)
- Support for [second order ODEs (i.e. symplectic integrators)](https://github.com/SciML/DiffEqFlux.jl/issues/48)
- [Continuous normalizing flows](https://github.com/SciML/DiffEqFlux.jl/issues/46) and [FFJORD](https://github.com/SciML/DiffEqFlux.jl/issues/47)

See the [DiffEqFlux.jl issue tracker](https://github.com/SciML/DiffEqFlux.jl/issues)
for full details.

This project is good for both software engineers interested in the field of
scientific machine learning and those students who are interested in perusing
graduate research in the field.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New and improved methods for neural and universal
differential equations.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Anas Abdelrehim](https://github.com/AnasAbdelR)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Accelerating optimization via machine learning with surrogate models: Surrogates.jl

In many cases, when attempting to optimize a function `f(p)` each calculation
of `f` is very expensive. For example, evaluating `f` may require solving a
PDE or other applications of complex linear algebra. Thus, instead of always
directly evaluating `f`, one can develop a surrogate model `g` which is
approximately `f` by training on previous data collected from `f` evaluations.
This technique of using a trained surrogate in place of the real function
is called surrogate optimization and mixes techniques from machine learning
to accelerate optimization.

The purpose of this project is to further improve Surrogates.jl by: adding new surrogate models, adding new optimization techniques, showcasing compatibility with the SciML ecosystem and fixing unwanted behaviour with some current surrogate models. The [issue tracker](https://github.com/SciML/Surrogates.jl/issues) contains list of new surrogate models which can be added.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. Strong knowledge of numerical analysis
is helpful but not required.

**Expected Results**: Improving Surrogates.jl with new surrogate models and new optimization techniques.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Sathvik Bhagavan](https://github.com/sathvikbhagavan)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Tools for global sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the effect that parameters
have on a differential equation model. A good introduction [can be found in this thesis](https://discovery.ucl.ac.uk/id/eprint/19896/). Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense.
The goal of this project would be to implement more global
sensitivity analysis methods like the eFAST method into [GlobalSensitivity.jl](https://github.com/SciML/GlobalSensitivity.jl) which
can be used with any differential equation solver on the common interface.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global sensitivity
analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Vaibhav Dixit](https://github.com/Vaibhavdixit02)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Medium depending on the chosen subtasks.

## ODE-Based Reservoir Models in ReservoirComputing.jl

[ReservoirComputing.jl](https://github.com/SciML/ReservoirComputing.jl) currently targets discrete-time reservoir models such as Echo State Networks and Next Generation Reservoir Computing. The aim of this project would be to add a ContinuousReservoirComputer model: a continuous-time general approach for reservoir computing models, where the hidden state evolves via an ODE. This extension would enable to then extend ReservoirComputing.jl adding models like Liquid State Machines.

**Recommended Skills**: Background knowledge in numerical analysis and some basics of reservoir computing.

**Expected Results**: New ContinuousReservoirComputer model integrated into ReservoirComputing.jl. Additional time-continuous models that build on the new APIs.

**Mentors**: [Francesco Martinuzzi](https://github.com/MartinuzziFrancesco), [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 175 hour (core model + docs/tests), 350 hour if adding stretch items (additional models).

**Difficulty**: Medium
