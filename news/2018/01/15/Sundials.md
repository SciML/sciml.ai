@def rss_pubdate = Date(2018,1 ,15 )
@def rss = """ DifferentialEquations.jl 3.4: Sundials 3.1, ARKODE, Static Arrays """
@def published = "15 January 2018"
@def title = " DifferentialEquations.jl 3.4: Sundials 3.1, ARKODE, Static Arrays "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  


In this release we have a big exciting breaking change to Sundials and some
performance increases.

## Sundials.jl v1.0

Sundials.jl released its v1.0 release. The major difference is that Sundials.jl
v1.0 uses the v3.1 release of the C++ SUNDIALS. This is a big change for a few
reasons.

First of all, this is the first major change to the underlying Sundials
infrastructure in years. The previous binary building setup was not well-documented
and thus we were stuck and not able to upgrade for a long time. Now, thanks to
[Tom Short](https://github.com/tshort), this process is now fully documented
and will be fully automated at
[JuliaDiffEq/SundialsBuilder](https://github.com/JuliaDiffEq/SundialsBuilder).
This build script builds binaries for every architecture so no compilers are
needed by users (and this was checked to not cause any performance loss).
Thus the install simply downloads some binaries and links to them! Then the
Clang.jl wrapper was updated to the newest Julia as well, so the full underlying
Sundials library is wrapped via an automated script which is now compatible with
the newest Julia and newest Sundials versions. By having this open source and
available, we can easily upgrade and add things in the future. We plan
to add KLU and Super_LUMT in the short term to give even better sparse
Jacobian support. In the longer term, this can be utilized to easily added
wrappers for the parallel parts of Sundials (this is now a suggested
[Google Summer of Code project](https://sciml.ai/soc/projects/diffeq.html#parallelization-of-the-sundials-solver-library)).
High efficiency fully distributed PDE solving with Krylov methods for sparse
matrices over MPI via Sundials with only a one line change to DifferentialEquations.jl
code is a very close reality!

Secondly, this adds an entirely new library of solvers called
`ARKODE` for explicit, implicit, and IMEX (implicit-explicit) Runge-Kutta methods.
These have been incorporated into the [updated benchmarks](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl)
Summary: OrdinaryDiffEq.jl tends to be more efficient. For example,
[see this benchmark](https://nbviewer.jupyter.org/github/JuliaDiffEq/DiffEqBenchmarks.jl/blob/master/StiffODE/Hires.ipynb)
which shows about a 5x timing difference between the fastest
OrdinaryDiffEq.jl ESDIRK method and the fastest ARKODE one (both are same general
tableaus with different implementation details). But, these are very easy to
use for PDEs with banded and sparse Jacobians so they have a good spot.
Just like with `CVODE_BDF`, you flip `linear_solver=:Band` or
`linear_solver=:GMRES` and it's set for large stiff equations. They will also
help us a lot with development and publications (since now it's one line away
from using another popular library) which is good as well.

Please report any bugs in the installation process that you may encounter.

## Static Array Speedups

This round of updates gives significant speedups to out-of-place codes, especially
those that use static arrays and ArrayFire GPU-based arrays. The DynamicalODE
benchmarks have been upgraded and [this benchmark for example](https://nbviewer.jupyter.org/github/JuliaDiffEq/DiffEqBenchmarks.jl/blob/master/DynamicalODE/Quadrupole_boson_Hamiltonian_energy_conservation_benchmark.ipynb)
displays the difference between using static arrays and mutable arrays for
small physical problems. We hope that users can use this to good effect!

## LSODA.jl Improvements

LSODA.jl got a bunch of memory handling improvements. Now it's on par with the
other algorithms in terms of robustness. It also benchmarks quite well (once
again, refer to DiffEqBenchmarks.jl). An integrator interface with event
handling is coming for this library as well.

# In development

We note that a huge update to the stochastic differential equation solvers is
right around the corner: stay tuned. In addition, note that some projects have
been sectioned off as [possible GSoC projects](https://sciml.ai/soc/projects/diffeq.html).
Please get in touch with us if you're interested in working on numerical
differential equation solvers!

Putting those aside, this is the main current "in development" list:

- Preconditioner choices for Sundials methods
- Small feature requests (for changing initial conditions, etc.)
- Improved jump methods (tau-leaping)
- Adaptivity in the MIRK BVP solvers
- More general Banded and sparse Jacobian support (outside of Sundials)
- IMEX and Exponential Integrators
- Improved jump methods (tau-leaping)
- Stiff SDE solvers
- Banded and sparse Jacobian support
- Compiling Sundials with KLU and SuperLUMT
- LSODA integrator interface
