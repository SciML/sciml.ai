@def title = "SciML Numerical Differential Equations Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Scientific Machine Learning Projects – Google Summer of Code

## Physics-Informed Neural Networks (PINNs) and Solving Differential Equations with Deep Learning

Neural networks can be used as a method for efficiently solving difficult partial
differential equations. Recently this strategy has been dubbed [physics-informed neural networks](https://www.sciencedirect.com/science/article/pii/S0021999118307125)
and has seen a resurgence because of its efficiency advantages over classical
deep learning. Efficient implementations from recent papers are being
explored as part of the [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl)
package. The [issue tracker](https://github.com/SciML/NeuralNetDiffEq.jl/issues)
contains links to papers which would be interesting new neural network based methods to
implement and benchmark against classical techniques. Project work in this area
includes:

- [Improved training strategies](https://github.com/SciML/NeuralNetDiffEq.jl/issues/71) for PINNs.
- Implementing new neural architectures that impose physical constraints like [divergence-free criteria](https://arxiv.org/pdf/2002.00021.pdf).
- Demonstrating large-scale problems solved by PINN training.
- Improving the speed and parallelization of PINN training routines.

This project is good for both software engineers interested in the field of
scientific machine learning and those students who are interested in perusing
graduate research in the field.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New neural network based solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Kirill Zubov](https://github.com/KirillZubov)

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

Advanced techniques [utilize radial basis functions](https://www.cambridge.org/core/journals/acta-numerica/article/kernel-techniques-from-machine-learning-to-meshless-methods/00686923110F799A1537C4F02BBAAE8E) and Gaussian
processes in order to interpolate to new parameters to estimate `f` in areas
which have not been sampled. [Adaptive training techniques](http%3A%2F%2Fwww.ressources-actuarielles.net%2FEXT%2FISFA%2F1226.nsf%2F9c8e3fd4d8874d60c1257052003eced6%2Fe7dc33e4da12c5a9c12576d8002e442b%2F%24FILE%2FJones01.pdf) explore how to pick new areas to evaluate `f` to better hone in on global optima.

The purpose of this project is to further improve Surrogates.jl by: adding new surrogate models, adding new optimization techniques, showcasing compatibility with the SciML ecosystem and fixing unwanted behaviour with some current surrogate models.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. Strong knowledge of numerical analysis
is helpful but not required.

**Expected Results**: Improving Surrogates.jl with new surrogate models and new optimization techniques.

**Mentors**: [Ludovico Bessi](https:https://github.com/ludoro), [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Integration of FEniCS.jl with dolfin-adjoint + Zygote.jl for Finite Element Scientific Machine Learning

Scientific machine learning requires mixing scientific computing libraries with machine learning.
[This blog post highlights how the tooling of Julia is fairly advanced in this field](https://www.stochasticlifestyle.com/the-essential-tools-of-scientific-machine-learning-scientific-ml/) compared to alternatives such as Python,
but one area that has not been completely worked out is integration of automatic differentiation
with partial differential equations.
[FEniCS.jl](https://github.com/SciML/FEniCS.jl) is a wrapper to the
[FEniCS](https://fenicsproject.org/) project for finite element solutions of partial differential
equations. We would like to augment the Julia wrappers to allow for integration with Julia's
automatic differentiation libraries like [Zygote.jl](https://github.com/FluxML/Zygote.jl) by
using [dolfin-adjoint](http://www.dolfin-adjoint.org/en/release/). This would require setting up
this library for automatic installation for Julia users and writing adjoint passes which utilize
this adjoint builder library. It would result in the first total integration between PDEs and
neural networks.

**Recommended Skills**: A basic background in differential equations and Python. Having previous
Julia knowledge is preferred but not strictly required.

**Expected Results**: Efficient and high-quality implementations of adjoints for Zygote.jl over FEniCS.jl functions.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.
