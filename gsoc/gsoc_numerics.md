@def title = "SciML Numerical Methods Projects – Google Summer of Code"
@def tags = ["home", "sciml", "diffeq"]

# SciML Numerical Methods Projects – Google Summer of Code

## LinearSolve.jl Distributed Algorithms

[LinearSolve.jl](https://github.com/SciML/LinearSolve.jl) is the higher level
interface for solving linear systems `Ax=b` which allows algorithms like ODE
solvers and nonlinear solvers to easily switch between using sparse direct
methods, Krylov methods, and more. However, automating the solution of linear
systems when `A` is a distributed matrix across an HPC cluster would allow
many large applications to become easy. The global of this project would be
to integrate with libraries such as [Elemental.jl](https://github.com/JuliaParallel/Elemental.jl),
[PartitionedArrays.jl](https://github.com/fverdugo/PartitionedArrays.jl),
and [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) to make this easy.

**Recommended Skills**: Background knowledge in numerical linear algebra and parallel computing.

**Expected Results**: New parallel algorithms wrapped into [LinearSolve.jl](https://github.com/SciML/LinearSolve.jl)

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Medium depending on the chosen subtasks.

## Benchmarks and Tutorial Writing

Many university classes use the SciML ecosystem for its teaching, and thus
classrooms all over the world will be improved. Tutorials that capture more
domains will allow professors teaching biological modeling courses to not have
to manually rewrite physics-based tutorials to match their curriculum, and
conversion of READMEs to documentation will help such professors link to
reference portions for these tools in their lecture notes.

Additionally, these benchmarks are a widely referenced cross-language benchmark
of differential equations, which gives a standard between Python, R, Julia,
MATLAB, and many C++ and Fortran packages. Improving the technical writing
around the benchmarks can make this set of documents more widely accessible, and
enlarging the scope of topics will help individuals of all programming
languages better assess the methods they should be choosing for their problems.

Note that this will include authorship for SciML publications which use the
benchmarks.

**Recommended Skills**: Background knowledge in numerical analysis and modeling.

**Expected Results**: New tutorials in [SciMLTutorials](https://github.com/SciML/SciMLTutorials.jl) and benchmarks in [SciMLBenchmarks](https://github.com/SciML/SciMLBenchmarks.jl).

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy.
