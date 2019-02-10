---
layout: page
title: Citing
navigation_weight: 1
sitemap:
    priority: 1.0
    changefreq: monthly
    lastmod: 2017-09-09T16:31:30+05:30
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

- Rackauckas, C. & Nie, Q., (2017). DifferentialEquations.jl – A Performant and
  Feature-Rich Ecosystem for Solving Differential Equations in Julia. Journal of
  Open Research Software. 5(1), p.15. DOI: http://doi.org/10.5334/jors.151

#### StochasticDiffEq.jl

- Rackauckas C., Nie Q., (2016). Adaptive Methods for Stochastic Differential Equations
  via Natural Embeddings and Rejection Sampling with Memory. Discrete and Continuous
  Dynamical Systems - Series B, 22(7), pp. 2731-2761. doi:10.3934/dcdsb.2017133

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

- Linda Petzold, Automatic Selection of Methods for Solving Stiff and Nonstiff
  Systems of  Ordinary Differential Equations, SIAM J. Sci. and Stat. Comput.,
  4(1), 136–148.

- LSODA.jl. Date of access. Current version. https://github.com/rveltz/LSODA.jl.

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

## Algorithm Citations

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

#### RK4 Residual Control

- L. F. Shampine. 2005. Solving ODEs and DDEs with residual control. Appl. Numer.
  Math. 52, 1 (January 2005), 113-127. DOI=http://dx.doi.org/10.1016/j.apnum.2004.07.003

#### OwrenZen3, OwrenZen4, OwrenZen5

- Brynjulf Owren and Marino Zennaro. 1992. Derivation of efficient, continuous,
  explicit Runge-Kutta methods. SIAM J. Sci. Stat. Comput. 13, 6 (November 1992),
  1488-1501. DOI=http://dx.doi.org/10.1137/0913084

#### radau, radu5

- E. Hairer and G. Wanner, (1999) Stiff differential equations solved by Radau methods,
  Journal of Computational and Applied Mathematics, 111 (1-2), pp. 93-111.

#### Rosenbrock23, Rosenbrock32, ode23s, ModifiedRosenbrockIntegrator

- Shampine L.F. and Reichelt M., (1997) The MATLAB ODE Suite, SIAM Journal of
Scientific Computing, 18 (1), pp. 1-22.

#### ROS3P

- Lang, J. & Verwer, ROS3P—An Accurate Third-Order Rosenbrock Solver Designed for
  Parabolic Problems J. BIT Numerical Mathematics (2001) 41: 731. doi:10.1023/A:1021900219772

#### Rodas3, Ros4LStab, Rodas4, Rodas42

- E. Hairer, G. Wanner, Solving ordinary differential equations II, stiff and
  differential-algebraic problems. Computational mathematics (2nd revised ed.), Springer (1996)

#### RosShamp4

- L. F. Shampine, Implementation of Rosenbrock Methods, ACM Transactions on
  Mathematical Software (TOMS), 8: 2, 93-113. doi:10.1145/355993.355994

#### Veldd4, Velds4

- van Veldhuizen, D-stability and Kaps-Rentrop-methods, M. Computing (1984) 32: 229.
  doi:10.1007/BF02243574

#### GRK4T, GRK4A

- Kaps, P. & Rentrop, Generalized Runge-Kutta methods of order four with stepsize control
  for stiff ordinary differential equations. P. Numer. Math. (1979) 33: 55. doi:10.1007/BF01396495

#### Rodas4P

- Steinebach G. Order-reduction of ROW-methods for DAEs and method of lines
  applications. Preprint-Nr. 1741, FB Mathematik, TH Darmstadt; 1995.

#### Rodas5

- Di Marzo G. RODAS5(4) – Méthodes de Rosenbrock d’ordre 5(4) adaptées aux problemes
différentiels-algébriques. MSc mathematics thesis, Faculty of Science,
University of Geneva, Switzerland.

#### Trapezoid (Adaptivity)

- Andre Vladimirescu. 1994. The Spice Book. John Wiley & Sons, Inc., New York,
  NY, USA.

#### TRBDF2

- M.E. Hosea, L.F. Shampine, Analysis and implementation of TR-BDF2, Applied
  Numerical Mathematics, Volume 20, Issue 1, 1996, Pages 21-37, ISSN 0168-9274,
  http://dx.doi.org/10.1016/0168-9274(95)00115-8.

#### SDIRK2, Cash4

- A. C. Hindmarsh, P. N. Brown, K. E. Grant, S. L. Lee, R. Serban, D. E. Shumaker,
  and C. S. Woodward, “SUNDIALS: Suite of Nonlinear and Differential/Algebraic
  Equation Solvers,” ACM Transactions on Mathematical Software, 31(3), pp. 363-396,
  2005. Also available as LLNL technical report UCRL-JP-200037.

#### Kvaerno3, Kvaerno4, Kvaerno5

- Kværnø, A., Singly Diagonally Implicit Runge–Kutta Methods with an Explicit
  First Stage, BIT Numerical Mathematics (2004) 44: 489.
  https://doi.org/10.1023/B:BITN.0000046811.70614.38

#### Hairer4, Hairer42

- E. Hairer, G. Wanner, Solving ordinary differential equations II, stiff and
  differential-algebraic problems. Computational mathematics (2nd revised ed.),
  Springer (1996)

#### KenCarp3, KenCarp4, KenCarp5

- Christopher A. Kennedy and Mark H. Carpenter. 2003. Additive Runge-Kutta schemes
  for convection-diffusion-reaction equations. Appl. Numer. Math. 44, 1-2
  (January 2003), 139-181. DOI=http://dx.doi.org/10.1016/S0168-9274(02)00138-1

#### Nystrom4, Nystrom4VelocityIndependent, Nystrom5VelocityIndependent

- E. Hairer, S.P. Norsett, G. Wanner, (1993) Solving Ordinary Differential Equations I.
  Nonstiff Problems. 2nd Edition. Springer Series in Computational Mathematics,
  Springer-Verlag.

#### ERKN4

- M. A. Demba, N. Senu, F. Ismail "An embedded 4(3) pair of explicit trigonometrically-fitted Runge-Kutta-Nystrom method for solving periodic initial value problems" Applied Mathematical Sciences, Vol. 11, 2017, no. 17, 819-838, https://doi.org/10.12988/ams.2017.7262

#### ERKN5

- Demba, Musa & Senu, Norazak & Ismail, Fudziah. (2016). A 5(4) Embedded Pair of Explicit Trigonometrically-Fitted Runge–Kutta–Nyström Methods for the Numerical Solution of Oscillatory Initial Value Problems. Mathematical and Computational Applications. 21. . 10.3390/mca21040046.

#### IRKN3, IRKN4

- Numerical Solution of Second-Order Ordinary Differential Equations by Improved
  Runge-Kutta Nystrom Method, International Science Index, Mathematical and
  Computational Sciences Vol:6, No:9, 2012 waset.org/Publication/1175

#### DPRKN6

- J.R. Dormand, P.J. Prince, Runge-Kutta-Nystrom triples, Computers & Mathematics
  with Applications, Volume 13, Issue 12, 1987, Pages 937-949, ISSN 0898-1221,
  http://dx.doi.org/10.1016/0898-1221(87)90066-6.

#### DPRKN8, DPRKN12

- J. R. DORMAND, M. E. A. EL-MIKKAWY, P. J. PRINCE; High-Order Embedded
  Runge-Kutta-Nystrom Formulae, IMA Journal of Numerical Analysis, Volume 7,
  Issue 4, 1 October 1987, Pages 423–430, https://doi.org/10.1093/imanum/7.4.423

#### VelocityVerlet, VerletLeapfrog, PseudoVerletLeapfrog

- Verlet, Loup (1967). "Computer "Experiments" on Classical Fluids. I.
  Thermodynamical Properties of Lennard−Jones Molecules". Physical Review.
  159: 98–103. doi:10.1103/PhysRev.159.98

- Etienne Forest, Ronald D. Ruth, Fourth-order symplectic integration, Physica D:
  Nonlinear Phenomena, Volume 43, Issue 1, 1990, Pages 105-117, ISSN 0167-2789,
  http://dx.doi.org/10.1016/0167-2789(90)90019-L.

#### Ruth3

- Ruth, Ronald D. (August 1983). "A Canonical Integration Technique". Nuclear
  Science, IEEE Trans. on. NS-30 (4): 2669–2671. Bibcode:1983ITNS...30.2669R.
  doi:10.1109/TNS.1983.4332919

- Etienne Forest, Ronald D. Ruth, Fourth-order symplectic integration, Physica D:
  Nonlinear Phenomena, Volume 43, Issue 1, 1990, Pages 105-117, ISSN 0167-2789,
  http://dx.doi.org/10.1016/0167-2789(90)90019-L.

#### McAte2, McAte3, McAte4, McAte42, McAte5

- R. I. McLachlan and P. Atela, The accuracy of symplectic integrators,
  Nonlinearity 5 (1992), 541-562.

- Stephen K. Gray, Donald W. Noid and Bobby G. Sumpter, Symplectic integrators for
  large scale molecular dynamics simulations: A comparison of several explicit methods
  The Journal of Chemical Physics 101, 4062 (1994); doi: http://dx.doi.org/10.1063/1.467523

#### CandyRoz4

- Candy, J.; Rozmus, W (1991). "A Symplectic Integration Algorithm for Separable
  Hamiltonian Functions". J. Comput. Phys. 92: 230. Bibcode:1991JCoPh..92..230C.
  doi:10.1016/0021-9991(91)90299-Z

#### CalvoSanz4

- Stephen K. Gray, Donald W. Noid and Bobby G. Sumpter, Symplectic integrators for
  large scale molecular dynamics simulations: A comparison of several explicit methods
  The Journal of Chemical Physics 101, 4062 (1994); doi: http://dx.doi.org/10.1063/1.467523

-  M. P. Calvo & J. M. Sanz-Serna, Symplectic numerical methods for Hamiltonian
   problems, Int. J. Mod. Phys. C 4(1993), 617-634.

#### KahanLi6, KahanLi8

- Kahan, W. & Li, Composition constants for raising the orders of unconventional schemes for ordinary
  differential equations, Mathematics of Computation. 66, 219, p. 1089-1099 11 p.

#### Yoshida6

- Yoshida, H. (1990). "Construction of higher order symplectic integrators". Phys.
  Lett. A. 150 (5–7): 262. Bibcode:1990PhLA..150..262Y. doi:10.1016/0375-9601(90)90092-3

#### McAte8

- R. I. McLachlan, On the numerical integration of ordinary differential equations
  by symmetric composition methods, SIAM J. Sci. Comp. 16, (1995), 151-168.

##### SofSpa10

- Mark Sofroniou & Giulia Spaletta, Derivation of symmetric composition constants
  for symmetric integrators, Optimization Methods and Software Vol. 20 ,
  4-5,2005

#### Feagin10, Feagin12, Feagin14

- Feagin, T., “High-order Explicit Runge-Kutta Methods Using M-Symmetry,”
  Neural, Parallel & Scientific Computations, Vol. 20, No. 4,
  December 2012, pp. 437-458

- Feagin, T., “An Explicit Runge-Kutta Method of Order Fourteen,” Numerical
  Algorithms, 2009

#### CarpenterKennedy2N54

- M.H. Carpenter, C.A. Kennedy, Fourth-Order Kutta Schemes, NASA Langley Research
  Center, Hampton, Virginia 23681-0001, 1994.

#### Strong Stability Preserving (SSP) Runge-Kutta Methods: General Information, SSPRK432, SSPRK932

- Gottlieb, Sigal, David I. Ketcheson, and Chi-Wang Shu. Strong stability
  preserving Runge-Kutta and multistep time discretizations. World Scientific,
  2011.

#### SSPRK22, SSPRK33

- Shu, Chi-Wang, and Stanley Osher. "Efficient implementation of essentially
  non-oscillatory shock-capturing schemes." Journal of Computational Physics
  77.2 (1988): 439-471.

#### SSPRK53, SSPRK63, SSPRK73, SSPRK83, SSPRK54

- Ruuth, Steven. "Global optimization of explicit strong-stability-preserving
  Runge-Kutta methods." Mathematics of Computation 75.253 (2006): 183-207.

#### SSPRK53_2N1, SSPRK53_2N2

- Higueras and T. Roldán. "New third order low-storage SSP explicit Runge–Kutta methods". arXiv:1809.04807v1.

#### SSPRK104

- Ketcheson, David I. "Highly efficient strong stability-preserving Runge–Kutta
  methods with low-storage implementations." SIAM Journal on Scientific
  Computing 30.4 (2008): 2113-2136.

#### SSP Dense Output

- Ketcheson, David I., et al. "Dense output for strong stability preserving
  Runge–Kutta methods." Journal of Scientific Computing 71.3 (2017): 944-958.

#### LawsonEuler, NorsettEuler  

- Hochbruck, Marlis, and Alexander Ostermann. “Exponential Integrators.” Acta
  Numerica 19 (2010): 209–86. doi:10.1017/S0962492910000048.

#### GenericIIF1, GenericIIF2

- Q. Nie, Y. Zhang and R. Zhao. Efficient Semi-implicit Schemes for Stiff Systems.
  Journal of Computational Physics, 214, pp 521-537, 2006.

#### ORK25-6

- Matteo Bernardini, Sergio Pirozzoli. A General Strategy for the Optimization of
  Runge-Kutta Schemes for Wave Propagation Phenomena. Journal of Computational Physics,
  228(11), pp 4182-4199, 2009. doi: https://doi.org/10.1016/j.jcp.2009.02.032

#### RK46-NL

- Julien Berland, Christophe Bogey, Christophe Bailly. Low-Dissipation and Low-Dispersion
  Fourth-Order Runge-Kutta Algorithm. Computers & Fluids, 35(10), pp 1459-1463, 2006.
  doi: https://doi.org/10.1016/j.compfluid.2005.04.003

#### CFRLDDRK64

- M. Calvo, J. M. Franco, L. Randez. A New Minimum Storage Runge–Kutta Scheme
  for Computational Acoustics. Journal of Computational Physics, 201, pp 1-12, 2004.
  doi: https://doi.org/10.1016/j.jcp.2004.05.012

#### HSLDDRK64

- D. Stanescu, W. G. Habashi. 2N-Storage Low Dissipation and Dispersion Runge-Kutta Schemes for
  Computational Acoustics. Journal of Computational Physics, 143(2), pp 674-681, 1998. doi:
  https://doi.org/10.1006/jcph.1998.5986

#### NDBLSRK124, NDBLSRK134, NDBLSRK144

- Jens Niegemann, Richard Diehl, Kurt Busch. Efficient Low-Storage Runge–Kutta Schemes with
  Optimized Stability Regions. Journal of Computational Physics, 231, pp 364-372, 2012.
  doi: https://doi.org/10.1016/j.jcp.2011.09.003

#### RKC

- B. P. Sommeijer, L. F. Shampine, J. G. Verwer. RKC: An Explicit Solver for Parabolic PDEs,
  Journal of Computational and Applied Mathematics, 88(2), pp 315-326, 1998. doi:
  https://doi.org/10.1016/S0377-0427(97)00219-7

#### ROCK2

- Assyr Abdulle, Alexei A. Medovikov. Second Order Chebyshev Methods based on Orthogonal Polynomials.
  Numerische Mathematik, 90 (1), pp 1-18, 2001. doi: http://dx.doi.org/10.1007/s002110100292

#### ROCK4

- Assyr Abdulle. Fourth Order Chebyshev Methods With Recurrence Relation. 2002 Society for
  Industrial and Applied Mathematics Journal on Scientific Computing, 23(6), pp 2041-2054, 2001.
  doi: https://doi.org/10.1137/S1064827500379549

#### TSLDDRK74

- Kostas Tselios, T. E. Simos. Optimized Runge–Kutta Methods with Minimal Dispersion and Dissipation
  for Problems arising from Computational Ccoustics. Physics Letters A, 393(1-2), pp 38-47, 2007.
  doi: https://doi.org/10.1016/j.physleta.2006.10.072

#### DGLDDRK73_C, DGLDDRK84_C, DGLDDRK84_F

- T. Toulorge, W. Desmet. Optimal Runge–Kutta Schemes for Discontinuous Galerkin Space
  Discretizations Applied to Wave Propagation Problems. Journal of Computational Physics, 231(4),
  pp 2067-2091, 2012. doi: https://doi.org/10.1016/j.jcp.2011.11.024

#### ParsaniKetchesonDeconinck3S94, ParsaniKetchesonDeconinck3S184, ParsaniKetchesonDeconinck3S105, ParsaniKetchesonDeconinck3S205

- T. Toulorge, W. Desmet. Optimized Explicit Runge-Kutta Schemes for the Spectral Difference
  Method Applied to Wave Propagation Problems. 2013 Society for Industrial and Applied
  Mathematics Journal on Scientific Computing, 35(2), pp A957-A986, 2013. doi:
  https://doi.org/10.1137/120885899

### Delay Differential Equations

#### State-Dependent Delays

- S. P. Corwin, D. Sarafyan and S. Thompson in "DKLAG6: a code based on continuously imbedded
  sixth-order Runge-Kutta methods for the solution of state-dependent functional differential
  equations", Applied Numerical Mathematics, 1997.

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

## Addon Citations

### Bifurcation Analysis

- Clewley R (2012) Hybrid Models and Biological Model Reduction with PyDSTool.
  PLoS Comput Biol 8(8): e1002628. doi:10.1371/journal.pcbi.1002628

### ProbInts (Uncertainty Quantification)

- Conrad P., Girolami M., Särkkä S., Stuart A., Zygalakis. K, Probability
  Measures for Numerical Solutions of Differential Equations, arXiv:1506.04592

### Manifold Projection Callback

- Ernst Hairer, Christian Lubich, Gerhard Wanner. Geometric Numerical Integration:
  Structure-Preserving Algorithms for Ordinary Differential Equations. Berlin ;
  New York :Springer, 2002.

### PositiveDomain Callback

- Shampine, Lawrence F., Skip Thompson, Jacek Kierzenka and G. D. Byrne.
  “Non-negative solutions of ODEs.” Applied Mathematics and Computation 170
  (2005): 556-569.

### Constant Rate Jump Aggregators

#### Direct

- Gillespie, Daniel T. (1976). A General Method for Numerically Simulating the
  Stochastic Time Evolution of Coupled Chemical Reactions. Journal of
  Computational Physics. 22 (4): 403–434. doi:10.1016/0021-9991(76)90041-3.

### Variable Rate Jumps

- Salis H., Kaznessis Y.,  Accurate hybrid stochastic simulation of a system of
  coupled chemical or biochemical reactions, Journal of Chemical Physics, 122 (5),
  DOI:10.1063/1.1835951

### Split Coupling

 - David F. Anderson, Masanori Koyama; An asymptotic relationship between coupling
   methods for stochastically modeled population processes. IMA J Numer Anal 2015;
   35 (4): 1757-1778. doi: 10.1093/imanum/dru044
