@def rss_pubdate = Date(2020,2, 18)
@def rss = """ DifferentialEquations.jl v6.11.0: Universal Differential Equation Overhaul """
@def published = " 18 February 2020 "
@def title = " DifferentialEquations.jl v6.11.0: Universal Differential Equation Overhaul "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

After the release of the paper
[Universal Differential Equations for Scientific Machine Learning](https://arxiv.org/abs/2001.04385),
we have had very good feedback and have seen plenty of new users joining the
Julia differential equation ecosystem and utilizing the tools for scientific
machine learning. A lot of our work in this last release focuses around these
capability, mixing with GPU support and global sensitivity analysis to augment
the normal local tools of SciML.

## 1,000 Stars for DifferentialEquations.jl!

Before the bigger updates, I wanted to announce that DifferentialEquations.jl
surpassed the 1,000 star milestone in this round. This is very helpful for the
community as an indicator of community utility. If you haven't done so yet, please
[star DifferentialEquations.jl](https://github.com/JuliaDiffEq/DifferentialEquations.jl)
as it is a valuble indicator for future grants and funding for student projects.

## Local Sensitivity Analysis Overhaul: `concrete_solve` and `sensealg`

With major help from Yingbo Ma (@YingboMa), we have overhauled our sensitivity
analysis algorithms to give a lot more choice and implementation flexibility.
While all of the lower level interface is still in place, a new higher level
interface will make users especially happy. This interface is `concrete_solve`.
It's a version of `solve` (limitation: no post-solution interpolation)
which explicitly takes in `u0` and `p`, and is setup with Zygote to automatically
utilize our built-in `SensitivityAlgoritm` methods whether Zygote (or any
ChainRules.jl-based AD system) asks for a gradient. For example:

```julia
using DiffEqSensitivity, OrdinaryDiffEq, Zygote

function fiip(du,u,p,t)
  du[1] = dx = p[1]*u[1] - p[2]*u[1]*u[2]
  du[2] = dy = -p[3]*u[2] + p[4]*u[1]*u[2]
end
p = [1.5,1.0,3.0,1.0]; u0 = [1.0;1.0]
prob = ODEProblem(fiip,u0,(0.0,10.0),p)
sol = concrete_solve(prob,Tsit5())
```

solves the equation, while:

```julia
du0,dp = Zygote.gradient((u0,p)->sum(concrete_solve(prob,Tsit5(),u0,p,saveat=0.1,sensealg=QuadratureAdjoint())),u0,p)
```

computes `du0` and `dp`: the gradient of the cost function with respect to the
initial condition and parameters. Notice here we have a choice of `sensealg`,
which allows the choice of a sensitivity analysis method for Zygote to use. The
choices are vast and growing, with each having pros and cons. You can ask it
to use forward sensitivity analysis, forward mode AD, Tracker.jl, O(1) adjoints
via backsolve, **checkpointed adjoints**, etc. all just by changing the `sensealg`
keyword argument. Thus this is the first system to offer such flexibility to
allow for the most efficient gradient calculations for a specific problem to
occur.

We've seen some pretty massive performance and stability gains by utilizing
this system!

## DiffEqFlux Overhaul: Zygote Support, `sciml_train` Interface, and Fast Layers

Given the workflows that we saw in [the UDE paper](https://arxiv.org/abs/2001.04385),
we have overhauled DiffEqFlux. The new interface, `sciml_train`, is more suitable
to scientific machine learning. We have introduced the `Fast` layer setup, i.e.
`FastChain` and `FastDense`, which give a 10x speed improvement over Flux.jl
neural architectures by avoiding expensive restructure/destructure calls. Additionally,
`sciml_train` links not just to the Flux.jl deep learning optimizer library,
but also to Optim.jl for stability-enhanced methods like L-BFGS. Lastly, this
new interface has explicit parameters, something that has helped fix a lot of
issues users have had with the interface. Together, we can train a neural ODE
in around 30 seconds in this example that mixes ADAM and BFGS optimizers:

```julia
using DiffEqFlux, OrdinaryDiffEq, Flux, Optim, Plots

u0 = Float32[2.; 0.]
datasize = 30
tspan = (0.0f0,1.5f0)

function trueODEfunc(du,u,p,t)
    true_A = [-0.1 2.0; -2.0 -0.1]
    du .= ((u.^3)'true_A)'
end
t = range(tspan[1],tspan[2],length=datasize)
prob = ODEProblem(trueODEfunc,u0,tspan)
ode_data = Array(solve(prob,Tsit5(),saveat=t))

dudt2 = FastChain((x,p) -> x.^3,
            FastDense(2,50,tanh),
            FastDense(50,2))
n_ode = NeuralODE(dudt2,tspan,Tsit5(),saveat=t)

function predict_n_ode(p)
  n_ode(u0,p)
end

function loss_n_ode(p)
    pred = predict_n_ode(p)
    loss = sum(abs2,ode_data .- pred)
    loss,pred
end

loss_n_ode(n_ode.p) # n_ode.p stores the initial parameters of the neural ODE

cb = function (p,l,pred;doplot=false) #callback function to observe training
  display(l)
  # plot current prediction against data
  if doplot
    pl = scatter(t,ode_data[1,:],label="data")
    scatter!(pl,t,pred[1,:],label="prediction")
    display(plot(pl))
  end
  return false
end

# Display the ODE with the initial parameter values.
cb(n_ode.p,loss_n_ode(n_ode.p)...)

res1 = DiffEqFlux.sciml_train(loss_n_ode, n_ode.p, ADAM(0.05), cb = cb, maxiters = 300)
cb(res1.minimizer,loss_n_ode(res1.minimizer)...;doplot=true)
res2 = DiffEqFlux.sciml_train(loss_n_ode, res1.minimizer, LBFGS(), cb = cb)
cb(res2.minimizer,loss_n_ode(res2.minimizer)...;doplot=true)
```

## SDEs and AD on DiffEqGPU.jl

[DiffEqGPU.jl, the library for automated parallelization of small differential equations across GPUs](https://github.com/JuliaDiffEq/DiffEqGPU.jl), now supports SDEs and ForwardDiff dual numbers. This
means you can use adaptive SDE solvers to solve 100,000 simultaneous SDEs on
GPUs, or solve ODEs defined by dual numbers in order to do forward sensitivity
analysis of many parameters at once. Once again, the interface is as simple as
adding `EnsembleGPUArray()` to your ensemble solve, essentially no code change
is required to make use of these features!

## Global Sensitivity Analysis Overhaul: Common interface and Parallelism

Thanks to Vaibhav Dixit (@vaibhavdixit02), we now have a new interface for
global sensitivity analysis which allows for specifying a function that is
compatible with all forms of GSA and allows for parallelism. For example, we
can look at the global sensitivity of the mean and the maximum of the Lotka-Volterra
ODE by defining a function of the parmeters `p`:

```julia
using DiffEqSensitivity, Statistics, OrdinaryDiffEq #load packages
function f(du,u,p,t)
  du[1] = p[1]*u[1] - p[2]*u[1]*u[2] #prey
  du[2] = -p[3]*u[2] + p[4]*u[1]*u[2] #predator
end
u0 = [1.0;1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1.0]
prob = ODEProblem(f,u0,tspan,p)
t = collect(range(0, stop=10, length=200))
f1 = function (p)
  prob1 = remake(prob;p=p)
  sol = solve(prob1,Tsit5();saveat=t)
  [mean(sol[1,:]), maximum(sol[2,:])]
end
```

And from here we can call `gsa`:

```julia
m = gsa(f1,Morris(total_num_trajectory=1000,num_trajectory=150),[[1,5],[1,5],[1,5],[1,5]])
```

That's GSA with the Morris method. But now Sobol is one line away, and eFAST, etc.
are all simple variations.

In addition, there is a parallel batching interface that works nicely with the
Ensemble interface. All that happens is that `p` becomes a matrix where each
row `p[i,:]` is a set of parameters. For example, the following does the same
global sensitivity analysis but with Sobol sensitivity and automatic GPU
parallelism:

```julia
using DiffEqGPU

f1 = function (p)
  prob_func(prob,i,repeat) = remake(prob;p=p[i,:])
  ensemble_prob = EnsembleProblem(prob,prob_func=prob_func)
  sol = solve(ensemble_prob,Tsit5(),EnsembleGPUArray();saveat=t)
  # Now sol[i] is the solution for the ith set of parameters
  out = zeros(size(p,1),2)
  for i in 1:size(p,1)
    out[i,1] = mean(sol[i][1,:])
    out[i,2] = maximum(sol[i][2,:])
  end
  out
end
sobol_result = gsa(f1,Sobol(),A,B,batch=true)
```

## eFAST Global Sensitivity Analysis

A new global sensitivity analysis method with fast convergence, eFAST, has been
added to the library. It works on the same `gsa` interface, so code using more
traditional Sobol or Morris techniques can switch over to this faster converging
method with just a few lines changed!

# Next Directions

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- Native Julia fully implicit ODE (DAE) solving in OrdinaryDiffEq.jl
- High Strong Order Methods for Non-Commutative Noise SDEs
- Stochastic delay differential equations
