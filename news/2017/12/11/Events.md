@def rss_pubdate = Date(2017,12 ,11 )
@def rss = """ DifferentialEquations.jl 3.2: Expansion of Event Compatibility """
@def published = "11 December 2017"
@def title = " DifferentialEquations.jl 3.2: Expansion of Event Compatibility "
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

DifferentialEquations.jl 3.2 is just a nice feature update. This hits a few
long requested features.

## Integrators, Callbacks, and Events with Sundials

The callbacks, both `DiscreteCallback` and `ContinuousCallback`, are now able
to be used with the Sundials.jl solvers. This includes `IDA`, the DAE solver, as
well. This was one of the most requested features for a long time and, well, it's
here! Also, `tstops` works with Sundials as well, meaning that all of the tricks
used for building complex control schemes can now work with Sundials.jl.
Additionally, the integrator interface for controlling Sundials via an iterator
exists as well. Note that not all of the integrator interface functions are
implemented right now, but at this point implementing most of them is quite
simple. So please feel free to open feature requests and we can tackle them as
needed.

Sundials.jl is now very well integrated into the DiffEq ecosystem. It's compatible
with almost every option. The things it's not compatible with, such as arbitrary
number types, do not seem to fit into the main purposes of its schemes anyways.
The multistep schemes from this library are most efficient in cases where the
user's `f` is expensive or the number of ODEs is large. In these cases, arbitrary
precision is infeasible anyways. Thus, since Sundials is a very well-optimized
library, I am putting the development of a native Julia multistep method on
the backburner. Instead, I think the next goals in this domain should be
to finish getting full compatibility of Sundials with the common interface, and
that includes the ability to pass preconditioners, user-defined banded Jacobians,
and ARKODE. Getting those setup with our simple interfaces will make powerful
PDE solving tools and there's no reason to double our efforts here.

## Callbacks and Events with ODEInterface (and some performance improvements)

In the same vein as above, ODEInterface.jl's common interface bindings are now
compatible with our callback interfaces. This library is now controlled at a
much lower level where we handle its stepping through its output functions.
There's a few other things which are gained from this. First of all, we more
directly save information that we want, so this actually gives a performance
gain. Secondly, this allowed us to use `saveat` with the intermediate dense
output. Thus while the solution given to the user only has a linear dense output
due to restrictions of the library, within each step `saveat` and `ContinuousCallback`s
are able to make use of the libraries internal higher order interpolation.

The end result is that these functions are very compatible with the common
interface now. There are two big exceptions. This library will not be compatible
with `tstops`, and it cannot have the full `integrator` interface (i.e. instead
of `solve`, using `init`). This is due to how the core integration functions
are written in FORTRAN. However, instead of using `tstops` with a `DiscreteCallback`,
one can always make use of a `ContinuousCallback`, so it's not terrible.

But this means that useful algorithms like `radau`, `seulex` now have all of the
tools to be used with event handling and the like. Thus, for the same reasons
as with Sundials, remaking `radau` into a native Julia version is now lower
on the priority list. Instead, getting this library setup with user-defined
banded Jacobians would satisfy most users in this department, so I plan on
hitting that up soon and then tackling other areas.

## Expanded Benchmarks

[DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl) got a
huge update. The nonstiff ODE problems now showcase more algorithms like lsoda
and ddeabm. There are a lot of new stiff ODE test problems and they cover a
wide range of algorithms. There's new tooling which allows for generating
work-precision plots of stochastic differential equations without analytical
solutions (for both strong and weak error) which is showing some really
interesting results that showcase the efficiency of high order adaptive methods.

## Arrays of Static Arrays

Nested arrays can be a natural way to represent a problem. The `*`DiffEq libraries
can now handle these nested arrays of static arrays. One user reported a speedup
of 4x by using this to represent their equation.

## New Wrapped Libraries

We welcome Bridge.jl and GeometericIntegrators.jl wrappers to the DiffEq-sphere.
Bridge.jl is a library for stochastic calculus and it has some nice out-of-place
fixed timestep solvers for stochastic differential equations. GeometericIntegrators.jl
is a library of fixed timestep solvers which will likely be focusing on geometric
and conservative algorithms. Following the theme of not doubling efforts across
the Julia ecosystem, these wrappers expand our focus with less effort.

# In development

The "in development" list has falling sharply. First of all, many things have
finished. Other things are being left for Google Summer of Code. But mainly,
the increased compatibility of wrapped packages allows us to shift focus. While
there would still be advantages of a pure-Julia BDF or Radau method, the advantages,
now that these are compatible with even more advanced features like event handling,
are minimal. Thus these have been shifted to a lower priority, allowing us to
shift our focus.

Thus the main current "in development" list is:

- IMEX and Exponential Integrators
- Improved jump methods (tau-leaping)
- Stiff SDE solvers
- Banded and sparse Jacobian support
