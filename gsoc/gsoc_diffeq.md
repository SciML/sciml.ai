@def title = "SciML Numerical Differential Equations Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Numerical Differential Equations Projects – Google Summer of Code

## Native Julia ODE, SDE, DAE, DDE, and (S)PDE Solvers

The DifferentialEquations.jl ecosystem has an extensive set of state-of-the-art
methods for solving differential equations hosted by the [SciML Scientific Machine
Learning Software Organization](https://sciml.ai/). By mixing native methods and wrapped
methods under the same dispatch system, [DifferentialEquations.jl serves both as a system to deploy and research the most modern efficient methodologies](https://arxiv.org/abs/1807.06430).
While most of the basic methods have been developed and optimized, many newer
methods need high performance implementations and real-world tests of their
efficiency claims. In this project students will be paired with current
researchers in the discipline to get a handle on some of the latest techniques
and build efficient implementations into the \*DiffEq libraries
(OrdinaryDiffEq.jl, StochasticDiffEq.jl, DelayDiffEq.jl). Possible families of
methods to implement are:

@@tight-list
- Implicit-Explicit (IMEX) Runge-Kutta methods ([#2860](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2860), [#2065](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2065), [#728](https://github.com/SciML/OrdinaryDiffEq.jl/issues/728), [#465](https://github.com/SciML/OrdinaryDiffEq.jl/issues/465))
- New high-order explicit Runge-Kutta tableaux ([#2694](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2694), [#2621](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2621))
- Low-storage Runge-Kutta methods for hyperbolic PDEs and DG schemes ([#2903](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2903), [#2035](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2035))
- Positivity-preserving Rosenbrock methods for chemical kinetics ([#2089](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2089), [#1719](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1719))
- DIRK methods of Kennedy and Carpenter ([#1448](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1448))
- Pseudo-symplectic and relaxation Runge-Kutta methods ([#1987](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1987), [#1029](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1029))
- Multi-rate methods and multi-rate extrapolation ([#1195](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1195), [#884](https://github.com/SciML/OrdinaryDiffEq.jl/issues/884), [#961](https://github.com/SciML/OrdinaryDiffEq.jl/issues/961))
- Approximate matrix factorization ([#407](https://github.com/SciML/OrdinaryDiffEq.jl/issues/407))
- Parallel DIRK and parallel Rosenbrock methods ([#789](https://github.com/SciML/OrdinaryDiffEq.jl/issues/789), [#315](https://github.com/SciML/OrdinaryDiffEq.jl/issues/315))
- Parallel-in-time ODE methods ([#962](https://github.com/SciML/OrdinaryDiffEq.jl/issues/962), [#34](https://github.com/SciML/OrdinaryDiffEq.jl/issues/34))
- Boundary value problem (BVP) solvers like MIRK and collocation methods
- Methods for stiff stochastic differential equations
@@

See the full list of [78 open new-algorithm issues](https://github.com/SciML/OrdinaryDiffEq.jl/issues?q=is%3Aissue+state%3Aopen+label%3Anew-algorithm)
for all requested methods.

Many of these methods are the basis of high-efficiency partial differential
equation (PDE) solvers and are thus important to many communities like
computational fluid dynamics, mathematical biology, and quantum mechanics.

This project is good for both software engineers interested in the field of
numerical analysis and those students who are interested in pursuing graduate
research in the field.

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Contributions of production-quality solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Kanav Gupta](https://github.com/kanav99) and [Utkarsh](https://github.com/utkarsh530), [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

## Global Error Estimation and Control for Differential Equations

Standard ODE solvers control only the *local* truncation error at each step, but
users often care about the *global* (accumulated) error at the end of a
simulation. [GlobalDiffEq.jl](https://github.com/SciML/GlobalDiffEq.jl) aims to
provide solvers that estimate and control global error for the
DifferentialEquations.jl common interface. This project would develop practical,
high-performance implementations of several complementary strategies from the
numerical analysis literature:

@@tight-list
- **Adjoint-based global error estimation**: Implement the method of [Cao and Petzold (2004)](https://epubs.siam.org/doi/abs/10.1137/S1064827503420969), which solves an adjoint (backward-in-time) problem to propagate local defect information into a global error estimate, combined with small-sample statistical condition estimation for efficiency.
- **Coupled time-stepping with built-in global error estimates**: Implement the general linear method (GLM) framework of [Constantinescu (2018)](https://arxiv.org/abs/1503.05166), where the global error estimate is propagated forward alongside the numerical solution as a generalization of Zadunaisky's procedure, yielding self-starting explicit schemes akin to Runge-Kutta methods.
- **Specialized Runge-Kutta triples for global error control**: Implement the methods of [Makazaga and Murua (2003)](http://www.ehu.eus/ccwmuura/research/gee2003.pdf) and related schemes that extend the Dormand-Gilmore-Prince family of embedded RK pairs to cheaply produce global error estimates, with demonstrated efficiency gains (e.g. 45% step reduction on the Lorenz system).
- **Asymptotic expansion methods**: Implement the approach of [Shampine (1986)](https://www.sciencedirect.com/science/article/pii/0898122186900325), which exploits the embedded pair infrastructure already present in standard solvers (e.g. Tsit5, DP5) to estimate global error via asymptotic error expansions at essentially no additional function evaluation cost.
- **Jacobian-based global error estimators**: Implement methods from [Berzins (1988)](http://www.sci.utah.edu/publications/Ber1988b/Berzins_JSC1988.pdf) that use Jacobian information to estimate global error propagation.
- **Global error controlled multistep methods**: Implement multistep methods with built-in global error control, extending the classical Adams and BDF families.
@@

The resulting solvers would integrate directly with the SciML ecosystem,
providing users with reliable global error bounds alongside their numerical
solutions. This is particularly important for long-time integration problems in
celestial mechanics, molecular dynamics, and climate modeling where local error
control alone can be insufficient.

**Recommended Skills**: Background knowledge in numerical analysis (particularly
ODE solver theory), familiarity with Runge-Kutta and multistep methods, and
the ability (or eagerness to learn) to write fast Julia code. Some familiarity
with adjoint methods is helpful but not required.

**Expected Results**: Production-quality implementations of two or more global
error estimation strategies in GlobalDiffEq.jl, with benchmarks demonstrating
their accuracy and efficiency on standard test problems.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Stabilized Explicit Methods for Large-Scale Parabolic PDEs

Semi-discretizations of parabolic PDEs (e.g., heat equation, reaction-diffusion
systems) produce mildly stiff ODE systems whose eigenvalues lie along the
negative real axis. Standard explicit methods require impractically small time
steps for stability, while implicit methods require expensive linear solves.
Stabilized explicit methods bridge this gap by using extended stability regions
along the real axis, achieving explicit-method simplicity with near-implicit
stability. OrdinaryDiffEq.jl already has ROCK2 and ROCK4, but many related
methods remain unimplemented:

@@tight-list
- **Runge-Kutta-Chebyshev methods with monotonic stability**: Implement the second-order RKC methods of [Faleichik and Moisa (2026)](https://doi.org/10.1016/j.cam.2025.117061) with monotonic stability polynomials, improving robustness over classical RKC for problems with both diffusion and reaction terms. See [#2908](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2908).
- **Two-step stabilized methods (TSRKC2)**: Implement the two-step Runge-Kutta-Chebyshev methods of [Moisa (2024)](https://doi.org/10.1016/S0377042724001171) which claim to outperform ROCK2 on large problems by exploiting information from the previous step. See [#2616](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2616).
- **Runge-Kutta-Legendre and Runge-Kutta-Gegenbauer methods**: Implement first- and second-order [RKL and RKG methods](https://doi.org/10.1016/j.jcp.2013.08.021) as alternatives to RKC/ROCK with different stability region shapes suited to different problem classes. See [#2775](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2775).
- **Dumka methods**: Implement the [dumka3 and dumka4](http://dumkaland.org/publications/bit98medovikov.pdf) stabilized methods of Medovikov, which use optimal stability polynomials. See [#1650](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1650).
- **IMEX variants of stabilized methods**: Implement IMEX Runge-Kutta-Chebyshev ([#135](https://github.com/SciML/OrdinaryDiffEq.jl/issues/135)) and partitioned IMEX ROCK ([#280](https://github.com/SciML/OrdinaryDiffEq.jl/issues/280)) methods for problems with both stiff diffusion and non-stiff reaction terms.
@@

**Recommended Skills**: Background in numerical analysis, particularly stability
theory of ODE methods. Familiarity with PDE discretizations is helpful.

**Expected Results**: Production-quality implementations of two or more
stabilized explicit methods with benchmarks against ROCK2/ROCK4.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Exponential Integrators

Exponential integrators are a class of methods that exactly solve the linear
part of a semilinear ODE `u' = Lu + N(u)` using the matrix exponential (or
related phi-functions), and only discretize the nonlinear part `N(u)`. This
makes them highly efficient for stiff problems arising from PDE
semi-discretizations where the stiffness comes primarily from the linear
operator. OrdinaryDiffEq.jl has some basic exponential methods, but many
advanced variants remain open:

@@tight-list
- **Sixth-order exponential Runge-Kutta methods**: Implement the high-order ExpRK methods of [Luan and Alhsmy (2023)](https://arxiv.org/abs/2311.08600) for stiff parabolic PDEs, extending the current fourth-order methods. See [#2063](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2063).
- **Robust exponential Runge-Kutta embedded pairs**: Implement the adaptive embedded pairs of [Zoto and Bowman (2023)](https://arxiv.org/abs/2303.12139) for automatic error control in exponential integrators. See [#1914](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1914).
- **Adaptive step size controllers for exponential integrators**: Implement the specialized controllers of [Deka and Einkemmer (2022)](https://doi.org/10.1016/j.camwa.2022.07.011) that account for the specific error structure of exponential methods. See [#1755](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1755).
- **Multi-rate exponential integrators**: Implement methods from [#720](https://github.com/SciML/OrdinaryDiffEq.jl/issues/720) that combine exponential integration with multi-rate time stepping for problems with multiple time scales.
- **Adaptive Krylov exponential integrators (EPIRK)**: Implement adaptive EPIRK methods ([#243](https://github.com/SciML/OrdinaryDiffEq.jl/issues/243)) that use Krylov subspace approximations to the matrix exponential, making exponential integrators practical for large-scale problems.
- **Symplectic exponential Runge-Kutta**: Implement structure-preserving exponential methods ([#352](https://github.com/SciML/OrdinaryDiffEq.jl/issues/352)) for Hamiltonian systems with stiff linear parts.
@@

See [#394](https://github.com/SciML/OrdinaryDiffEq.jl/issues/394) for the full
list of exponential integrators to implement.

**Recommended Skills**: Background in numerical analysis, particularly matrix
functions and Krylov methods. Familiarity with PDE semi-discretizations is
helpful.

**Expected Results**: Production-quality implementations of two or more
exponential integrator families with benchmarks on stiff PDE test problems.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## DAE Solver Methods

Differential-algebraic equations (DAEs) arise naturally in acausal modeling
(ModelingToolkit.jl), circuit simulation, constrained mechanical systems, and
chemical process engineering. While OrdinaryDiffEq.jl has basic DAE support via
BDF and Radau methods, many specialized DAE solvers from the literature remain
unimplemented:

@@tight-list
- **GAMD**: Implement the [Generalized Adams Methods for DAEs](https://archimede.dm.uniba.it/~testset/solvers/gamd.php), a class of multistep methods specifically designed for DAE systems. See [#1542](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1542).
- **BIMD**: Implement the [Blended Implicit Methods for DAEs](https://archimede.dm.uniba.it/~testset/solvers/bimd.php), which combine implicit methods with blending techniques for improved stability on high-index DAEs. See [#1541](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1541).
- **MEBDF**: Implement the [Modified Extended BDF methods](https://doi.org/10.1016/S0898-1221(01)00137-7), which improve upon classical BDF methods by using additional off-step points for better stability. See [#529](https://github.com/SciML/OrdinaryDiffEq.jl/issues/529).
- **Improved Radau methods for DAEs**: Implement the [augmented low-rank Radau IIA](https://arxiv.org/pdf/1302.1037.pdf) approach that reduces the cost of the linear algebra in implicit Runge-Kutta methods ([#622](https://github.com/SciML/OrdinaryDiffEq.jl/issues/622)), and the improved DAE-specific Radau variant ([#527](https://github.com/SciML/OrdinaryDiffEq.jl/issues/527)).
- **Lobatto methods**: Implement the classical [Lobatto IIIA, IIIB, and IIIC collocation schemes](https://github.com/SciML/OrdinaryDiffEq.jl/issues/521), which are important for constrained Hamiltonian systems and index-2 DAEs.
- **BDF order and stability filtering**: Implement [adaptive order and stability filtering](https://arxiv.org/pdf/1810.06670.pdf) for BDF methods to improve robustness on difficult DAE systems. See [#747](https://github.com/SciML/OrdinaryDiffEq.jl/issues/747).
- **GLIMDA and GENDA**: Implement the [general linear method for DAEs](https://edoc.hu-berlin.de/handle/18452/16193) (GLIMDA, [#528](https://github.com/SciML/OrdinaryDiffEq.jl/issues/528)) and the [general ENsemble DAE solver](https://www3.math.tu-berlin.de/multiphysics/Software/GENDA/) (GENDA, [#526](https://github.com/SciML/OrdinaryDiffEq.jl/issues/526)).
@@

**Recommended Skills**: Background in numerical analysis, particularly
differential-algebraic equations and implicit methods. Familiarity with linear
algebra factorizations is helpful.

**Expected Results**: Production-quality implementations of two or more DAE
solver methods, tested against the [DAE test set](https://archimede.dm.uniba.it/~testset/).

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Hard.

## Lie Group and Geometric Integration Methods

Many differential equations arising from physics (rigid body dynamics, quantum
mechanics, robotics) have solutions that evolve on Lie groups or manifolds rather
than in Euclidean space. Lie group integrators preserve this geometric structure,
avoiding drift off the manifold that plagues standard methods.
OrdinaryDiffEq.jl has some basic Lie group integrators, but many methods remain
unimplemented:

@@tight-list
- **Commutator-free Lie group methods**: Implement [commutator-free methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1072) that avoid evaluating nested Lie brackets, making them practical for high-dimensional problems.
- **Commutator-free Magnus methods**: Implement the fourth- and sixth-order [commutator-free Magnus integrators](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1069) for time-dependent linear ODEs on Lie groups.
- **Fer and Cayley expansion methods**: Implement [Fer expansions and Cayley-transform-based integrators](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1068) as alternatives to Magnus methods for time-dependent linear ODEs.
- **Adaptive Magnus schemes**: Implement [embedded Magnus pairs](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1065) for automatic step size control in Magnus integrators.
- **Additional RKMK methods**: Implement higher-order [Runge-Kutta-Munthe-Kaas methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1067) for general ODEs on Lie groups.
- **Operator splitting methods**: Implement higher-order [Strang and symmetrized splitting methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/1063) with composition techniques for problems decomposable into exactly solvable parts.
@@

**Recommended Skills**: Background in differential geometry or Lie group theory
is helpful but not required. Familiarity with numerical ODE methods and the
ability to write Julia code.

**Expected Results**: Production-quality implementations of two or more Lie group
integration methods with tests on rigid body and quantum mechanics problems.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Second-Order ODE and Runge-Kutta-Nystrom Methods

Many physical systems (celestial mechanics, molecular dynamics, structural
vibrations) are naturally described by second-order ODEs `q'' = f(q, q', t)`.
While these can always be converted to first-order systems, specialized
Runge-Kutta-Nystrom (RKN) methods that exploit the second-order structure are
significantly more efficient. OrdinaryDiffEq.jl has some basic RKN methods, but
many advanced variants remain open:

@@tight-list
- **Explicit RKN methods for linear inhomogeneous IVPs**: Implement the methods of [Montijano, Randez, and Calvo (2024)](https://doi.org/10.1016/j.cam.2023.115533) that exploit linearity for improved efficiency. See [#2043](https://github.com/SciML/OrdinaryDiffEq.jl/issues/2043).
- **High-order Numerov-type methods**: Implement the [eighth- and ninth-order explicit Numerov-type methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/866) for second-order problems without first derivatives, widely used in quantum chemistry and wave propagation.
- **SDIRKN methods**: Implement [singly-diagonally-implicit RKN methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/865) for stiff second-order problems.
- **Implicit RKN methods**: Implement [implicit Runge-Kutta-Nystrom methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/112) for stiff oscillatory systems.
- **More explicit RKN methods**: Implement the extensive collection of methods from [Dormand, Prince, Filippi, Sharp, and others](https://github.com/SciML/OrdinaryDiffEq.jl/issues/677) with various order/stage tradeoffs and dense output capabilities.
- **Stoermer extrapolation**: Implement [Stoermer's rule with extrapolation](https://github.com/SciML/OrdinaryDiffEq.jl/issues/332) (the ODEX2 algorithm from Hairer) for high-accuracy second-order problems.
- **Multistep second-order methods**: Implement [Gauss-Jackson, Stormer-Cowell, and Berry-Healy methods](https://github.com/SciML/OrdinaryDiffEq.jl/issues/331) used in satellite orbit propagation.
- **Structure-preserving algorithms for oscillatory ODEs**: Implement methods from the [Springer monograph](https://github.com/SciML/OrdinaryDiffEq.jl/issues/351) on structure-preserving integrators for oscillatory differential equations.
@@

**Recommended Skills**: Background in numerical analysis, particularly Nystrom
methods and symplectic integration. Familiarity with celestial mechanics or
molecular dynamics applications is helpful.

**Expected Results**: Production-quality implementations of two or more
second-order ODE methods with benchmarks on orbital mechanics or molecular
dynamics problems.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

## Performance enhancements for differential equation solvers

Wouldn't it be cool to have had a part in the development of widely used efficient differential equation solvers?
DifferentialEquations.jl has a wide range of existing methods and [an extensive benchmark suite](https://github.com/SciML/DiffEqBenchmarks.jl) which is used for tuning the methods for performance.
Many of its methods are already the fastest in their class, but there is still a lot of performance enhancement work that can be done.
In this project you can learn the details about a wide range of methods and dig into the optimization of the algorithm's strategy and the implementation in order to improve benchmarks.
Projects that could potentially improve the performance of the full differential equations ecosystem include:

@@tight-list
- Alternative adaptive stepsize techniques and step optimization
- Pointer swapping tricks
- Quasi-Newton globalization and optimization
- Cache size reductions
- Enhanced within-method multithreading, distributed parallelism, and GPU usage
- Improved automated method choosing
- Adaptive preconditioning on large-scale (PDE) discretizations
@@

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Improved benchmarks to share with the community.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Oscar Smith](https://github.com/oscardssmith)

**Expected Project Size**: 350 hour.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

## Discretizations of partial differential equations

There are two ways to approach libraries for partial differential equations (PDEs): one can build "toolkits" which enable users to discretize any PDE but require knowledge
of numerical PDE methods, or one can build "full-stop" PDE solvers for specific
PDEs. There are many different ways solving PDEs could be approached, and here
are some ideas for potential projects:

@@tight-list
1. Automated PDE discretization tooling. We want users to describe a PDE in its mathematical form and automate the rest of the solution process. See [this issue for details](https://github.com/SciML/DifferentialEquations.jl/issues/469).
2. Enhancement of existing tools for discretizing PDEs. The finite differencing (FDM) library [MethodOfLines.jl](https://github.com/SciML/MethodOfLines.jl) could be enhanced to allow non-uniform grids or composition of operators. The finite element method (FEM) library [FEniCS.jl](https://github.com/SciML/FEniCS.jl) could wrap more of the FEniCS library.
3. Full stop solvers of common fluid dynamical equations, such as diffusion-advection-convection equations, or of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman equations would be useful to many users.
4. Using stochastic differential equation (SDE) solvers to efficiently (and highly parallel) approximate certain PDEs.
5. Development of ODE solvers for more efficiently solving specific types of PDE discretizations. See the "Native Julia solvers for ordinary differential equations" project.
@@

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. Some basic knowledge of PDEs, but mostly a willingness
to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Alex Jones](https://github.com/xtalax)

**Expected Project Size**: 350 hour.

**Difficulty**: Medium to Hard depending on the chosen subtasks.

## Jump Process Simulation Algorithms

Jump processes are a widely used approach for modeling biological, chemical and epidemiological systems that can account for both stochastic interactions, and spatial transport, of proteins/particles/agents. [JumpProcesses.jl](https://github.com/SciML/JumpProcesses.jl/) provides a library of optimized solvers for exactly simulating jump processes, including recently added solvers that allow for the simulation of spatially-distributed jump processes (where particles/agents move on graphs or general meshes). A variety of possible projects to extend and enhance the current tooling include

@@tight-list
- Adding additional stochastic simulation algorithms such as partial propensity methods (either explicitly or via wrapping the C++ [pSSALib](https://github.com/breezerider/pSSAlib)), or more recent methods listed in JumpProcesses issues.
- Exploring cache-optimized table and queue data structures to improve performance of current solvers.
- Extending the current graph and spatial algorithms to support interactions between particles/agents at different spatial locations, and developing tooling to automatically calculate transition rates via PDE discretization techniques.
- Extending StochasticDiffEq.jl with τ-leap algorithms to enable the approximate, but more computationally efficient, simulation of jump processes.
- Extending JumpProcesses and StochasticDiffEq with hybrid simulation capabilities, allowing models that mix ODEs, SDE and jump processes and can dynamically partition model components between each mathematical representation as needed to maintain physical accuracy.
@@

**Recommended Skills**: Stochastic processes, numerical ODEs, an understanding of how the Gillespie method or basic jump process simulation algorithms work, and experience using JumpProcesses.jl to simulate jump processes.

**Expected Results**: Completing one or more of the preceding improvements to the jump process simulation tooling.

**Mentors**: [Samuel Isaacson](https://github.com/isaacsas) and [Chris Rackauckas](https://github.com/ChrisRackauckas).

**Expected Project Size**: 350 hour.

**Difficulty**: Hard, generally requires significant mathematical and/or theoretical chemistry background beyond beginning undergraduate classes, including background in stochastic processes and their numerical simulation. Only recommended for advanced undergraduates and/or graduate students. Not a project that AIs can handle without substantial, informed supervision and planning. 
