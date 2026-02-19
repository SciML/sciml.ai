@def rss_pubdate = Date(2021,2,5)
@def rss = """SciML Ecosystem Update: GalacticOptim, GlobalSensitivity, Tutorials, and Documentation"""
@def published = " 5 February 2021 "
@def title = "SciML Ecosystem Update: GalacticOptim, GlobalSensitivity, Tutorials, and Documentation"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: GalacticOptim, GlobalSensitivity, Tutorials, and Documentation

Another few weeks another few updates. This time around were looking at a few
package releases and a bunch of new documentation. Let's dive right in!

## GalacticOptim.jl: A Universal Optimization Interface for Julia

What would you call a package that combines all that Julia has to offer in
optimization? A global optimization package? No, there are many global optimization
packages in here, so we're beyond that! Introducing GalacticOptim.jl: a universal
optimization interface for Julia. GalacticOptim.jl sits as an API for calling
(almost) any Julia optimization package (and its coverage will continue to improve).
It has a lot of nice high-level tooling that allows for automatically switching
choices of optimizers and automatic differentiation across packages. Let's use
ForwardDiff with [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl)'s BFGS:

```julia
using GalacticOptim, Optim
rosenbrock(x,p) =  (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
x0 = zeros(2)
p  = [1.0,100.0]

f = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff())
prob = OptimizationProblem(f, x0, p, lb = [-1.0,-1.0], ub = [1.0,1.0])
sol = solve(prob,BFGS())
```

But wait, what if we wanted to use [BlackBoxOptim.jl](https://github.com/robertfeldt/BlackBoxOptim.jl)?
No problem:

```julia
using BlackBoxOptim
sol = solve(prob,BBO())
```

This package also directly works with
[ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl)
to have a symbolic interface similar to a nonlinear JuMP but on steroids. You
can use the "DSL" without using a DSL. How? `modelingtoolkitize` automatically
converts problems to the symbolic form. Let's generate the Hessian code:

```julia
using ModelingToolkit
sys = modelingtoolkitize(prob)
generate_hessian(sys)[2]

## Returns
:((var"##MTIIPVar#427", var"##MTKArg#424", var"##MTKArg#425")->begin
          @inbounds begin
                  begin
                      (ModelingToolkit.fill_array_with_zero!)(var"##MTIIPVar#427")
                      let (x₁, x₂, α₁, α₂) = (var"##MTKArg#424"[1], var"##MTKArg#424"[2], var"##MTKArg#425"[1], var"##MTKArg#425"[2])
                          var"##MTIIPVar#427"[1] = (+)(2, (*)(8, α₂, (^)(x₁, 2)), (*)(-4, α₂, (+)(x₂, (*)(-1, (^)(x₁, 2)))))
                          var"##MTIIPVar#427"[2] = (*)(-4, x₁, α₂)
                          var"##MTIIPVar#427"[3] = (*)(-4, x₁, α₂)
                          var"##MTIIPVar#427"[4] = (*)(2, α₂)
                      end
                  end
              end
          nothing
      end)
```

And there you go. All of ModelingToolkit's automated parallelization and transformation
features are right there at your fingertips. This library is still new so there's
more to add, like bindings to MOI (for IPOPT), making use of the symbolic
information in solver calls, and automatic differentiability.

## GlobalSensitivity.jl: Efficient, Differentiable, and Parallelized GSA

GlobalSensitivity.jl is not necessarily too new since some of the functionality
did exist within DiffEqSensitivity.jl before, but now it has been given its
own package with a bunch of upgrades to become a full-fledged global sensitivity
analysis package. It is complete with its own documentation, tutorials, and
many new methods. All of the methods allow for batching in a way that exposes
parallelism to the user! [Check out the new documentation.](https://docs.sciml.ai/GlobalSensitivity/dev/)

## New DiffEqFlux Tutorials: Bouncing Ball, Multiple Networks, and More

Due to popular request, quite a few new DiffEqFlux tutorials were added.
There are tutorials doing [automatic differentiation through event handling like
bouncing ball](https://docs.sciml.ai/DiffEqFlux/dev/examples/bouncing_ball/),
[parameter estimation techniques for highly stiff systems](https://docs.sciml.ai/DiffEqFlux/dev/examples/stiff_ode_fit/),
and more. While these aren't new functionalities, it's highlighting them in a
new light that hopefully will help you make use of them effectively!

## New Uncertainty Quantification Tutorial: GPU-Acclerated Bayesian-Koopman UQ

A new tutorial was added on [GPU-accelerated Bayesian Koopman uncertainty quantification](https://docs.sciml.ai/SciMLTutorialsOutput/html/DiffEqUncertainty/03-GPU_Bayesian_Koopman.html). Together it shows how to estimate the uncertainty
distributions of parameters and then quickly compute probabilistic statements
about the solution in a GPU-accelerated fashion that's order of magnitude faster
than Monte Carlo. The steps are:

1. Parameter estimation with uncertainty with Bayesian differential equations by
   integrating the differentiable differential equation solvers with the Turing.jl library.
2. Fast calculation of probabilistic estimates of differential equation solutions
   with parametric uncertainty using the Koopman expectation.
3. GPU-acceleration of batched differential equation solves.

Check the tutorial for more information!

## New Docs: DiffEqBayes, DiffEqParamEstim, DiffEqOperators

The core DifferentialEquations.jl documentation was cleaned up with some of the
auxillary pieces moved out. As part of that, more repositories around the ecosystem
go their own documentation. [DiffEqParamEstim.jl](https://docs.sciml.ai/DiffEqParamEstim/dev/)
is easy and automated parameter inference for differential equations.
[DiffEqBayes.jl](https://docs.sciml.ai/DiffEqBayes/dev/) is easy Bayesian inference
for differential equations. And [DiffEqOperators.jl](https://docs.sciml.ai/DiffEqOperators/dev/)
is our automated finite difference discretization library. Now that these docs
are decoupled from the main docs, they are free to grow and flesh out their
descriptions. The main pages of DifferentialEquations.jl now is a comparison
of the different choices in the ecosystem with links to the companion package
documentations. Hopefully this will make it easier to guide users towards
DiffEqFlux and Turing, and understand when the other offerings are useful.
