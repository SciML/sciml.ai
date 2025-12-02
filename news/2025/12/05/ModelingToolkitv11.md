@def rss_pubdate = Date(2025,12,05)
@def rss = """ModelingToolkit v11: Licensing, Type-Stability / Performance Improvements, and Array Future"""
@def published = " 5 December 2025 "
@def title = "ModelingToolkit v11: Licensing, Type-Stability / Performance Improvements, and Array Future"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# ModelingToolkit v11: Licensing, Type-Stability / Performance Improvements, and Array Future

We are excited to announce major releases for a large set of the symbolic stack, including:

* ModelingToolkit v11
* Symbolics v7
* SymbolicUtils v4

This is a massive transformation of the symbolic ecosystem in Julia, with a focus on improving type-stability and performance, as well as setting the stage for future array programming capabilities.
Major props to Aayush Sabarwal for leading much of the development on this release over the path
9 months. With this, we have a lot to talk about and share. Some of this is a difficult discussion
which we want to be transparent about, so please read through the entire post.

## Licensing Changes

One significant item to address with this update is the licensing associated with ModelingToolkit.jl.
Starting with version 11, ModelingToolkit.jl will be structured in a way where some of its dependencies have an AGPL
license. In short (and will be elaborated on later), ModelingToolkit.jl and SymbolicUtils.jl now include
an extendable pass system for the compiler, meaning that additional compiler passes can be added into
the system through downstream dependencies. This is a powerful feature that allows for more extensibility
and customization of the symbolic transformation process. This is something that was attempted from the
start, which is why the StructuralTransformation.jl subpackage/submodule was always shipped with
ModelingToolkit.jl, but the pass system was never modular enough to follow allow for external extensions,
now it does. 

ModelingToolkitBase.jl is thus an MIT-licensed package with no Julia GPL dependencies and contains all
of the core functionality of ModelingToolkit.jl. This for example includes the utilities for building
`System`s, generating code for ODEs, SDEs, etc., and the main symbolic compiler pipeline. 
ModelingToolkitBase.jl is thus a fully functional symbolic modeling compiler which can take symbolic
descriptions of systems and generate performant Julia code for them as-is.

With this change, the versions of the symbolic transformation libraries has been moved to
a separate repository (https://github.com/JuliaComputing/StateSelection.jl) which is licensed under AGPL.
As AGPL is an OSI-approved license, this package is open source and released as part of the General
registry, meaning that ModelingToolkit.jl remains easy to install and use for open source projects.
However, AGPL does have some implications for commercial use, so please review the license if you
are considering using ModelingToolkit.jl in a commercial setting. In particular, if you are redistributing
ModelingToolkit.jl in a shipped binary or web service, then you need to ensure the licensing requirements
of AGPL are satisfied. It was already the case before that some dependencies of ModelingToolkit.jl and
Julia itself were GPL dependencies, notably SuiteSparse and FFTW are GPL-licensed libraries and thus
ModelingToolkit.jl already had some GPL implications. However, with this change, the implications include
the symbolic transformation libraries specifically for handling acausal models and high-index DAEs.

This was a difficult decision to make, and the evolution of ModelingToolkit.jl shows many scars of previous
failed attempts to do this correctly. We previously had StructuralTransformation.jl as a separate package
back in the early days of ModelingToolkit.jl, but ultimately the developer burden of maintaining it separately
was so high that it had almost killed the entire project. Because of this, we had always had to hold back
on actively releasing some of the more advanced features into the ecosystem. Some of the coolest features
and major advancements in acausal modeling, such as 
[techniques for making large loops and arrays compile fast](https://patents.google.com/patent/US20250013444A1/en),
specifically had to be omitted or kept separate in order to deal with licensing issues due to the commerical
aspects for which they were developed. Many may recall the project JuliaSimCompiler.jl, which was a separate
backend to ModelingToolkit.jl models that implemented many of these compiler passes. Ultimately, having to
maintain two separate compilers means having 2 bad compilers: during the time frame of JuliaSimCompiler the
issues list in both repositories grew enormously and the bug surface became very high due to divergences in
compiler support. Once more, having this separate compiler almost killed the entire project due to the high
maintanance burden.

Thus we had to spend some time to really think through how to do this effectively in a way that would sustainable
for the future of the project. Ultimately the issue is that, unlike what has occured in the solver ecosystem, 
almost all of the funding that has been achieved for ModelingToolkit.jl throughout its entire lifespan has had
both developer and government requirements for commercialization. While many may believe that the (US) government
supports open source software development and would prefer for this software to be distributed as free under a
permissive license, the reality is that government contracts and grants often have requirements for 
commercialization. For full transparency, ModelingToolkit.jl has required about 3 full-time expert/senior
developers for the last 5 years, and the funding for this project has totaled around ~$250k (after overhead) of
government grants directed to the non-commercial aspects of the project (we thank Bernt Lie for his early
contributions via DigiWell and Chris Tessum for co-PIing on a related NSF grant). We additionally note that 
total donations to the project have been <$10k over the full 10 years. 

As one may guess, 15 developer
years for the top developers of the SciML space was not able to be sustained on that budget, and thus
most of the shortfall was made up through commercial contracts and grants with commercial requirements, such as
grants form DARPA and ARPA-E. However, these grants and contracts often have requirements for commercialization
and thus items around ModelingToolkit.jl have repeatedly required being removed from the grant scope due to
reviewer feedback suggesting that these activites do not fall under the required commercialization scope. That
is not to mention all of the lost funding due to this sustainability issue: in particluar about $6 million of
grants were denied this year on the topic of improvements to ModelingToolkit.jl with the repeated main reasoning
noting being the lack of addressing the commericalization sustainability requirements of the funding agencies,
citing the fact that the liberal MIT license would allow competitors and large companies who do not contribute
to the project to use all contributions to build a competing project (and this is something that has been seen).

Because of these requirements, we looked for a solution that satisfied all of the following criteria:

1. The core functionality of ModelingToolkit.jl, in particular the parts that are used by projects such as 
   Catalyst.jl and SymBoltz.jl which are just developing and compiling ODEs, remains open source and permissively
   licensed.
2. There are sufficient protections in place for the JuliaHub developments in order to continue to secure both
   commercial and government funding for those full time on the project. In particular, this is the functionality
   around acausal modeling, high-index DAE handling, and large-scale model compilation optimizations.
3. The developer burden of maintaining the codebase remains manageable and does not lead to fragmentation of   
   the symbolic compiler ecosystem.

We believe that this major infrustructure change satisfies all of these requirements, where ModelingToolkitBase.jl
is a GPL-free core version that libraries such as Catalyst.jl and SymBoltz.jl can directly depend on, while the
acausal modeling capabilties still work without any changes to user code just by doing `using ModelingToolkit`,
and the developer burden is manageable since there is now a single codebase for the symbolic compiler. And,
AGPL is still an OSI-approved open source license, so the code remains open source and available for use in open
source projects without any issues, the packages are registed in the General registry which means the installation
remains easy, and the source code is fully available for inspection, research, and contributions.

We additionally excited to see what this pass system leads to. This infrastructure open up the possibility to 
slot in alternative implementations of tearing
(in particular [optimal tearing algorithms using SAT solvers](https://sdopt-tearing.readthedocs.io/en/latest/)
which would be a fantastic PhD project), as well as other advanced symbolic transformations.

Ultimately, our goal is always to increase the sustainability of the Julia package ecosystem by bringing in as
many developers into the space as possible. We have found over the years that selectively working with the
commericial sector has vastly improved the number of open source developers when done right. For example,
PumasAI has continued to fund some of the major contributors to Optim.jl, Makie.jl, Turing.jl, etc. to an
extent that much of this only exists due to the effective commercialization of the nonlinear mixed effects
fitting system being commercialized. As such, we similarly hope that this change will allow for more developers
to be able to be in this symbolic-numeric computing space.

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/kuzwUFuIyk4?si=H_IlzO3IaVCYDQgM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
~~~

But we do realize this will have some implications to some users. Please feel free to reach out to me, Chris 
Rackauckas, via email directly if you want to discuss this in further detail.

Now to share all of the exciting benefits we get from this!

## Type-Stability and Performance Improvements in the Entire Symbolic Stack

With this set of changes, for the first time SymbolicUtils.jl, Symbolics.jl, and ModelingToolkit.jl have
fully type-stable pipelines. This means two major things:

1. All symbolic operations allocate less and are faster
2. Code associated with the symbolic computing stack now is more predictable for the Julia compiler, and thus
   precompilation actually works, largely fixing the "time to first X" associated with all symbolic operations
   that are precompiled.

This is a major change as Symbolics.jl and ModelingToolkit.jl have long been cited as two of the libraries which
have the worst time-to-first-X issues in Julia due to the heavy use of dynamic typing in the symbolic
computing stack. This has now been largely fixed by using a recursive sumtype representation. The exact solution
is rather technical, see https://github.com/JuliaSymbolics/SymbolicUtils.jl/issues/737 for details. This allows
us to marry the [performance improvements of the advanced term representation](https://arxiv.org/abs/2306.05397) 
with type-stability and all its associated performance benefits in SymbolicUtils.jl
representation.

Because the core aspects were now type-stable, changes were made to the parts on top of the representation,
in particular the functions of Symbolics.jl and the compiler pipeline of ModelingToolkit.jl, to ensure that
they also maintained type-stability. This has led to major performance improvements across the entire
symbolic stack. But it also included some breaking changes to give type-stable routines by default. One example
of this is that `substitute(2x + 3y, Dict(x=>1, y=2))` now returns a BasicSymbolic expression of a constant
rather than the `Int` 8, because all substitutions now return symbolic expressions to maintain type-stability.
This can be changed by using `Symbolics.evaluate` to get the evaluated result, or moving to other options like
adding `fold = Val(true)`.

There are still some functions being worked on to make them fully type-stable, for example the `ODEProblem` build
function still has some dynamic typing in it that increases the time-to-first-ODE-solve a bit. However, we believe
that all of the required breaking changes have been made, and thus we wanted to get this version out there,
and future minor version releases in the v11 time frame will continue to improve type-stability, performance,
and time-to-first-X based on this new foundation.

Major props to Aayush Sabarwal for leading this effort.

## Improved Array Compiling in Symbolics

One of the major issues with ModelingToolkit since its inception has been the speed of codegen for large repeated
sets of equations, such as those stemming from PDEs. We have not fully solved this problem, but the major
infrastructure changes give us all of the right tools to finally have a fully maintainable solution. In particular,
SymbolicUtils.jl now fully supports array code during its code generation pathways. No scalarization is done at
this level or Symbolics.jl.

Its code generation also
allows for alternative plugin packages to add steps to the compilation. The new library 
[SymbolicCompilerPasses.jl](https://github.com/JuliaComputing/SymbolicCompilerPasses.jl), is one such pass library
that is being shipped that has the ability to ensure that array code is optimized, including doing things like
using a bump allocator in order to achieve performance to pre-allocated code, using in-place mutating operators
in the generated code. It will soon do things like automatically swap small operations, such as `\` of 4x4 rotation
matrices, to change them into static array operations. As such, it effectively transforms symbolic mathematical
expressions into the kind of StaticArray.jl + specialized LinearSolve.jl + tensor contracted + etc. code that
you would expect expert Julia users to write. On top of this, the library is scheduled to allow for Reactant.jl
as a plugin (once integration issues are handled (https://github.com/EnzymeAD/Reactant.jl/issues/1864)), so that
all of the automated parallelism / GPU features from Reactant are also available on Symbolics-generated code. 

This is one of the alternative passes that are additionally scheduled to be turned on by default from the 
ModelingToolkit compiler when ready. The ModelingToolkit tearing passes still need to improve their rules around
arrays to remove some scalarization, and this will happen in the v11 time frame as no breaking changes are required
for that. When completed, the generated code for array expressions will be O(1) in code size and compilation time.
This will solve a long-standing issue in the ModelingToolkit compiler, and approximately 80% of the work is now
completed because the Symbolics code generation was one major aspect.

We note for avid users that MethodOfLines.jl will need a substantial change in order to use array expressions
in order for our PDE discretizers to benefit from these improvments, and NeuralPDE.jl's codegen will need a
rewrite to use this all. So there is a lot of work to still be done to see it throughout the ecosystem, but the
first major steps are complete.

## Deprecation of the ModelingToolkitStandardLibrary.jl

We are announcing that the `@mtkmodel` macro and the ModelingToolkitStandardLibrary.jl will soon be deprecated.
This is due to focusing more of the ModelingToolkit.jl maintainance team on a smaller set of codebases in order
to ensure that we can grow in a more sustainable manner. In particular, the ModelingToolkitStandardLibrary.jl's
deprecation is due to simply falling behind. Not only has no one has been actively maintaining this library,
but an alternative open source library has come up which subsumes all of its functionality while fixing many
of its remaining bugs. This is the Dyad standard library. The Dyad standard library's repositories
are split rather than in one repository, for example 
[ElectricalComponents.jl](https://github.com/DyadLang/ElectricalComponents) is for the electrical components,
while [TranslationalComponents.jl](https://github.com/DyadLang/TranslationalComponents) is for the
translational components. In addition, they include many improvements and designs made by 
Michael Tiller, one of the leading figures in acausal modeling and Modelica world for having written many of its
foundational books and training materials. Thus they are simply a more solid version of these standard libraries,
have more guarentees about accuracy and numerical stability, and thus are what should be used instead.

We should note that while [Dyad](https://help.juliahub.com/dyad/dev/) is a commercial product that requires
a license for commercial use, its standard libraries (i.e. the ones matching the ModelingToolkitStandardLibrary)
are open source and licensed with the liberal BSD-3 license. Dyad by design generates ModelingToolkit.jl code
as part of its compilation process, meaning that these standard libraries include a Julia package with 
ModelingToolkit versions of every component that can be used without installing Dyad. As such, these component
libraries serve as a fully open source alternative to everything in the ModelingToolkitStandardLibrary.jl, but
have very active maintenance, lots of testing in the real world, and many thoughtful design decisions from some
of the industry's best. With all of that together, we do not see a good reason to continue maintaining
the ModelingToolkitStandardLibrary.jl, hence its deprecation. However, we note that we will need to improve
the documentation for purely ModelingToolkit / non-Dyad users of these component libraries, including the
discoverability aspect, which is slated for the near future.

## Deprecation of the `@mtkmodel` Macro and Focusing the Development Effort of ModelingToolkit.jl as a Compiler

The `@mtkmodel` macro was designed as a Modelica-like syntax for which one can use ModelingToolkit.jl. While
some effort was put into it at the early stages, it ultimately has lacked much development for around the last
year and a half. It is generally rather buggy and leads to more difficult debugging. Thus for around the last
year, for most issues we have suggested that users rewrite their code to not use the macro whenever sharing
bug reports. We are finally making the decision to fully deprecate the `@mtkmodel` macro. The reasoning is
simply that there are almost no maintainers, so while it does something interesting, it is not at a state
which gives ModelingToolkit.jl a good look, and thus should not be what people see in the first tutorial.

Because of this, all of the documentation will be updated to instead use the direct ModelingToolkit.jl form.
We believe that this accomplishes a few goals. Firstly, it decreases the feature surface, making it easier to have a
less buggy project and thus simply a better user experience. It also more clearly brings users into the
"core" usage of ModelingToolkit as a compiler, where the direct interface has always been more flexible for
many use cases like building libraries and things which are not related specifically to acausal modeling of
DAEs (for example, `@mtkmodel` still does not even support SDEs). This lets the ModelingToolkit.jl team focus
on what ModelingToolkit does best, namely, it's a symbolic representation for models and a compiler to fast
and stable numerical simulations. 

That does not mean that we do not like DSLs on ModelingToolkit, oh not at all! Instead this is making `@mtkmodel`
no longer a privledged DSL of the project. For example, SymBoltz.jl and Catalyst.jl are two great DSLs built on
ModelingToolkit.jl, just as separate packages. We plan to spawn out `@mtkmodel` to a separate DSL package of
ModelingToolkit.jl in a similar fashion, though with the code base currently having no maintainers we will 
deprecate the package unless new maintainers come to the revive the project. This is thus an open call for new
folks to come in.

We also must note that if someone really does need a fully developed DSL that is Modelica-like and compiles to
ModelingToolkit, but is a more fully featured version (for example, has syntax highlighting, gives syntactic
compiler errors, supports units, is well-maintained, etc.) then we suggest checking out 
[Dyad](https://help.juliahub.com/dyad/dev/) which is free for non-commerical use and provides exactly this DSL.
Our intention here is not to push out `@mtkmodel` to Dyad, but instead to note how the ModelingToolkit
project has evolved, where the open source aspect has really evolved to thrive around the symbolic compiler but
not all of the extra language features. As such, we want to make `@mtkmodel` like every other DSL as just a
potential add-on package, and allow users to pick from the bevy of cool DSLs built on ModelingToolkit, keeping
all of the difficulties of developing a language separate from the largely mathematical work of ModelingToolkit.

## Final Note

I just want to end this by saying, I have dedicated almost every day, night, and weekend towards making the Julia
open source community thrive. Sometimes hard decisions have to be made, and I think it is clear to everyone that
this is one of them. It took us almost 3 years to find this solution and I believe that this version both maximizes
the amount of open source-ness in the project, gives people ways to opt out of any GPL-ness, while also giving a
sustainable model for the project's future. I hope the complete honesty and transparency of these changes helps
everyone understand the reasoning behind the changes. And I, Chris Rackauckas, am available to talk about not
just the technical aspects but also the community and funding aspects of ModelingToolkit, SciML, and the rest of
the Julia ecosystem at any time. If you have any questions, feel free to reach out. Let's see if this makes the
best version of the open source ecosystem.