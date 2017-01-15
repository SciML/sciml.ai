---
layout: page
title: Citing
navigation_weight: 1
sitemap:
    priority: 1.0
    changefreq: weekly
    lastmod: 2014-09-07T16:31:30+05:30
---

# Citing

To credit the JuliaDiffEq software, please star the repositories that you would
like to support. If you use JuliaDiffEq software as part of your research, teaching, or other activities,
we would be grateful if you could cite our work. Since JuliaDiffEq is a collection of individual
modules, in order to give proper credit please cite **each related component**.

To give proper academic credit, all software should be cited.
[See this link for more information on citing software](http://openresearchsoftware.metajnl.com/about/#q11).
Listed below are relevant publications which should be cited upon usage.
For software which do not have publications, recommended citations are also
included. If you have any questions about citations, please feel free to
[file an issue at the Github repository](https://github.com/JuliaDiffEq/DifferentialEquations.jl/issues)
or ask in the [Gitter channel](https://gitter.im/JuliaDiffEq/Lobby). If any of
this information needs to be updated, please open an issue or pull request
[at the website repository](https://github.com/JuliaDiffEq/juliadiffeq.github.io).

## JuliaDiffEq Publications

#### DifferentialEquations.jl

- Rackauckas C., Nie Q., (2017) DifferentialEquations.jl - A Performant and Feature-Rich
  Ecosystem for Solving Differential Equations in Julia. Journal of Open Research Software.
  Submitted.

#### StochasticDiffEq.jl

- Rackauckas C. Nie Q., (2016) Adaptive Methods for Stochastic Differential Equations
  via Natural Embeddings and Rejection Sampling with Memory. Discrete and Continuous
  Dynamical Systems - Series B. Accepted December 2016.

## Additional Recommended Software Citations

#### DASKR.jl

- P. N. Brown, A. C. Hindmarsh, and L. R. Petzold, Using Krylov
  Methods in the Solution of Large-Scale Differential-Algebraic
  Systems, SIAM J. Sci. Comp., 15 (1994), pp. 1467-1488.

- P. N. Brown, A. C. Hindmarsh, and L. R. Petzold, Consistent
  Initial Condition Calculation for Differential-Algebraic
  Systems, SIAM J. Sci. Comp. 19 (1998), pp. 1495-1512.

#### DASSL.jl

- DASSL.jl. Date of access. Current version. https://github.com/JuliaDiffEq/DASSL.jl.


#### DelayDiffEq.jl

- DelayDiffEq.jl. Date of access. Current version. https://github.com/JuliaDiffEq/DelayDiffEq.jl.

#### LSODA.jl

- Alan Hindmarsh, ODEPACK, a Systematized Collection of ODE Solvers,
  in Scientific Computing, edited by Robert Stepleman, Elsevier, 1983,
  ISBN13: 978-0444866073, LC: Q172.S35.

- K Radhakrishnan, Alan Hindmarsh, Description and Use of LSODE, the Livermore
  Solver for Ordinary Differential Equations, Technical report UCRL-ID-113855,
  Lawrence Livermore National Laboratory, December 1993.

#### ODE.jl

- ODE.jl. Date of access. Current version. https://github.com/JuliaDiffEq/ODE.jl.

#### OrdinaryDiffEq.jl

- OrdinaryDiffEq.jl. Date of access. Current version. https://github.com/JuliaDiffEq/OrdinaryDiffEq.jl.

#### ParameterizedFunctions.jl

- ParameterizedFunctions.jl. Date of access. Current version. https://github.com/JuliaDiffEq/ParameterizedFunctions.jl.

#### StochasticDiffEq.jl

- StochasticDiffEq.jl. Date of access. Current version. https://github.com/JuliaDiffEq/StochasticDiffEq.jl.

#### Sundials.jl

- A. C. Hindmarsh, P. N. Brown, K. E. Grant, S. L. Lee, R. Serban, D. E. Shumaker,
  and C. S. Woodward, “SUNDIALS: Suite of Nonlinear and Differential/Algebraic Equation Solvers,”
  ACM Transactions on Mathematical Software, 31(3), pp. 363-396, 2005. Also available as
  LLNL technical report UCRL-JP-200037.

#### SymEngine.jl (if the `ode_def` macro is used)

- SymEngine. Date of access. Current version. https://github.com/symengine/symengine.

## Algorithm and Addon Citations

Many of the algorithms which are included as part of this ecosystem of software
packages originated as part of academic research. If you know which algorithms
were used in your work, please use this as a reference for determining additional
citations.

### Ordinary Differential Equations

#### BS3, ode23

- Bogacki, Przemyslaw; Shampine, Lawrence F. (1989), "A 3(2) pair of Runge–Kutta formulas",
  Applied Mathematics Letters, 2 (4): 321–325, doi:10.1016/0893-9659(89)90079-7

#### Tsit5

- Tsitouras Ch., "Runge–Kutta pairs of order 5(4) satisfying only the first column
  simplifying assumption", Computers & Mathematics with Applications, 62 (2): 770-775,
  dx.doi.org/10.1016/j.camwa.2011.06.002

#### DP5, dopri5, ode45

- Dormand, J. R.; Prince, P. J. (1980), "A family of embedded Runge-Kutta formulae",
  Journal of Computational and Applied Mathematics, 6 (1): 19–26, doi:10.1016/0771-050X(80)90013-3

#### BS5

- Bogacki P. and Shampine L.F., (1996), "An Efficient Runge-Kutta (4,5) Pair",
  Computers and Mathematics with Applications, 32 (6): 15-28

#### Verner Methods (Vern6, Vern7, Vern8, Vern9)

- J.H. Verner, Numerically optimal Runge--Kutta pairs with interpolants.
  Numerical Algorithms, 53, (2010) pp. 383--396. 10.1007/s11075-009-9290-3

#### TanYam7

- Tanaka M., Muramatsu S., Yamashita S., (1992), "On the Optimization of Some Nine-Stage
  Seventh-order Runge-Kutta Method", Information Processing Society of Japan,
  33 (12), pp. 1512-1526.

#### DP8, dop853, odex, seulex, rodas,

- E. Hairer, S.P. Norsett, G. Wanner, (1993) Solving Ordinary Differential Equations I.
  Nonstiff Problems. 2nd Edition. Springer Series in Computational Mathematics,
  Springer-Verlag.

#### radau, radu5

- E. Hairer and G. Wanner, (1999) Stiff differential equations solved by Radau methods,
  Journal of Computational and Applied Mathematics, 111 (1-2), pp. 93-111.

#### Rosenbrock23, Rosenbrock32, ode23s, ModifiedRosenbrockIntegrator

- Shampine L.F. and Reichelt M., (1997) The MATLAB ODE Suite, SIAM Journal of
Scientific Computing, 18 (1), pp. 1-22.

#### Feagin10, Feagin12, Feagin14

- Feagin, T., “High-order Explicit Runge-Kutta Methods Using M-Symmetry,”
  Neural, Parallel & Scientific Computations, Vol. 20, No. 4,
  December 2012, pp. 437-458

- Feagin, T., “An Explicit Runge-Kutta Method of Order Fourteen,” Numerical
  Algorithms, 2009

### Stochastic Differential Equations

#### RK-Mil

- Kloeden, P.E., Platen, E., Numerical Solution of Stochastic Differential Equations.
  Springer. Berlin Heidelberg (2011)

#### SRI, SRIW1, SRA, SRA1

- Rößler A., Runge–Kutta Methods for the Strong Approximation of Solutions of
  Stochastic Differential Equations, SIAM J. Numer. Anal., 48 (3), pp. 922–952.
  DOI:10.1137/09076636X

#### Adaptive Timestepping

- Rackauckas C. Nie Q., (2016) Adaptive Methods for Stochastic Differential Equations
  via Natural Embeddings and Rejection Sampling with Memory. Discrete and Continuous
  Dynamical Systems - Series B. Accepted December 2016.

### Addons

#### ProbInts (Uncertainty Quantification)

- Conrad P., Girolami M., Särkkä S., Stuart A., Zygalakis. K, Probability
  Measures for Numerical Solutions of Differential Equations, arXiv:1506.04592
