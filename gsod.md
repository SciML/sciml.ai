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

## SciML Tutorial Writing

#### Problem

The SciML organization hosts the [Tutorials and Showcase examples](https://docs.sciml.ai/Overview/stable/showcase/showcase/)
which demonstrate cross-cutting applications from automating the discovery of relativitistic
corrections to black hole phyiscs to GPU accelerating pharmacometric intervention analysis.
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
