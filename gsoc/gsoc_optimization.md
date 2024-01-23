@def title = "SciML Optimization – Google Summer of Code"
@def tags = ["home", "sciml", "optimization"]

# SciML Optimization Projects – Google Summer of Code

## Generalized multistart optimization strategies

Multistart refers to a global optimization methodology wherein local solvers are run 
from multiple points in the parameter space and once they converge to local minimas
this can then be used to either further refine the solution or a minimum operation of the 
obtained local minimas for getting the global minima.

There has been some work to implement two approaches already namely, a simple quasimontecarlo 
initialization and using the Particle Swarm Optimization method for some iterations. There is
scope for coming up with novel methods here as well thus making this project very suitable for
research focused candidates.
 
So a generalized implemetation of these strategies, like TikTak and improving the ones mentioned
above to be compatible with all solvers supported by Optimization.jl will be impactful. This should 
be done through the EnsembleProblem interface thus leveraging the already available parallelization 
infrastructure which is essential in these methods for performance.

**Recommended Skills**: Background knowledge in optimization and parallelization.

**Expected Results**: A suite of multistart methods available trhough the SciML EnsembleProblem interface.

**Mentors**: [Vaibhav Dixit](https://github.com/Vaibhavdixit02)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Hard depending on the chosen subtasks.

## First class OptimizationState to support machine learning optimization better

A core requirement in a lot of optimization tasks involves being able to observe intermediate state
of the solvers, especially in ML adjacent problems. Recently an OptimizationState object has been added 
to Optimization.jl for supporting these usecases. There is a lot of scope for making this more performant
and featureful as well as extending it to more solver wrappers. This project is quite open eneded and can 
be designed as per the candidates motivation. Some specific things could be utilizing the derivative oracle
calls to store their values without recomputing it, allowing visualizations of the training loop through
predefined callbacks, using the state for non-standard stopping criterias in global optimization etc.

**Recommended Skills**: Background knowledge in optimization and familiarity with machine learning workflows.

**Expected Results**: Improvements to OptimizationState and its interactions with solvers.

**Mentors**: [Vaibhav Dixit](https://github.com/Vaibhavdixit02)

**Expected Project Size**: 175 hour or 350 hour depending on the chosen subtasks.

**Difficulty**: Easy to Medium depending on the chosen subtasks.

## More AD goodies, more backends and sparsity support

## Benchmarking suite, automated timing and code profiling

## Tutorials, more problem classes and workflows



