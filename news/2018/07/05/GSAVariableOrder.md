@def rss_pubdate = Date(2018,7 ,5 )
@def rss = """ DifferentialEquations.jl 4.6: Global Sensitivity Analysis, Variable Order Adams """
@def published = " 5 May 2018 "
@def title = " DifferentialEquations.jl 4.6: Global Sensitivity Analysis, Variable Order Adams "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Tons of improvements due to Google Summer of Code. Here's what's happened.

## Global Sensitivty Analysis (Morris, Sobol)

GSoC student Vaibhav Dixit (@Vaibhavdixit02) added global sensitivity analysis
(GSA) methods to DiffEqSensitivity.jl. GSA quantifies the effects of the
parameters on the solution of the ODE. The implementation of these methods
are on any generic `f(p)`, so this may be refactored into an external non-DiffEq
library. The Morris method and the Sobol method, two of the most commonly used
GSA methods, are part of this implementation. Other methods, such as PRC, SRC,
FAST, eFAST, etc. are coming soon.

## Variable time step variable order Adams methods (VCABM)

GSoC student Shubham Maddhashiya (@sipah00) added a variable-coefficient form
implementation of the variable order variable time step Adams-Bashforth-Moulton
method. This implementation matches the classic DDEABM software of Shampine
which specializes in its ability to utilize the higher orders for larger time
steps and high efficiency on less stiff equations. Our benchmarks show efficiency
improvements over not only DDEABM, but also over the Sundials' CVODE Adams
implementation (not surprised here though: Hairer had showed before that a
variable coefficient form can give more effective order selection) and the
Runge-Kutta methods on some problems. This makes it a good native Julia
replacement to those classic methods, not only for large non-stiff ODE systems,
but also on many other smooth non-stiff systems.

For example, here is the new method applied to the Pleiades Problem:

![Pleiades work-precision diagram](https://user-images.githubusercontent.com/17304743/41568408-5f5aeb7e-731a-11e8-9bb0-b310cae20d1c.png)

In the [previous notebook](https://nbviewer.jupyter.org/github/JuliaDiffEq/DiffEqBenchmarks.jl/blob/master/NonStiffODE/Pleiades%20Work-Precision%20Diagrams.ipynb), the fastest methods were the
Vern6, Vern7, and Sundials CVODE methods. Now this method seems to be a new
contender in this field.

## High Stiff Order Exponential Runge-Kutta and EPIRK Methods

GSoC student Xingjian Guo (@MSeeker1340) added the `HochOst4` and `Exp4`
algorithms which is an exponential Runge-Kutta algorithm with stiff order 4.
Unlike other high order ExpRK methods which have issues with order loss when
solving a problem with high stiffness, this method retains its order even on
this difficult class of problems. Note that the classic 4th order exponential
integrator, `ETDRK4`, is only stiff order 1 making it perform less effectively
than `HochOst4` and `Exp4` on the highly stiff PDE discretizations that it was
designed for. Xingjian is continuing this line of development with adaptive
ExpRK methods and more high stiff order EPIRK methods.

## Low Order IMEX Methods

GSoC student Shubham Maddhashiya (@sipah00) added some low order IMEX methods
to the OrdinaryDiffEq.jl solver suite. These methods are common methods for
solving PDEs, especially spectral discretizations of PDEs. Crank-Nicholson
Adams-Bashforth 2 (CNAB2), Crank-Nicholson Leapfrog (CNLF), and an
Implicit-Explicit Euler method (IMEXEuler) are all available on the common
interface. In many cases one may want to utilize the higher order methods,
but there are still many uses for these. For example, implicit Euler is the
only method with an infinite strong stability preserving (SSP) coefficient,
meaning that it can be much more stable than other methods for hyperbolic
PDEs. This IMEXEuler can be an easy way to utilize a more efficient than the
standard IMEXEuler.

# In development

A lot of the next developments will come from our GSoC students. Here's a list
of things we are aiming for:

- Quasi-constant stepsize variable coefficient BDF and NDF and IMEX BDF (SBDF)
  integrators. Both fixed and variable order.

- High order `EPIRK` adaptive exponential Runge-Kutta methods.

- Fixed Leading Coefficient (FLC) form Nordsieck BDF integrators.

- `SABDF2`, which is a strong order 0.5 adaptive BDF2 implementation for
  stochastic differential equations which is order 2 for small noise SDEs.
  This will be the first implicit adaptive integrator for small noise SDEs and
  will be a great choice for SPDEs.

- Yiannis Simillides (@ysimillides) keeps making improvements to FEniCS.jl. At
  this part a large portion (a majority?) of the tutorial works from Julia.
  Integration with native Julia tools like Makie.jl is in progress.

- Mikhail Vaganov (@Mikhail-Vaganov) is making good progress on his N-body
  modeling language. This will make it easy to utilize DiffEq as a backend
  for molecular dynamics simulation. Follow the progress in DiffEqPhysics.jl

And here's a quick view of the rest of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface

# Projects

Are you a student who is interested in working on differential equations software
and modeling? If so, please get in touch with us since we may have some funding
after August for some student developers to contribute towards some related goals.
It's not guaranteed yet, but getting in touch never hurts!
