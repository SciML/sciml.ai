@def rss_pubdate = Date(2025,9,12)
@def rss = """SciML Fellowship development 2025 - JumpProcesses.jl"""
@def published = " 12 September 2025 "
@def title = "SciML Fellowship development 2025 - JumpProcesses.jl"
@def authors = """<a href="https://github.com/sivasathyaseeelan">Siva Sathyaseelan D N</a>"""

# SciML Fellowship development 2025 - JumpProcesses.jl: Introducing vr_aggregator for VariableRateJumps, GPU-enhanced SimpleTauLeaping and Extending with τ-Leap Algorithms for Jump Process Simulation

![image](../../../../../assets/gsoc2025pics/siva.jpeg)

 Hello! I’m [Siva Sathyaseelan D N](https://github.com/sivasathyaseeelan), a pre-final year B.Tech + M.Tech Industrial Chemistry student at IIT BHU, Varanasi, India. Over the summer of 2025, as part of the SciML Fellowship, I made significant enhancements to `JumpProcesses.jl`, a Julia package for simulating stochastic jump processes. My contributions focused on three key areas: the introduction of the `vr_aggregator` framework for handling variable rate jump processes, the development of a GPU-enhanced `SimpleTauLeaping` ensemble solver, and the extension of JumpProcesses.jl with new `τ-leaping algorithms` for efficient jump process simulations. These advancements improve performance, scalability, and usability for stochastic simulations, particularly in applications like chemical reaction networks, epidemiological models, and other systems with discrete state changes.

# Variable Rate Aggregator (vr_aggregator)
The `vr_aggregator` framework introduces a robust and flexible approach to handling variable rate jump processes, addressing limitations in previous implementations and enabling efficient simulations for systems with time-varying rates.

## Key Contributions
- **VR_Direct and VR_FRM ([PR #477](https://github.com/SciML/JumpProcesses.jl/pull/477), Merged)**: Introduced `vr_aggregator` with `VR_Direct` (Variable Rate Direct with Constant Bounds) and `VR_FRM` (Variable Rate Forward Rate Mode) for optimized variable rate handling.
- **Optimized VR_DirectEventCache ([PR #486](https://github.com/SciML/JumpProcesses.jl/pull/486), Merged)**: Removed redundant `VariableRateJumps` structures for improved memory efficiency.
- **VR_DirectFW Aggregator ([PR #488](https://github.com/SciML/JumpProcesses.jl/pull/488), Merged)**: Added forward-time optimized aggregator for frequent rate updates.
- **Bug Fixes ([PR #489](https://github.com/SciML/JumpProcesses.jl/pull/489), Merged)**: Enhanced stability and reliability for edge cases.
- **Benchmarking ([PR #1230](https://github.com/SciML/SciMLBenchmarks.jl/pull/1230), Open)**: Ongoing performance evaluations in `SciMLBenchmarks.jl`, showing significant improvements.

## Practical Examples

### Example 1: Variable Rate Jump Process with ODE
This example demonstrates a simple ODE with two variable rate jumps, solved using different `vr_aggregator` methods (`VR_FRM`, `VR_Direct`, `VR_DirectFW`).

```julia
using JumpProcesses, DiffEqBase, StableRNGs

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define variable rate jump
rate(u, p, t) = u[1]  # State-dependent rate
affect!(integrator) = (integrator.u[1] = integrator.u[1] / 2)  # Halve the state
jump = VariableRateJump(rate, affect!, interp_points=1000)
jump2 = deepcopy(jump)

# Define ODE
f(du, u, p, t) = (du[1] = u[1])  # Exponential growth
prob = ODEProblem(f, [0.2], (0.0, 10.0))

# Solve with different vr_aggregators
jump_prob_vrfrm = JumpProblem(prob, jump, jump2; vr_aggregator=VR_FRM(), rng)
sol_vrfrm = solve(jump_prob_vrfrm, Tsit5())

jump_prob_vrdirect = JumpProblem(prob, jump, jump2; vr_aggregator=VR_Direct(), rng)
sol_vrdirect = solve(jump_prob_vrdirect, Tsit5())

jump_prob_vrdirectfw = JumpProblem(prob, jump, jump2; vr_aggregator=VR_DirectFW(), rng)
sol_vrdirectfw = solve(jump_prob_vrdirectfw, Tsit5())
```

This example shows how to use different `vr_aggregator` methods to simulate a system where the state decreases by half at random times, driven by a state-dependent rate.

### Example 2: Ensemble Simulation with Birth and Death Jumps
This example runs an ensemble simulation of an ODE with birth and death jumps, computing the mean state across trajectories.

```julia
using JumpProcesses, DiffEqBase, StableRNGs, Statistics

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define ODE (no continuous dynamics)
function ode_fxn(du, u, p, t)
    du .= 0
    nothing
end

# Define birth jump: ∅ → X
b_rate(u, p, t) = u[1] * p[1]  # Birth rate proportional to state
birth!(integrator) = (integrator.u[1] += 1; nothing)
b_jump = VariableRateJump(b_rate, birth!)

# Define death jump: X → ∅
d_rate(u, p, t) = u[1] * p[2]  # Death rate proportional to state
death!(integrator) = (integrator.u[1] -= 1; nothing)
d_jump = VariableRateJump(d_rate, death!)

# Set up problem
u0 = [1.0]  # Initial state
tspan = (0.0, 4.0)
p = [2.0, 1.0]  # Birth and death rates
prob = ODEProblem(ode_fxn, u0, tspan, p)

# Run ensemble simulation
Nsims = 1000
jump_prob = JumpProblem(prob, b_jump, d_jump; vr_aggregator=VR_FRM(), rng)
ensemble = EnsembleProblem(jump_prob)
sol = solve(ensemble, Tsit5(), trajectories=Nsims, save_everystep=false)

# Compute mean state at end
mean_state = mean(sol.u[i][1] for i in 1:Nsims)
println("Mean state at t=$(tspan[2]): $mean_state")
```

This example models a birth-death process and computes the average state across 1000 trajectories, showcasing the use of `vr_aggregator` in ensemble simulations.

# GPU-Enhanced SimpleTauLeaping Ensemble Solver

The `SimpleTauLeaping` solver leverages GPU parallelism to accelerate large-scale ensemble simulations by approximating multiple jump events in a single time step, significantly reducing computational cost for systems with high event rates.

## Key Contributions
- **GPU Kernels for SimpleTauLeaping ([PR #490](https://github.com/SciML/JumpProcesses.jl/pull/490), Merged)**: Implemented parallelized leap steps for high performance on NVIDIA GPUs.
- **GPU-Compatible Poisson Sampling ([PR #512](https://github.com/SciML/JumpProcesses.jl/pull/512), Merged; [PR #54](https://github.com/SciML/PoissonRandom.jl/pull/54), Merged)**: Optimized Poisson random number generation for GPU-based jump events, enhancing simulation efficiency.

GPU enhancements parallelize these steps across thousands of trajectories, achieving up to 10x speedups for large ensemble simulations on NVIDIA GPUs.

## Practical Examples

### Example 1: SIR Model with Influx

This example simulates an SIR epidemiological model with an influx of susceptible individuals, comparing GPU and serial implementations of `SimpleTauLeaping`.

```julia
using JumpProcesses, DiffEqBase, StableRNGs, Statistics, CUDA

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define SIR model parameters
β = 0.1 / 1000.0  # Infection rate
ν = 0.01           # Recovery rate
influx_rate = 1.0  # Influx rate
p = (β, ν, influx_rate)

# Define jump rates
regular_rate = (out, u, p, t) -> begin
    out[1] = p[1] * u[1] * u[2]  # β*S*I (infection)
    out[2] = p[2] * u[2]         # ν*I (recovery)
    out[3] = p[3]                # influx_rate
end

# Define state changes
regular_c = (dc, u, p, t, counts, mark) -> begin
    dc .= 0.0
    dc[1] = -counts[1] + counts[3]  # S: -infection + influx
    dc[2] = counts[1] - counts[2]   # I: +infection - recovery
    dc[3] = counts[2]               # R: +recovery
end

# Set up problem
u0 = [999.0, 10.0, 0.0]  # S, I, R
tspan = (0.0, 250.0)
prob_disc = DiscreteProblem(u0, tspan, p)
rj = RegularJump(regular_rate, regular_c, 3)
jump_prob = JumpProblem(prob_disc, PureLeaping(), rj)

# Run ensemble simulations
Nsims = 100_000
sol_gpu = solve(EnsembleProblem(jump_prob), SimpleTauLeaping(),
    EnsembleGPUKernel(CUDABackend()); trajectories=Nsims, dt=1.0)
mean_gpu = mean(sol.u[i][1, end] for i in 1:Nsims)

sol_serial = solve(EnsembleProblem(jump_prob), SimpleTauLeaping(),
    EnsembleSerial(); trajectories=Nsims, dt=1.0)
mean_serial = mean(sol.u[i][1, end] for i in 1:Nsims)
println("GPU mean (S at t=$(tspan[2])): $mean_gpu, Serial mean: $mean_serial")
```

### Example 2: SEIR Model with Exposed Compartment
This example simulates an SEIR epidemiological model with an exposed compartment, using `SimpleTauLeaping` with GPU acceleration.

```julia
using JumpProcesses, DiffEqBase, StableRNGs, Statistics, CUDA

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define SEIR model parameters
β = 0.3 / 1000.0  # Infection rate
σ = 0.2           # Progression rate
ν = 0.01          # Recovery rate
p = (β, σ, ν)

# Define jump rates
regular_rate = (out, u, p, t) -> begin
    out[1] = p[1] * u[1] * u[3]  # β*S*I (infection)
    out[2] = p[2] * u[2]         # σ*E (progression)
    out[3] = p[3] * u[3]         # ν*I (recovery)
end

# Define state changes
regular_c = (dc, u, p, t, counts, mark) -> begin
    dc .= 0.0
    dc[1] = -counts[1]           # S: -infection
    dc[2] = counts[1] - counts[2] # E: +infection - progression
    dc[3] = counts[2] - counts[3] # I: +progression - recovery
    dc[4] = counts[3]            # R: +recovery
end

# Set up problem
u0 = [999.0, 0.0, 10.0, 0.0]  # S, E, I, R
tspan = (0.0, 250.0)
prob_disc = DiscreteProblem(u0, tspan, p)
rj = RegularJump(regular_rate, regular_c, 3)
jump_prob = JumpProblem(prob_disc, PureLeaping(), rj; rng=StableRNG(12345))

# Run ensemble simulations
Nsims = 100_000
sol_gpu = solve(EnsembleProblem(jump_prob), SimpleTauLeaping(),
    EnsembleGPUKernel(CUDABackend()); trajectories=Nsims, dt=1.0)
mean_gpu = mean(sol.u[i][end, end] for i in 1:Nsims)

sol_serial = solve(EnsembleProblem(jump_prob), SimpleTauLeaping(),
    EnsembleSerial(); trajectories=Nsims, dt=1.0)
mean_serial = mean(sol.u[i][end, end] for i in 1:Nsims)
println("GPU mean (R at t=$(tspan[2])): $mean_gpu, Serial mean: $mean_serial")
```

# Extending JumpProcesses.jl with τ-Leap Algorithms

The introduction of new `τ-leaping algorithms` extends JumpProcesses.jl to provide flexible and efficient methods for simulating jump processes, catering to diverse system dynamics, from non-stiff to highly stiff systems.

## Key Contributions
- **SimpleExplicitTauLeaping ([PR #513](https://github.com/SciML/JumpProcesses.jl/pull/513), Open)**: An explicit solver for non-stiff systems, offering fast simulations where stability is not a concern.
- **SimpleImplicitTauLeaping ([PR #500](https://github.com/SciML/JumpProcesses.jl/pull/500), Open)**: An implicit solver for stiff jump processes, ensuring stability in systems with large rate disparities.
- **SimpleAdaptiveTauLeaping ([PR #524](https://github.com/SciML/JumpProcesses.jl/pull/524), Open)**: An adaptive solver that dynamically adjusts leap sizes to balance accuracy and performance.

## Practical Examples

### Example 1: Birth-Death Process with Explicit τ-Leaping
This example simulates a non-stiff birth-death process using `SimpleExplicitTauLeaping`, suitable for systems with balanced rates.

```julia
using JumpProcesses, DiffEqBase, StableRNGs, Plots

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define birth-death system
function define_birth_death_system()
    c = (0.5, 0.5)  # Birth and death rates
    # Reaction 1: Birth (∅ → X)
    reactant_stoich1 = []  # No reactants consumed
    net_stoich1 = [Pair(1, 1)]  # X +1
    # Reaction 2: Death (X → ∅)
    reactant_stoich2 = [Pair(1, 1)]  # X consumed
    net_stoich2 = [Pair(1, -1)]  # X -1
    jumps = MassActionJump([c[1], c[2]], [reactant_stoich1, reactant_stoich2], 
                          [net_stoich1, net_stoich2])
    return jumps
end

# Set up problem
u0 = [10]  # Initial population
tspan = (0.0, 10.0)
prob = DiscreteProblem(u0, tspan, nothing)
jump_prob = JumpProblem(prob, PureLeaping(), define_birth_death_system())

# Solve with SimpleExplicitTauLeaping
sol_explicit = solve(jump_prob, SimpleExplicitTauLeaping(); saveat=0.01)
plot(sol_explicit, label="Population", title="Explicit Tau-Leaping: Birth-Death Process")
```

### Example 2: Stiff System with Implicit and Adaptive τ-Leaping
This example simulates a stiff chemical reaction system from Cao et al. (2007) using `SimpleImplicitTauLeaping` and `SimpleAdaptiveTauLeaping`.

```julia
using JumpProcesses, DiffEqBase, StableRNGs, Plots

# Set random seed for reproducibility
rng = StableRNG(12345)

# Define stiff system (Cao et al., 2007)
function define_stiff_system()
    c = (1000.0, 1000.0, 1.0)  # Rate constants
    # Reaction 1: S1 → S2
    reactant_stoich1 = [Pair(1, 1)]  # S1 consumed
    net_stoich1 = [Pair(1, -1), Pair(2, 1)]  # S1 -1, S2 +1
    # Reaction 2: S2 → S1
    reactant_stoich2 = [Pair(2, 1)]  # S2 consumed
    net_stoich2 = [Pair(1, 1), Pair(2, -1)]  # S1 +1, S2 -1
    # Reaction 3: S2 → S3
    reactant_stoich3 = [Pair(2, 1)]  # S2 consumed
    net_stoich3 = [Pair(2, -1), Pair(3, 1)]  # S2 -1, S3 +1
    jumps = MassActionJump([c[1], c[2], c[3]], [reactant_stoich1, reactant_stoich2, reactant_stoich3], 
                          [net_stoich1, net_stoich2, net_stoich3])
    return jumps
end

# Set up problem
u0 = [100, 0, 0]  # S1=100, S2=0, S3=0
tspan = (0.0, 5.0)
prob = DiscreteProblem(u0, tspan, nothing)
jump_prob = JumpProblem(prob, PureLeaping(), define_stiff_system())

# Solve with SimpleImplicitTauLeaping
sol_implicit = solve(jump_prob, SimpleImplicitTauLeaping(); saveat=0.01)
plot(sol_implicit, label=["S1" "S2" "S3"], title="Implicit Tau-Leaping")

# Solve with SimpleAdaptiveTauLeaping
sol_adaptive = solve(jump_prob, SimpleAdaptiveTauLeaping(); saveat=0.001)
plot(sol_adaptive, label=["S1" "S2" "S3"], title="Adaptive Tau-Leaping")
```

# Future Work Includes

These contributions lay the foundation for further advancements in JumpProcesses.jl:

- **Merging τ-Leap Algorithms**: Finalize and merge SimpleExplicitTauLeaping, SimpleImplicitTauLeaping, and SimpleAdaptiveTauLeaping to make them available to users.
- **Benchmarking**: Complete performance evaluations for τ-leaping algorithms in SciMLBenchmarks.jl to quantify their benefits.
- **Documentation**: Develop comprehensive documentation, including usage guides and performance tips for τ-leaping algorithms.
- **GPU-Enhanced SSAStepper**: Extend GPU support to the SSAStepper for exact stochastic ensemble simulations, complementing the approximate τ-leaping methods.

These developments enhance the SciML ecosystem’s capabilities for stochastic modeling, providing researchers with powerful tools for simulating complex systems.

# Acknowledgments
Thankyou [Professor Dr. Samuel A. Isaacson](https://github.com/isaacsas) and [Dr. Christopher Rackauckas](https://github.com/ChrisRackauckas), for your incredible guidance and support throughout the SciML Fellowship program. Your expertise, encouragement, and constructive feedback during this fellowship is invaluable in helping me navigate the complexities of the project. Your mentorship not only enhanced my technical skills but also inspired me to grow as a contributor to the open-source community. Thank you for your time, patience, and dedication to my learning journey!