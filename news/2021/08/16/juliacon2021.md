@def rss_pubdate = Date(2021,8,16)
@def rss = """SciML at JuliaCon 2021"""
@def published = " 16 August 2021 "
@def title = "SciML at JuliaCon 2021"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML at JuliaCon 2021

[JuliaCon 2021](https://juliacon.org/2021/) was an exciting conference filled
with talks about new Julia software and use cases. Specifically this year saw
an exponential rise in the number of talks featuring the SciML Open Source
Software Organization. To help those interested, this post will highlight some
of the talks which showcase the SciML tools.

## Adaptive and extendable numerical simulations with Trixi.jl

Trixi.jl is a hyperbolic PDE solving package which uses
[DifferentialEquations.jl](https://docs.sciml.ai/DiffEqDocs/stable/) for its time stepping.
It adds features for meshing and defining stable spatial discretizations.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/hoViWRAhCBE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## AlgebraicDynamics: Compositional dynamical systems

Category Theory + Differential Equations for generating models in an intuitive
algebraic way. It's quite an interesting experience that can have many use cases
for scientists in fields like epidemiology where models are built from repeating
structures.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/GohPz2vuIhI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Bayesian Neural Ordinary Differential Equations

Bayesian Neural Ordinary Differential Equations mixes the [tools of DiffEqFlux.jl](https://docs.sciml.ai/DiffEqFlux/dev/)
with probabilistic programming languages [like Turing.jl](https://turing.ml/stable/)
to allow for automatically discovering physical models in a way that gives
uncertainty estimates.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/xnnrp1_eWdE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## BifurcationKit.jl: bifurcation analysis of large scale systems

BifurcationKit.jl is a pure Julia package for, you guessed it, bifurcation analysis.
It connects with the SciML sphere, using some of its tools and interfacing with
the same differential equation definitions, to seamlessly add functionality
to the ecosystem. It is extremely fast and scalable, with some nice robust
methods like deflation methods not seen in many previous tools.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/-kZEuxrcf2M" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Chaotic time series predictions with ReservoirComputing.jl

Reservoir computing is a machine learning technique which has been shown to
give good predictions of attractor properties on chaotic systems. ReservoirComputing.jl
productionizes these techniques and makes it easy to train these architectures
against data from physical systems for generating accurate predictions.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/kEx_OqOu9dI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## ClimaCore.jl: Tools for building spatial discretizations

[CLIMA](https://clima.caltech.edu/) is the climate modeling initiative which is
building a pure-Julia global circulation model (GCM). ClimaCore is the internal
core tool for generating spatial discretizations. It builds outputs which are
compatible with the DifferentialEquations.jl time stepping methods, and thus
is a nice addition to the ecosystem providing spectral element discretizations
of common PDEs.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/4bQvF3rGB84" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Designing ecologically optimized vaccines

This is an applications talk describing how the SciML tools were used in the
modeling process for developing ecologically optimized vaccines.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/26vQQ7qw8ds" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Designing Spacecraft Trajectories with Julia

This talk describes [OrbitalTrajectories.jl](https://github.com/dpad/OrbitalTrajectories.jl)
a [ModelingToolkit](https://github.com/SciML/ModelingToolkit.jl)-based package
defining the trajectories of satellites and rockets. Dan showcases how this new
modeling package gets >10x faster over previous tools in every case, and how a
lot of the Julia ecosystem's combined features give rise to a uniquely flexible
simulation environment for the domain.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/iJr_lU7_7Go" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Generative Models with Latent Differential Equations in Julia

With [LatentDiffEq.jl](https://github.com/gabrevaya/LatentDiffEq.jl) you can
learn the parameters of a pendulum directly from the images/video of its trajectory.
This is a DiffEqFlux-based approach where the packages a special autoencoder
architecture that performs this task and demonstrates its utility.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/jhIgs4swrMA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Global Sensitivity Analysis for SciML models in Julia

Global Sensitivity Analysis (GSA) is commonly used across scientific domains like
systems biology and pharamcology. This talk describes [GlobalSensitivity.jl](https://github.com/SciML/GlobalSensitivity.jl),
a pure Julia package for (parallelized) fast global sensitivity calculations.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/vvD4xGBmZc8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Going to Jupiter with Julia

This talk describes [GeneralAstrodynamics.jl](https://github.com/cadojo/GeneralAstrodynamics.jl),
a ModelingToolkit-based simulation package for calculating trajectory solutions
of specific N-body problems used throughout space planning operations.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/WnvKaUsGv8w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## JuliaSim: Machine Learning Accelerated Modeling and Simulation

This talk describes [JuliaSim](https://juliacomputing.com/products/juliasim/),
a commercial product being developed by Julia Computing which uses the core
tools of SciML, such as ModelingToolkit, within its core. It's being developed
as a tool for assisting causal and acausal modeling workflows by providing
cloud compute, graphical user interfaces (GUIs), automated surrogate generation,
and more.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/lNbU5jNp67s" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## JuliaSPICE: A Composable ML Accelerated Analog Circuit Simulator

This talk describes JuliaSPICE, a commercial circuit simulation environment
being developed by Julia Computing based on SciML tools such as ModelingToolkit.jl.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/q8SzFTtgA60" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Modeling Marine Ecosystems At Multiple Scales Using Julia

This was one of the pre-JuliaCon workshops which focused on packages for domain
scientists which internally use the SciML software tools such as DifferentialEquations.jl
for model simulations.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/UCIRrXz2ZS0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Modia – Modeling Multidomain Engineering Systems with Julia

[Modia.jl](https://github.com/ModiaSim/Modia.jl) is a multi-domain acausal modeling
package built on DifferentialEquations.jl by the creators of the Modelica modeling
language. This talk showcases many of its additions, such as [Modia3D](https://github.com/ModiaSim/Modia3D.jl),
for simulating increasingly complex systems.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/N94si3rOl1g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Physics-Informed ML Simulator for Wildfire Propagation

This talk features an application of [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl)
for simulating the propagation of wildfires.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/45GdDnuNirg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## SciML for Structures: Predicting Bridge Behavior

This talk features ongoing research in application of the SciML framework for
bridge engineering.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/4KKtMjqzNUA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Simulating Big Models in Julia with ModelingToolkit

Many of the other talks discuss tools which are built on ModelingToolkit.jl, but
what is ModelingToolkit? This is a 3-hour interactive coding workshop which
asks and answers this question by showing the features of ModelingToolkit.jl
and how it can be used to generate high performance model simulation code.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/HEVOgSLBzWA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Simulating Chemical Kinetics with ReactionMechanismSimulator.jl

[ReactionMechanismSimulator](https://github.com/ReactionMechanismGenerator/ReactionMechanismSimulator.jl)
is a Julia packages for simulating reaction mechanisms. This talk showcases
how the package interacts with ReactionMechanismGenerator to quickly develop
differential equation models of the underlying chemistry, and showcases how
it performs faster than packages like Cantara in this domain.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/Bvs-sUK693U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Single-cell resolved cell-cell communication modeling in Julia

In this application talk, it is described how the Julia tools like
DifferentialEquations.jl have been used for modeling cell-cell communication
and have been linked to single-cell data for validation.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/Z5fPJy06be0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Space Engineering in Julia

This talk goes into detail on how the Brazilian Space Agency has built software
tools such as [SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl)
which leverged the SciML tools like DifferentialEquations for the mission planning
of the Amazonia 1 satellite.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/s7B2VsRXkTs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Symbolics.jl - fast and flexible symbolic programming

This talk delves deep into [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl),
the pure-Julia computer algebra system (CAS) spawned out of ModelingToolkit.jl
and used as the symbolic basis of the SciML ecosystem.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/Vkz4c-lDMU8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

## Systems Biology in ModelingToolkit

How do you integrate with CellML, SBML, BioNetGen, and more files in the SciML
universe? This talk describes the tools which make it easy to read in and
start simulating large-scale systems biology and systems pharmacology models.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/DL0Xw7ETZsE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~
