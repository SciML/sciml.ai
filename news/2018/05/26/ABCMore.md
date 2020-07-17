@def rss_pubdate = Date(2018,5 ,26 )
@def rss = """ DifferentialEquations.jl 4.5: ABC, Adaptive Multistep, Maximum A Posteriori """
@def published = " 26 May 2018 "
@def title = " DifferentialEquations.jl 4.5: ABC, Adaptive Multistep, Maximum A Posteriori "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

Once again we stayed true to form and didn't solve the problems in the
development list but adding a ton of new features anyways. Now that Google
Summer of Code (GSoC) is in full force, a lot of these updates are due to
our very awesome and productive students. Here's what we got.

## Approximate Bayesian Computation (ABC)

Marc Williams (@marcjwilliams1) contributed the `abc_inference` function to
DiffEqBayes.jl which utilizes approximate Bayesian computation (also known as
ABC) from [ApproxBayes.jl](https://github.com/marcjwilliams1/ApproxBayes.jl)
to perform the estimation of parameter posteriors. Compared to standard
Bayesian methods, ABC is computationally cheaper and faster at the cost of
making some approximations (the name is quite appropriate). For models with lots
of parameters where you have a good prior guess for the posterior parameter
point estimates, ABC can be a great way to get posterior distributions.

## Maximum A Posteriori Estimation

GSoC student Vaibhav Dixit (@Vaibhavdixit02) added maximum a posteriori estimation
to our existing parameter estimation routines in DiffEqParamEstim.jl. Now these
optimization-based methods can take into account prior distributions which can
help global optimizers stay in the right parameter ranges and improve fitting.
All it takes is passing an optional prior distribution to any of the existing
methods, so it's very easy to add it your current work!

## Multiple shooting objective

In other parameter estimation news, Vaibhav Dixit (@Vaibhavdixit02) added the
`multiple_shooting_objective` which, like the `build_loss_objective` method,
allows for fitting ODE results to any loss function. However, multiple shooting
methods are naturally more robust by solving simultaneously from many different
time points.

## DynamicSS Solver

For `SteadyStateProblem` types, a new solver `DynamicSS` has been added that
utilizes the ODE solvers to find steady states. It builds in a callback that
will halt when the derivative is sufficiently small, allowing it to be a
robust automated steady-state finding machine.

## Unified retcode handling

Takafumi Arakaki (@tkf) performed an awesome refactoring in the DiffEq core
which allows all of the DiffEq solvers to utilize the same retcode handling
code. This means that we have unified exit warning messages and the resulting
retcodes. Each package should act the same for the common retcodes.

## Fixed order variable time step Adams methods

Shubham Maddhashiya (@sipah00) contributed a variety of new adaptive
Adams-Bashforth and Adams-Bashforth-Moulton methods. These methods are fixed
order 3-5 which minimize function evaluations and are designed for large
non-stiff ODE discretizations. They utilize Runge-Kutta methods to hotstart the
Adams methods, making them more efficient than variable order versions when only
lower orders are required or when there are a lot of events.

## ABDF2

Yingbo Ma (@YingboMa) contributed `ABDF2`, an adaptive implementation of the
Backwards Differentiation Formula (BDF) order 2 method. BDF schemes are the
go-to choice for PDE discretizations since they only have one step (one
nonlinear equation to solve) for each time step, minimizing the number of
function calculations. Unlike adaptive order BDF discretizations, this adaptive
BDF2 is A-B-L-stable, meaning that it should be stable for any stiff ODE that is
thrown at it. This makes it a nice testing or anchor method: one that can always
be relied on to do well-enough.

# In development

A lot of the next developments will come from our GSoC students. Here's a list
of things we are aiming for:

- `SABDF2`, which is a strong order 0.5 adaptive BDF2 implementation for
  stochastic differential equations which is order 2 for small noise SDEs.
  This will be the first implicit adaptive integrator for small noise SDEs and
  will be a great choice for SPDEs.

- Adaptive order Adams-Bashforth-Moulton. This will be JuliaDiffEq's native
  Julia implementation of an AOAT Adams method. It will utilize variable
  coefficient formulas like Shampine's `ddeabm` which has been shown in sources
  like Hairer's Solving Ordinary Differential Equations to be more efficient
  than the more standard `CVODE_Adams` since it's more easily able to utilize
  higher order steps.

- Adaptive order Nordsieck methods. Nordsieck methods are the special
  implementation multistep methods which Sundials' CVODE uses. This
  implementation utilizes a fixed leading coefficient which makes it more
  optimized for solving large PDE discretizations since it can re-use the
  Jacobian between steps while adapting time steps. Other problem solving
  environments such as MATLAB and SciPy utilize
  [quasi-fixed timesteps](https://www.mathworks.com/help/pdf_doc/otherdocs/ode_suite.pdf)
  to get a similar benefit, but this has the added cost of fixing time steps
  for many steps which reduces stepping efficiency. The reason this is done
  is simple: Nordsieck implementations are hard which is why the only existing
  ones (that I know of) are EPISODE and VODE/CVODE (and VODE is an adaption of
  EPISODE, so it's really one code!). However, our GSoC student has been hammering
  away at this for months and we've made great progress, with the fixed order
  Adams Nordsieck method having already merged. The last step is to figure out
  order adaptivity and then the translation to BDF coefficients is trivial. While
  this methodology isn't as optimized for non-stiff ODEs in its Adams form, this
  BDF form will likely be the new goto method in DiffEq for large stiff PDE
  discretizations.

- Until exponential integrators! Xingjian Guo (@MSeeker1340) has been doing an
  extensive study of the numerical implementations of `expmv` and `phimv` for
  building efficient exponential integrators. If you're curious, you can
  [read up on some of the discussions](https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl/pull/355#issuecomment-391169404) and [here](https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl/issues/366#issuecomment-392165923). He is quite close to having both efficient and numerically stable methods
  for lazy adaptive Krylov `expmv` and `phimv` which will allow for fast c
  alculations of exponential integrators without computing full matrix
  exponentials. This will then be used in the current exponential integrator
  implementations, along with the adaptive high order EPIRK methods. This class
  of integrators will be one to keep aware of if you're interested in
  time-dependent PDEs. It will be great to compare and contrast between these
  methods and BDF integrators in these problems.

- Yiannis Simillides (@ysimillides) keeps making improvements to FEniCS.jl. At
  this part a large portion (a majority?) of the tutorial works from Julia.

- Vaibhav Dixit (@Vaibhavdixit02) finished most of the parameter estimation
  methods on our wish list, so he's onto implementing global sensitivity
  analysis methods, starting with the Morris method and then going on to
  the eFAST and Sobol method.

- Mikhail Vaganov (@Mikhail-Vaganov) is making good progress on his N-body
  modeling language. This will make it easy to utilize DiffEq as a backend
  for molecular dynamics simulation. Follow the progress in DiffEqPhysics.jl

And here's a quick view of the rest of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX methods
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface

# Projects

Are you a student who is interested in working on differential equations software
and modeling? If so, please get in touch with us since we may have some funding
after August for some student developers to contribute towards some related goals.
It's not guaranteed yet, but getting in touch never hurts!
