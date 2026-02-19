@def rss_pubdate = Date(2022,10,8)
@def rss = """SciML Ecosystem Update: Better Error Messages, Compile Times, and Documentation"""
@def published = " 8 October 2022 "
@def title = "SciML Ecosystem Update: Better Error Messages, Compile Times, and Documentation"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML Ecosystem Update: Better Error Messages, Compile Times, and Documentation

This release had a major focus on high-level user issues such as error messages, compile times,
and documentation generation. Other related issues, such as code style enforcement, have also
seen huge overhauls in this ecosystem update. From all of this,
**the documentation of SciML post summer 2022 has essentially been completely overhauled and improved!**

![Function definition error message](https://user-images.githubusercontent.com/1814174/194701459-dc28d519-d49d-4f92-9c21-9a683536c12e.png)

With that, let's start showing some details!

## New High Level Error Catching (Better Error Messages!)

One of the major changes in this version of SciML is that high-level error messages have been
introduced for many common issues. These give customized and context-dependent information
to make it much easier to comprehend the pieces. For example, let's take a look at what happens
if someone attempts to solve an incompatible ODE definition. Let's take the Lorenz equation, but
with the issue of having too many arguments in the ODE definition:

```julia
using OrdinaryDiffEq
function lorenz!(du,u,a,b,c,t)
 du[1] = a*(u[2]-u[1])
 du[2] = u[1]*(b-u[3]) - u[2]
 du[3] = u[1]*u[2] - c*u[3]
end
u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
prob = ODEProblem(lorenz!,u0,tspan)
sol = solve(prob,Tsit5())
```

This is a common issue that we see from users coming from a MATLAB background, where "add more arguments"
is the convention there. So what does the error look like:

```julia
julia> prob = ODEProblem(lorenz!,u0,tspan)
ERROR: All methods for the model function `f` had too many arguments. For example,
an ODEProblem `f` must define either `f(u,p,t)` or `f(du,u,p,t)`. This error
can be thrown if you define an ODE model for example as `f(du,u,p1,p2,t)`.
For more information on the required number of arguments for the function
you were defining, consult the documentation for the `SciMLProblem` or
`SciMLFunction` type that was being constructed.

A common reason for this occurrence is due to following the MATLAB or SciPy
convention for parameter passing, i.e. to add each parameter as an arguemnt.
In the SciML convention, if you wish to pass multiple parameters, use a
struct or other collection to hold the parameters. For example, here is the
parameterized Lorenz equation:

function lorenz(du,u,p,t)
  du[1] = p[1]*(u[2]-u[1])
  du[2] = u[1]*(p[2]-u[3]) - u[2]
  du[3] = u[1]*u[2] - p[3]*u[3]
 end
 u0 = [1.0;0.0;0.0]
 p = [10.0,28.0,8/3]
 tspan = (0.0,100.0)
 prob = ODEProblem(lorenz,u0,tspan,p)

Notice that `f` is defined with a single `p`, an array which matches the definition
of the `p` in the `ODEProblem`. Note that `p` can be any Julia struct.

Offending function: f
Methods:
# 1 method for generic function "lorenz!":
[1] lorenz!(du, u, a, b, c, t) in Main at REPL[2]:1

Stacktrace:
 [1] isinplace(f::Function, inplace_param_number::Int64, fname::String, iip_preferred::Bool)
   @ SciMLBase C:\Users\accou\.julia\packages\SciMLBase\xWByK\src\utils.jl:185
 [2] isinplace(f::Function, inplace_param_number::Int64)
   @ SciMLBase C:\Users\accou\.julia\packages\SciMLBase\xWByK\src\utils.jl:177
 [3] ODEProblem(f::Function, u0::Vector{Float64}, tspan::Tuple{Float64, Float64}, p::SciMLBase.NullParameters; kwargs::Base.Pairs{Symbol, Union{}, Tuple{}, NamedTuple{(), Tuple{}}})
   @ SciMLBase C:\Users\accou\.julia\packages\SciMLBase\xWByK\src\problems\ode_problems.jl:151
 [4] ODEProblem(f::Function, u0::Vector{Float64}, tspan::Tuple{Float64, Float64}, p::SciMLBase.NullParameters) (repeats 2 times)
   @ SciMLBase C:\Users\accou\.julia\packages\SciMLBase\xWByK\src\problems\ode_problems.jl:150
 [5] top-level scope
   @ REPL[5]:1
```

Lots of knowledge from common user issues and backgrounds was pulled from the
[Julialang Discourse](https://discourse.julialang.org/) in order to help identify where the misconceptions
come from and give very detailed responses. We hope this makes the library a lot friendlier to
newcomers.

## Faster Load Times via Improved Precompilation

This is a major change that has happened over the last year to change the compile times of first ODE
solves from 30 seconds to 0.1. To find out more, read [the compile time blog post](https://sciml.ai/news/2022/09/21/compile_time/).

## Many New Docstrings in SciMLBase.jl

The high level interface functions, such as `solve`, `ODEProblem`, etc. have received greatly improved
documentation. For example, if you run `?ODEProblem` in the REPL, you will now see the following:

```julia
help?> ODEProblem
search: ODEProblem RODEProblem SplitODEProblem DynamicalODEProblem IncrementingODEProblem SecondOrderODEProblem

  Defines an ordinary differential equation (ODE) problem. Documentation Page:
  https://docs.sciml.ai/DiffEqDocs/stable/types/ode_types/

  Mathematical Specification of an ODE Problem
  ==============================================

  To define an ODE Problem, you simply need to give the function f and the initial condition
  u_0 which define an ODE:

  M \frac{du}{dt} = f(u,p,t)

  There are two different ways of specifying f:

    •  f(du,u,p,t): in-place. Memory-efficient when avoiding allocations. Best option for most cases unless
       mutation is not allowed.

    •  f(u,p,t): returning du. Less memory-efficient way, particularly suitable when mutation is not allowed
       (e.g. with certain automatic differentiation packages such as Zygote).

  u₀ should be an AbstractArray (or number) whose geometry matches the desired geometry of u.
  Note that we are not limited to numbers or vectors for u₀; one is allowed to provide u₀ as
  arbitrary matrices / higher dimension tensors as well.

  For the mass matrix M, see the documentation of ODEFunction.

  Problem Type
  ==============

  Constructors
  ––––––––––––––

  ODEProblem can be constructed by first building an ODEFunction or by simply passing the ODE right-hand side to the constructor. The constructors are:

    •  ODEProblem(f::ODEFunction,u0,tspan,p=NullParameters();kwargs...)

    •  ODEProblem{isinplace,specialize}(f,u0,tspan,p=NullParameters();kwargs...) : Defines the ODE with the
       specified functions. isinplace optionally sets whether the function is inplace or not. This is
       determined automatically, but not inferred. specialize optionally controls the specialization level.
       See the specialization levels section of the SciMLBase documentation
       (https://docs.sciml.ai/SciMLBase/stable/interfaces/Problems/#Specialization-Levels) for more details. The
       default is AutoSpecialize.

  For more details on the in-place and specialization controls, see the ODEFunction documentation.

  Parameters are optional, and if not given then a NullParameters() singleton will be used which
  will throw nice errors if you try to index non-existent parameters. Any extra keyword arguments
  are passed on to the solvers. For example, if you set a callback in the problem, then that
  callback will be added in every solve call.

  For specifying Jacobians and mass matrices, see the ODEFunction documentation.

  Fields
  ––––––––

    •  f: The function in the ODE.

    •  u0: The initial condition.

    •  tspan: The timespan for the problem.

    •  p: The parameters.

    •  kwargs: The keyword arguments passed onto the solves.

  Example Problems
  ==================

  Example problems can be found in DiffEqProblemLibrary.jl
  (https://github.com/SciML/DiffEqProblemLibrary.jl).

  To use a sample problem, such as prob_ode_linear, you can do something like:

  #] add ODEProblemLibrary
  using ODEProblemLibrary
  prob = ODEProblemLibrary.prob_ode_linear
  sol = solve(prob)
```

The DifferentialEquations.jl documentation has been restructured to make use of these docstrings.

## SciML Style Guide and Formatting Enforcement

The entire SciML organization updated its practices to have a well-defined style guide called
[SciML Style](https://github.com/SciML/SciMLStyle) This style guide is comprehensive, covered high-level details such as whether
to prefer the use of closures or not, to lower more mundane details like the proper style for
continuing equations to the next line. It has quickly become one of the most widely used style
guides for Julia packages. For more information, please check out the style guide's documentation.

With this, all of the libraries now make use of JuliaFormatter.jl to automatically enforce style
rules. When new changes are made to the repo, style enforcement is required, and for example
contributors are required to run commands like:

```julia
using JuliaFormatter
format(raw"C:\Users\accou\.julia\dev\QuasiMonteCarlo")
```

in order to reformat their code into the SciML style. This ensures that the code is more uniform
across contributors, making it easier to read, understand, and contribute.

## NeuralOperators.jl: Fast Partial Differential Equation Solving via Neural Networks

The [NeuralOperators.jl](https://github.com/SciML/NeuralOperators.jl) library has been added to the SciML ecosystem. This library covers
techniques like Fourier Neural Operators, DeepONets, and more. We have demonstrated that these
implementations outperformed the original ones by around 3x, and we believe there are many more
tricks to employ to eek out a bit more performance as well. We plan to continue improving these
techniques, along with integrating them into the [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl)
physics-informed neural network (PINN) framework for physics-informed neural operator approaches.
More on this coming soon!

## PolyChaos.jl: Polynomial Chaos through Operator Overloading

The [PolyChaos.jl](https://github.com/SciML/PolyChaos.jl) library has been incorporated into the SciML ecosystem to give fast and accurate
polynomial chaos expansions through multiple dispatch, similar to ForwardDiff Dual numbers in some sense.
This is then being used in other projects to make it easy to develop codes for model order reduction
and uncertainty quantification. We are excited to ensure the maintenance and longevity of this crucial
building block, and already have a planned package release which makes use of this functionality.
