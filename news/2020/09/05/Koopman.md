@def rss_pubdate = Date(2020,9,5)
@def rss = """ SciML Ecosystem Update: Koopman Optimization Under Uncertainty, Non-Commutative SDEs, GPUs in R, and More """
@def published = " 5 September 2020 "
@def title = " SciML Ecosystem Update: Koopman Optimization Under Uncertainty, Non-Commutative SDEs, GPUs in R, and More "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: Koopman Optimization Under Uncertainty, Non-Commutative SDEs, GPUs in R, and More

This update comes at the conclusion of our summer. As other projects have been
coming to an end, the underlying components that made a lot of the recent progress
possible has been documented and solidified. Thus this release is a grab bag of
exciting components which are used as the building blocks are larger numerical
algorithms and problem solvers, along with documentation releases for major
portions that have had lots of recent development. Let's dig in!

## DiffEqUncertainty.jl: Optimization Under Uncertainty with Koopman Operators

![Koopman Speed](https://user-images.githubusercontent.com/1814174/92310533-6acd2080-ef7d-11ea-8ac2-67c1f248f372.PNG)

We have recently released a new preprint [demonstrating a new method for highly efficient
uncertainty quantification with respect to parametric and process noise](https://arxiv.org/abs/2008.08737)
using the Koopman expectation. This method is released as part of the
[DiffEqUncertainty.jl expectation interface](https://github.com/SciML/DiffEqUncertainty.jl)
which now allows for fast computation of expected values with respect to distributional
inputs. We demonstrate how this gives more than 1,000x faster calculations
of moments than naive Monte Carlo calculations. If you haven't seen it, check
out [Adam Gerlach's JuliaCon 2020 video describing the method and the results](https://www.youtube.com/watch?v=gbRG5VHkhsY).
For a quick introduction, check out the [new expectation tutorial](https://tutorials.sciml.ai/html/DiffEqUncertainty/01-expectation_introduction.html).

The `expectation` function is differentiable, meaning that one can quickly
optimize the expected value of the solution of a differential equation with respect
its quantified uncertainties simply by placing it in an optimization context.
That is demonstrated in [this new tutorial demonstrating how to optimize controls
with respect to uncertainty](https://tutorials.sciml.ai/html/DiffEqUncertainty/02-AD_and_optimization.html).

We will continue to improve the documentation of the aspects of the ecosystem
around uncertainty quantification and believe that this may be one of the
most exciting aspects to start integrating with our other SciML tooling.

## Strong Order 1.0 Integrators for Non-Commutative Noise SDEs

This is one of the most exciting portions to me since the adaptive SDE solvers
are one of the oldest projects in the DifferentialEquations.jl suite and thus
the SciML ecosystem. Something that was always held off was the Wiktorsson
approximations for higher order non-commutative noise SDE solvers. For those who
aren't deep in that discipline, this is a method which allows for higher strong
order timestepping on any possible SDE. Before we had specific forms: scalar
noise, diagonal noise, and commutative noise. However, now we have reached the
final goal: higher strong order adaptive time stepping with general noise.

With this release we have `RKMilGeneral`, which is a well-optimized method
for strong order 1.0 stepping of general stochastic differential equations.
It has all of the performance enhancements of StochasticDiffEq.jl that you'd
expect. Most importantly, the completion of the Wiktorsson approximation components
enables many other strong order 1.0 methods to be easily created, meaning we will
soon fill the library with the whole literature of possible methods. Thank
Deepesh Singh Thakur (@deeepeshthakur) and @frankschae for this amazing achievement.

## Differentiable Quadrature with Quadrature.jl

Under the hood in the Koopman `expectation` calculation is a quadrature. To
achieve the goals we needed to, we have developed a new Quadrature library
[Quadrature.jl](https://github.com/SciML/Quadrature.jl). Quadrature.jl is a
metapackage which brings together all of the quadrature packages in the Julia
ecosystem, meaning that you can define a problem once and switch between any
of the integration methods. However, the metapackage interface is only the start!

Quadrature.jl exposes a batched interface, giving caller-side controls that allow
for parallelism. For example, in the following we multithread the integrand
calculations for Cubature.jl:

```julia
using Quadrature, Cubature, Base.Threads
function f(dx,x,p)
  Threads.@threads for i in 1:size(x,2)
    dx[i] = sum(sin.(@view(x[:,i])))
  end
end
prob = QuadratureProblem(f,ones(2),3ones(2),batch=2)
sol = solve(prob,CubatureJLh(),reltol=1e-3,abstol=1e-3)
```

This problem/solve setup follows the SciML standard conventions, making it
easy to map over to other tools like [AutoOptimize.jl](https://github.com/SciML/AutoOptimize.jl)
and [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) in the near
future.

But what this common interface also let's us do is define hooks into the Julia
automatic differentiation libraries such that all of the quadrature methods are
differentiable. Thus Quadrature.jl `solve` calls can be directly used inside of
Zygote differentiation. For example, the following does a two-dimensional integral
with [CUBA's Cuhre method](http://www.feynarts.de/cuba/) and then automatically
defines the backpass to allow for gradients:

```julia
using Quadrature, ForwardDiff, FiniteDiff, Zygote, Cuba
f(x,p) = sum(sin.(x .* p))
lb = ones(2)
ub = 3ones(2)
p = [1.5,2.0]

function testf(p)
    prob = QuadratureProblem(f,lb,ub,p)
    sin(solve(prob,CubaCuhre(),reltol=1e-6,abstol=1e-6)[1])
end
dp1 = Zygote.gradient(testf,p)
```

Overloads also give non-Julia quadrature methods compatibility with forward-mode
automatic differentiation via ForwardDiff.jl, meaning that both forward and reverse
are possible. With this, high dimensional quadrature schemes can be mixed with
all kinds of problems like training neural networks and Bayesian estimation.

## GPU Accelerated Differential Equation Solving in R with diffeqr 1.0

diffeqr, the DifferentialEquations.jl's R counterpart, got its 1.0 release
demonstrating new accelerations, including GPU support. Check out
[this new blog post](https://www.stochasticlifestyle.com/gpu-accelerated-ode-solving-in-r-with-julia-the-language-of-libraries/)
which describes how to solve an ensemble of ODEs 350x faster than deSolve in
pure R.

## Differentiable Molecular Dynamics Performance

Our differentiable molecular dynamics libraries,
[NBodySimulator.jl](https://github.com/SciML/NBodySimulator.jl) and
[Molly.jl](https://github.com/JuliaMolSim/Molly.jl) continue to improve thanks
to the work of Sebastian Micluta-Campeanu (@SebastianM-C). His latest blog post
[A fresh approach to N-body problems](https://nextjournal.com/SebastianM-C/a-fresh-approach-to-n-body-problems?token=2QnKjKYpnF5UYrB6ECZCYn),
digs into the details for the optimizations that are being performed on the latest
libraries. While these are still in their early stage, we have already found some
exciting new results and will be continuing this project over at least the next
few years.

## ReservoirComputing.jl Documentation

[ReservoirComputing.jl has released its documentation](https://reservoir.sciml.ai/dev/)
detailing how to do high performance training of echo state networks and other
reservoir-based machine learning methods. [Take a look at the first tutorial
training an echo state network to predict the chaotic outputs of the Lorenz
equation](https://reservoir.sciml.ai/dev/examples/esn/). This direction is particularly
exciting and we plan to help accelerate its developments over the next year.

## Physics-Informed Neural Networks: Systems of equations, PDAEs, and more

The last release blog post was directly focused on NeuralPDE.jl so I did not
want to make it the headliner again, but it very much could have. This release
has had major additions to NeuralPDE.jl, such as handling of systems of
equations and partial differential-algebraic equations, along with a lot of
demonstrations on higher order PDEs. [See Kirill's latest blog post for more
information on this.](https://nextjournal.com/kirill_zubov/physics-informed-neural-networks-pinns-solver-on-julia-gsoc-2020-final-report)

## ReactionNetworkImporters.jl (BioNetGen) and CellML Support on Catalyst

The Catalyst.jl and ModelingToolkit.jl ecosystem is growing fast!
[ReactionNetworkImporters.jl](https://github.com/isaacsas/ReactionNetworkImporters.jl)
is a package for importing BioNetGen models. [CellMLToolkit.jl](https://github.com/SciML/CellMLToolkit.jl)
is a package for importing CellML files. SBML and FMU support is soon to come.

## DifferentialEquations.jl Solvers Micro Tested Against Boost C++ with VCL

We thank Daniel Nagy for this demonstration testing the speed of RK4 on very small
ODEs (Lorenz) against Boost C++ with and without VCL. Thank you Chris Elrod (@celrod)
for helping maximize our vectorization in these cases. We can now demonstrate
on CPUs that we are able to outperform Boost with VCL. Note that this simply
corresponds to the cost of solving asymptotically small ODEs and does not impact
most other usage, though a lot of users who do small ODE optimization will likely
be interested in the little bits of performance gains seen in our latest updates.
Improvements along these lines for ensemble GPU methods are coming soon.

![Boost VCL vs Julia DifferentialEquations.jl](https://user-images.githubusercontent.com/1814174/91665075-1af3e280-eac1-11ea-8fce-a0f311db05de.png)

# Next Directions

The next directions are going to be highly tied to the directions that
we are going with the latest Google Summer of Code, so here are a few
things to look forward to:

- Higher efficiency low-storage Runge-Kutta methods with a demonstration
  of optimality in a large-scale climate model (!!!).
- Continued improvements to parallel and sparse automatic differentiation.
- More performance
