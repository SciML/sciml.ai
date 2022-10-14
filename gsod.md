@def title = "Google Season of Docs"
@def tags = ["sciml","gsod","Google","Google Season of Docs"]

# Google Season of Docs: Scientific Machine Learning (SciML) and Differential Equations

The SciML project is a participant organization for Google Season of Docs. In this program, 
technical writers are paid to work on various SciML open source documentation. Each of the 
writers are paired with a team of mentors to help them learn various aspects of computational 
science, from numerical differential equations and scientific machine learning, to parallel 
and symbolic-numeric computing.

Below are the proposed projects in this area. Technical 
writers may wish to do a combination of these projects. The mentors for the SciML 
projects are [Chris Rackauckas](https://github.com/ChrisRackauckas), and 
[Sam Isaacson](https://github.com/isaacsas).

Here are some possible projects:

## Unified Organization Documentation

#### Problem

[SciML](https://sciml.ai/) is the scientific machine learning organization. However, 
its documentation is spread amongst many different fairly large packages:

- [Surrogates.jl](https://surrogates.sciml.ai/latest/)
- [MethodOfLines.jl: Finite Difference Methods](https://methodoflines.sciml.ai/dev/)
- [NeuralPDE.jl: Physics-Informed Neural Networks](https://neuralpde.sciml.ai/dev/)
- [NearalOperators.jl: DeepONets and Neural Operator Methods](https://neuraloperators.sciml.ai/dev/)
- [DiffEqOperators.jl: Finite Difference Methods](https://diffeqoperators.sciml.ai/dev/)
- [LinearSolve.jl: High-performance and differentiation-enabled Linear Solvers](https://linearsolve.sciml.ai/dev/)
- [NonlinearSolve.jl: High-performance and differentiation-enabled Nonlinear Solvers](https://nonlinearsolve.sciml.ai/dev/)
- [DiffEqFlux.jl: Universal and neural differential equations](https://diffeqflux.sciml.ai/dev/)
- [NeuralPDE.jl: Physics-Informed Nueral Networks](https://github.com/SciML/NeuralPDE.jl)
- [DataDrivenDiffEq.jl: Koopman Operator and Symbolic Regression](https://datadriven.sciml.ai/dev/)
- [DiffEqParamEstim.jl: Easy parameter estimation by maximum likelihood and MAP of differential equations](https://diffeqparamestim.sciml.ai/dev/)
- [DiffEqBayes.jl: Easy Bayesian inference of differential equations](https://diffeqbayes.sciml.ai/dev/)
- [ReservoirComputing.jl: Reservoir computing methods like echo state networks](http://reservoir.sciml.ai)
- [Surrogates.jl: Fast and differentiable surrogates](https://surrogates.sciml.ai/latest/)
- [ModelingToolkit.jl: A Composable Modeling and Simulation Environment](https://mtk.sciml.ai/dev/)
- [Catalyst.jl: Fast chemical reaction modeling](https://catalyst.sciml.ai/dev/)
- [GlobalSensitivity.jl: Fast and Parallel Global Sensitivity Analysis](https://gsa.sciml.ai/dev/)

#### Project Scope

One high-impact project would be to create a unified scientific machine learning documentation that would make 
it easy to move between all of these different package docs and understand the cohesive organization.
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl), the documentation system used by SciML,
has new high-level functionality for multi-module documentation. Thus the technical difficulty is completed. 
The goal would be to create this unified documentation page with these packages and, more importantly, create
the packages describing how all of these tools are linked.

For example, the following diagram is one such attempt to describe this space:

![](https://user-images.githubusercontent.com/1814174/126318252-1e4152df-e6e2-42a3-8669-f8608f81a095.png)

The most current attempt at this "unified documentation" is at [SciMLBase](https://scimlbase.sciml.ai/dev/),
but there is no clear link to any other documentation, and the connection to more than half of the packages
is never mentioned.

Can you do better? You certainly can!

#### Measuring Success

Because of the large active userbase of the SciML software, accrewing tens of thousands of downloads each month
and having a highly active presence on [the Julialang Discourse](https://discourse.julialang.org/) and
the Julia tag on StackOverflow, success can be measured by the number of users who are satisfied after being 
linked this documentation on these Q&A forums. Success would be measured by having non-SciML devs posting 
links to this documentation on these docs.

Additionally, this unified documentation should have the effect of making our less popular packages more visable.
While we know DifferentialEquations.jl and ModelingToolkit.jl are widely known throughout the community, linking
to docpages at the top for packages like ReservoirComputing.jl or GalacticOptim.jl would increase the discoverability
of these new packages. Questions on forums like 
[this one](https://discourse.julialang.org/t/survey-of-non-linear-optimization-modeling-layers-in-julia/78168)
should have users already informed that GalacticOptim.jl is the most feature-filled package for nonlinear optimization.
This would be reflected by seeing an increased presence of the less-known SciML packages within these forum discussions.

#### Timeline

The project will take approximately six months to complete. The first month would be orientation and getting to know
the space of the SciML projects. The second month would be setting up the unified documentation using the
new Documenter.jl extension tools. The third and fourth month would be creating the new pages which unify the documentation,
i.e. a landing page describing a high-level of what exists, tables to show how the packages relate, figures and diagrams
to make it more accessible. By the fifth month we can start asking for getting more broad feedback from the userbase on
this documentation and begin a rollout of the unified documentation. The sixth month is buffer for the inevitable long list
of typo fixes and polishing the final result.

#### Potential Impact

The tens of thousands of researchers can have a difficult time understanding all there is out there in the SciML ecosystem.
We believe that this unified documentation will have an immense impact on the community and will likely exponentially accelerate
adoption in the less-known portions of the ecosystem. This would draw more attention towards some of the aspects that have
only recently transitioned from academic research to production-quality open source software, and thus will have a lasting impact
by transforming the types of tools people even consider for these types of problems!

## Tutorial Writing

#### Problem

The SciML organization hosts the [SciMLTutorials.jl](https://github.com/SciML/SciMLTutorials.jl) repository which auto-builds 
websites and pdfs from tutorials. Tutorials generally center on features of DifferentialEquations.jl or on application domains.
However, there are so many domains that could be covered in more depth, like:

- Tutorials walking users through optimizing solvers for partial differential equations
- Domain-specific tutorials for biologists, chemists, physicists, and more
- Tutorials focused on generating nice visuals from SciML tools
- Tutorials on how to profile code and improve performance
- Tutorials on how to link different aspects of SciML together into a full workflow, i.e. DataDrivenDiffEq.jl to discover equations
  and then GlobalSensitivity.jl analysis on the resulting discovery to ensure the model is not overparameterized
- Tutorials showing how to use difficult features like parallelism and GPUs
- New benchmarks ([SciMLBenchmarks.jl](https://github.com/SciML/SciMLBenchmarks.jl)) that better describe the trade-offs between the
  methods and tools.

And much much more.

### Project Scope

This is simple! Technical writers who have expertise in areas like biological modeling may wish to contribute tutorials that 
showcase how to use the SciML tools to solve problems arising in their discipline. Thus this can be an exciting project to
for technical folks interested in learning more about the SciML tools as the project devs have agreed to lend a hand in helping
put together the demo code.

#### Measuring Success

Because of the large active userbase of the SciML software, accrewing tens of thousands of downloads each month
and having a highly active presence on [the Julialang Discourse](https://discourse.julialang.org/) and
the Julia tag on StackOverflow, success can be measured by the number of users who are satisfied after being 
linked these tutorialson these Q&A forums. Success would be measured by having non-SciML devs posting 
links to these tutorials on these docs.

#### Timeline

This project has a variable timeline. We suggest choosing 3 tutorials for a 6 month project, as on average we find
a complete tutorial may take approximately two months to solidify. For a given tutorial, this gives about 3-4 weeks
working on writing the code, first coming up with a draft of the code of the tutorial in about 2 weeks, and spending
the rest of the time simplifying the code to make it more impactful. Then, 2 weeks are usually spent on writing the
full story around the code: the descriptions of each section, introduction and conclusion. This gives about two weeks
dedicated to creating more effective visualizations in the tutorial, which we find to be an average.

#### Potential Impact

Many university classes use the SciML ecosystem for its teaching, and thus classrooms all over the world will be improved. 
Tutorials that capture more domains will allow professors teaching biological modeling courses to not have to manually 
rewrite physics-based tutorials to match their curriculum. These tutorials will likely make it into the homework of many
students!
