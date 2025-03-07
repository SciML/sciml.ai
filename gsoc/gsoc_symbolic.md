# Symbolic computation project ideas - Summer of Code

## Symbolic Matrix and Tensor Calculus

[Matrix calculus](https://www.matrixcalculus.org/matrixCalculus) is the ability to do calculus
directly on matrix expressions rather than requiring the performance of the calculus on the
scalar quantities. For example, `x'*A*x + c*sin(y)'*x` differntiates to `2*A*x + c*sin(y)`.
Currently, Symbolics.jl does not support matrix calculus, only scalar calculus, so the work
would be to expand the support to include handling of symbolic matrices.

For more information, see [this paper](https://www.matrixcalculus.org/matrixcalculus.pdf)
and [this paper](https://www.matrixcalculus.org/tensorcalculus.pdf).

**Recommended Skills**: High school/freshman calculus and a willingness to learn symbolic computing

**Expected Results**: A working implementation of matrix calculus

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Aayush Sabharwal](https://github.com/AayushSabharwal)

**Duration**: 350 hours

## Symbolic Integration in Symbolics.jl

Implement the [heuristic approach to symbolic integration](https://dspace.mit.edu/handle/1721.1/11997).
Then hook into a repository of rules such as [RUMI](https://rulebasedintegration.org/).
See also the potential of using symbolic-numeric integration techniques (https://github.com/SciML/SymbolicNumericIntegration.jl)

**Recommended Skills**: High school/Freshman Calculus

**Expected Results**: A working implementation of symbolic integration in the Symbolics.jl library, along with documentation and tutorials demonstrating its use in scientific disciplines.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Aayush Sabharwal](https://github.com/AayushSabharwal)

**Duration**: 350 hours


## Automatically improving floating point accuracy (Herbie)

[Herbie](https://herbie.uwplse.org/) documents a way to optimize floating point functions so as to reduce instruction count while reorganizing operations such that floating point inaccuracies do not get magnified. It would be a great addition to have this written in Julia and have it work on Symbolics.jl expressions. An ideal implementation would use the e-graph facilities of Metatheory.jl to implement this.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Aayush Sabharwal](https://github.com/AayushSabharwal), [Alessandro Cheli](https://github.com/0x0f0f0f)

**Duration**: 350 hours

## Reparametrizing ODE models with scaling transformations

**Project Overview:** Many ODE models appearing in applications have hidden symmetries which makes the solution of data fitting problem nonunique. [StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl) offers algorithms for proposing new coordinates for the model removing this redundancy. The approach used at the moment relies on heavy computations and may be very slow for larger models. Scaling is a particular type of reparametrizations which can be discovered much faster. The goal of the project would be to implement such faster algorithms (adapting them to the context of identifiability assessment) and integrate into StructuralIdentifiability.jl.

**Mentors:** [Alexander Demin](https://github.com/sumiya11), [Gleb Pogudin](https://www.lix.polytechnique.fr/Labo/Gleb.POGUDIN/)

**Project Difficulty**: Medium

**Estimated Duration**: 350 hours
