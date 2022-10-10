# SciML Ecosystem Update: Easy PDEs, Modelica Standard Library, and Faster GPU ODEs

This ecosystem update is all about making "hardcore computational science" topics easy.
Building large-scale acausal differential-algebraic equation (DAE) models? Solving PDEs?
Getting really high performance out of GPUs for ODE solvers? This is all a piece of cake
with these new releases. Let's dig in!

## ModelingToolkit Standard Library Reaches its v1.0 Release

The [ModelingToolkitStandardLibrary.jl]() package has been released! This is a "block set library"
for Julia with standard components for building acasual models in the [ModelingToolkit.jl system]().
While the ModelingToolit Standard Library does not have 100% coverage of the Modelica Standard Library
at this time, this is one of the goals within the organization and we believe we will be able to
reach this within the next year. However, **at this point it already has relatively high coverage**
and we encourage users to give it a try and report any issues that they find.

We hope that the ModelingToolkit Standard Library will not only serve as a good standard library
foundation on which models are built, but also serve as a "standard" for how to build libraries
of components. Over the coming years, we hope to see many organizations add to the ModelingToolkit
sphere with their own libraries of components, making an ecosystem of composable models to use
with all of the available transformations!

## HighDimPDE.jl: High-Dimensional PDE Solving via Deep Learning

Do you happen to have a 1000 dimensional PDE lying around that needs to be solved. Don't worry:
[HighDimPDE.jl]()
is a new library in the SciML sphere for handling very high dimensional partial differential equations!
As the [NeuralPDE.jl]() library grew to become more and more focused on physics-informed neural networks
(PINNs), the Deep Backwards Stochastic Differential Equations (DeepBSDE) and other high dimensional PDE
solvers were refactored out into this HighDimPDE library to give a more well-defined structure to the
modules. Not only that, many new methods which improve the scaling on certain types of PDEs are included in
this new version. If you need to solve for the evolution of 1000-dimensional probability distributions
represented by Kolmogorov equations, or solve some large-scale nonlinear Black-Scholes equations to
optimize financial portfolios, please check it out!

## MethodOfLines.jl: Easy and Fast Finite Difference PDE Solving

Adding to the theme of easy partial differential equation solving,
[MethodOfLines.jl]() has finally reached its prime-time to make finite difference solving of PDEs
only require copying the math out of the text book. With this library, there's no need to know how
to do semi-discretizations of advection equations via the WENO method into sets of ODEs. MethodOfLines.jl
takes in a symbolic mathematical definition and spits out stable solvable forms of the equations.

For example, let's solve...

## Asynchronous GPU-Accelerated ODE Solving
