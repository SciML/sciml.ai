@def rss_pubdate = Date(2020,3,23)
@def rss = """ DifferentialEquations.jl v6.12.0: DAE Extravaganza """
@def published = " 23 March 2020 "
@def title = " DifferentialEquations.jl v6.12.0: DAE Extravaganza "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

This release is the long-awaited DAE extravaganza! We are releasing fully-implicit
DAE integrators written in pure Julia, and thus compatible with items things like
GPUs and arbitrary precision. We have various DAE initialization schemes to
allow for automatically finding consistent initial conditions, and have also
upgraded our solvers to solve state and time dependent mass matrices. These
results have also trickled over to DiffEqFlux, with the new neural ODE structs
which support singular mass matrices (DAEs). Together this is a very comprehensive
push into the DAE world.

## DImplicitEuler and DBDF2: Fully Implicit DAE Solvers in Pure Julia

Yes, you saw that correctly. There is now a fully implicit DAE solver setup
in pure Julia, meaning that high performance, GPU, arbitrary precision,
uncertainty quantification, automatic differentiation, etc. all exist on a set
of fully implicit ODEs. All of the standard features, like callback support
and linear solver choices, also apply. Currently we only offer the first and
second order BDF methods, but this is the difficult part and fully implicit DAE
adaptive order BDF is coming soon, likely this summer. This checks off one of
the longest standing requests for the JuliaDiffEq ecosystem. Thank Kanav Gupta
(@kanav99) for this wonderful addition.

[The documentation for DAE solvers has been redone, so please check it out!](https://docs.juliadiffeq.org/latest/solvers/dae_solve/)

## DAE Initialization Choices

Along with the new DAE solvers, there's now a setup for initialization algorithms
for finding consistent initial conditions. These work on semi-explicit mass
matrix ODEs (i.e. singular mass matrices) and fully implicit ODEs in
`f(u',u,p,t)=0` form. A dispatch system on initialization algorithms was created
so we can iteratively keep enhancing the system, and we currently have implemented
the method from Brown (i.e. DASSL) for initializing only the algebraic part, and
a collocation method from Shampine that initializes both the differential and
algebraic equations. Again, we will continue to iteratively add to this selection
over time. A large part of this is due to Kanav Gupta (@kanav99).

## State and time dependent mass matrices, i.e. M(u,p,t)u'=f(u,p,t)

Mass matrices can now be made state and time dependent using DiffEqOperators.
For example, the following is a valid mass matrix system:

```julia
function f(du,u,p,t)
    du[1] = u[1]
    du[2] = u[2]
    du[3] = u[3]
end
function update_func(A,u,p,t)
    A[1,1] = cos(t)
    A[2,1] = sin(t)*u[1]
    A[3,1] = t^2
    A[1,2] = cos(t)*sin(t)
    A[2,2] = cos(t)^2 + u[3]
    A[3,2] = sin(t)*u[2]
    A[1,3] = sin(t)
    A[2,3] = t^2
    A[3,3] = t*cos(t) + 1
end
dependent_M1 = DiffEqArrayOperator(ones(3,3),update_func=update_func1)
prob = ODEProblem(ODEFunction{iip,true}(f, mass_matrix=mm_A), u0, tspan)
```

is a valid specification of a `M(u,p,t)u'=f(u,p,t)` system which can then be solved
with methods [as described on the DAE solver page](https://docs.juliadiffeq.org/latest/solvers/dae_solve/).
We have found that Yingbo Ma's OrdinaryDiffEq.jl RadauIIA works quite well for
such systems, so do give it a try!

## Neural DAE Structs in DiffEqFlux

Continuing with the DAE theme, we now have `NeuralODEMM` inside of DiffEqFlux.jl
for specifying semi-explicit mass matrix ODEs in order to impose constraint
equations in the time evolution of the system. For example, the following is a
neural DAE where the sum of the 3 ODE variables is constrained to 1:

```julia
dudt2 = FastChain(FastDense(3,64,tanh),FastDense(64,2))
ndae = NeuralODEMM(dudt2, (u,p,t) -> [u[1] + u[2] + u[3] - 1], tspan, M, Rodas5(autodiff=false),saveat=0.1)
```

We are excited to see what kinds of applications people will come up with given
such a tool, since properties like conservation of energy can now be directly
encoded into the trained system.

## Mass Matrix DAE Adjoints

In conjunction with the neural ODEs with constraints provided by mass matrices,
we have released new additions to the adjoint methods which allow them to
support singular mass matrices. This is another great addition by Yingbo Ma
(@YingboMa).

## Massive Neural ODE Performance Improvements

There has been another set of massive neural ODE performance improvements.
Making use of ReverseDiff.jl in strategic ways, avoiding Flux allocations, and
fast-paths for common adjoints were all part of the game. We saw another 2x speedup
from these advances.

## Second Order Sensitivity Analysis and sciml_train Newton Methods

Second order sensitivity analysis has been added to the DiffEqSensitivity.jl
library. One can either query for fast Hessian calculations or for fast
Hessian-vector products. These utilize a mixture of AD and adjoint methods
for performing the computation in a time and memory efficient manner. For example,
the following return the Hessian and the Hessian-vector product of the ODE
system with respect to parameters:

```julia
function fb(du,u,p,t)
  du[1] = dx = p[1]*u[1] - p[2]*u[1]*u[2]
  du[2] = dy = -p[3]*u[2] + p[4]*u[1]*u[2]
end

function jac(J,u,p,t)
  (x, y, a, b, c) = (u[1], u[2], p[1], p[2], p[3])
  J[1,1] = a + y * b * -1
  J[2,1] = y
  J[1,2] = b * x * -1
  J[2,2] = c * -1 + x
end

f = ODEFunction(fb,jac=jac)
p = [1.5,1.0,3.0,1.0]; u0 = [1.0;1.0]
prob = ODEProblem(f,u0,(0.0,10.0),p)
loss(sol) = sum(sol)
v = ones(4)

H  = second_order_sensitivities(loss,prob,Vern9(),saveat=0.1,abstol=1e-12,reltol=1e-12)
Hv = second_order_sensitivity_product(loss,v,prob,Vern9(),saveat=0.1,abstol=1e-12,reltol=1e-12)
```

## Magnus Integrators for u'=A(t)u and Lie Group Integrators for u'=A(u,t)u

If your system is described by a time-dependent linear operator, like many PDE
systems, the integration can be greatly improved by exploiting this structure
of the problem. The OrdinaryDiffEq.jl now supports Magnus integrators which
utilize the Krylov exponential tooling of exponential integrators in order to
support large-scale time-dependent systems in a way that preserves the solution
manifold. For state-dependent problems, a similar set of methods, the Lie group
methods, has also been started, with the infrastructure in place and the
implementation of the LieEuler method. The next step of just adding more methods
is the easy part, and we expect a whole litany of methods in these two categories
for the next release.

# Next Directions

Here's some things to look forward to:

- Automated matrix-free finite difference PDE operators
- Jacobian reuse efficiency in Rosenbrock-W methods
- High Strong Order Methods for Non-Commutative Noise SDEs
- Stochastic delay differential equations
