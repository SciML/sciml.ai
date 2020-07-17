@def rss_pubdate = Date(2018,4,15)
@def rss = """ DifferentialEquations.jl 4.4: Enhanced Stability and IMEX SDE Integrators """
@def published = "15 April 2018"
@def title = " DifferentialEquations.jl 4.4: Enhanced Stability and IMEX SDE Integrators "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

These are features long hinted at. The
[Arxiv paper](https://arxiv.org/abs/1804.04344) is finally up and the new
methods from that paper are the release. In this paper I wanted to "complete"
the methods for additive noise and attempt to start enhancing the methods for
diagonal noise SDEs. Thus while it focuses on a constrained form of noise, this
is a form of noise present in a lot of models and, by using the constrained form,
allows for extremely optimized methods. See the
[updated SDE solvers documentation](https://docs.juliadiffeq.org/latest/solvers/sde_solve)
for details on the new methods. Here's what's up!

## Stability-Enhanced High Order Explicit Stochastic Runge-Kutta Methods for Additive/Diagonal Noise

In the paper we formulate a global optimization problem and utilize Julia's
JuMP with GPUs in order to derive coefficients for high order high stability
adaptive integrators for both additive and diagonal noise stochastic differential
equations (yeah, there's a little bit of the signularity going on there, using
numerical algorithms in Julia to derive numerical algorithms in Julia...). The
resulting methods have 2x-5x larger stability regions along the drift axis (see
paper for details), but have even more dramatic increases in efficiency and
accuracy. This has a noticable user-experience change as well since these methods
are stable at extremely high choices of (strong) tolerance, meaning they give
a lot more flexibility than before. Here's a figure showing how the new `SOSRA`
method looks at high tolerances (low accuracy) compared to the previous methods:

![SOSRA tolerance](https://user-images.githubusercontent.com/1814174/38661858-1f245422-3de7-11e8-8fab-1734e0dc8611.PNG)

The new methods of this type are:

- `SOSRA`
- `SOSRA2`
- `SOSRI`
- `SOSRI2`

`SOSRA` and `SOSRI` are now the recommended methods for additive and diagonal
noise respectively.

![Benchmarks](https://user-images.githubusercontent.com/1814174/38661859-1f3f912e-3de7-11e8-9c3d-5e6aaaf5afff.PNG)

## High Order Adaptive L-Stable Implicit Integrator for Stiff SDEs with Additive Noise

In the paper, two L-stable implicit integrators for additive noise SDEs are derived.
Right now we only offer an implementation for the latter, the `SKenCarp` method.
On the Van Der Pol equation displayed above, the benchmarks are phenomenal for
this new method:

![SKenCarp](https://user-images.githubusercontent.com/1814174/38661857-1f0700ca-3de7-11e8-8db4-55d47d23392b.PNG)

So while it's restricted in the types of problems it can solve, it can do very
well in this class. In the paper we show how to translate any multiplicative
or affine noise SDE into additive noise SDEs in order to better make use of this
method. From testing I would make the claim that this method "performs as good
as implicit integrators for ODEs" in the sense of reliability and almost in
timing. My hope for the future is to try and replicate this strategy for diagonal
noise SDEs, but it will take some time to derive exactly how such extensions
can work.

## SDAE Handling

`SKenCarp` can handle stochastic differential-algebraic equations in mass matrix
form. It's a very special form which applies the constraints deterministically,
meaning that while it's a stochastic equation you still have conditions like
energy conservation exact at every step instead of fluctuating.

## Adaptive IMEX Method for SDEs

The `KenCarp` methods in OrdinaryDiffEq.jl are IMEX methods, meaning that you can
designate that only part of your equation is implicit and leave another part
explicit for more efficiency in the Newton iterations. The `SKenCarp` methods are
derived from the same lineage. While there is no theoretical guarantee of their
success, the paper shows numerical evidence that they can achieve strong order
1.5 (and given the conditions the method satisfies, it should always converge
but maybe have possible order loss to strong order 1.0 on some equations, but
that would require further research). Since the method seems to work well in
practice we are offering the IMEX form as part of DiffEq.

## Stiffness Detection and Automatic Switching for SDEs

Last time we released automatic stiffness detection and switching for SDEs.
The same theory can be applied to the new integrators. `SOSRI2` and `SOSRA2`
have built in maximal eigenvalue estimates and a similar strategy to the
deterministic case can be employed to automatically switch between explicit and
implicit solvers.

# The Future of This Work

I want to continue down this path by developing stability-enhanced explicit
methods for commutative and general non-diagonal noise, along with L-stable
implicit methods for these cases plus the diagonal case. I would like to get
some stochastic Rosenbrock methods, along with the SROCK methods, to really
flesh out the StochasticDiffEq.jl offering for stiff SDEs and offer a full
benchmark analysis of the field.

# In development

Here's a quick view of the rest of our "in development" list:

- Preconditioner choices for Sundials methods
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support outside of Sundials
- IMEX methods
- Function input for initial conditions and time span (`u0(p,t0)`)
- LSODA integrator interface
