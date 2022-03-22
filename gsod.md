@def title = "Google Season of Docs"
@def tags = ["sciml","gsod","Google","Google Season of Docs"]

# Google Season of Docs 

The SciML project is a participant organization for Google Season of Docs. In this program, technical writers are paid to work on various SciML open source documentation. Each of the writers are paired with a team of mentors to help them learn various aspects of computational science, from numerical differential equations and scientific machine learning, to parallel and symbolic-numeric computing.

To get started, take a look at the project lists and contact one of the mentors associated with the project.

## Scientific Machine Learning (SciML) and Differential Equations

[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) is a widely used Julia library for solving ordinary, stochastic, delay, and many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentors for the JuliaDiffEq projects are [Chris Rackauckas](https://github.com/ChrisRackauckas), [Kanav Gupta](https://github.com/kanav99), and [Sam Isaacson](https://github.com/isaacsas).

Here are some possible projects:

- ### Unified Organization Documentation

[SciML](https://sciml.ai/) is the scientific machine learning organization. However, its documentation is spread amongst many different fairly large packages:

- [DifferentialEquations.jl](https://docs.sciml.ai/latest/)
- [DiffEqFlux.jl](https://diffeqflux.sciml.ai/dev/)
- [ModelingToolkit.jl](https://mtk.sciml.ai/dev/)
- [Surrogates.jl](https://surrogates.sciml.ai/latest/)

Just to name a few. One project would be to create a unified scientific machine learning documentation that would make it easy to move between all of these different package docs and understand the cohesive organization.

- ### Tutorial Writing

  The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center on features of DifferentialEquations.jl or on application domains. Technical writers who have expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

#### Potential Impact

  Many university classes use the SciML ecosystem for its teaching, and thus classrooms all over the world will be improved. Tutorials that capture more domains will allow professors teaching biological modeling courses to not have to manually rewrite physics-based tutorials to match their curriculum, and conversion of READMEs to documentation will help such professors link to reference portions for these tools in their lecture notes.

  Additionally, these benchmarks are a widely referenced cross-language benchmark of differential equations, which gives a standard between Python, R, Julia, MATLAB, and many C++ and Fortran packages. Improving the technical writing around the benchmarks can make this set of documents more widely accessible, and enlarging the scope of topics will help individuals of all programming languages better assess the methods they should be choosing for their problems.

