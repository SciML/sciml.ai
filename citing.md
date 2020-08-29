@def title = "SciML Scientific Machine Learning Citations"
@def hascode = true
@def date = Date(2019, 3, 22)
@def rss = "Citations for the SciML Scientific Machine Learning software organization"

@def tags = ["syntax", "code"]

# Citing SciML Scientific Machine Learning Software

To credit the SciML software, please star the repositories that you would
like to support. If you use SciML software as part of your research, teaching, or other activities,
we would be grateful if you could cite our work. Since SciML is a collection of individual
modules, in order to give proper credit please cite **each related component**.

To give proper academic credit, all software should be cited.
[See this link for more information on citing software](https://openresearchsoftware.metajnl.com/about/#q11).
Listed below are BibTex citations corresponding to portions of the SciML
software tools. For software which do not have publications, recommended
citations are also included. If you have any questions about citations,
please feel free to [ask in the community channels](/community.html).

## SciML Publications

#### DifferentialEquations.jl

```
@article{rackauckas2017differentialequations,
  title={Differentialequations.jl--a performant and feature-rich ecosystem for solving differential equations in julia},
  author={Rackauckas, Christopher and Nie, Qing},
  journal={Journal of Open Research Software},
  volume={5},
  number={1},
  year={2017},
  publisher={Ubiquity Press}
}
```

#### Automated Solver Selection

```
@article{rackauckas2019confederated,
  title={Confederated modular differential equation APIs for accelerated algorithm development and benchmarking},
  author={Rackauckas, Christopher and Nie, Qing},
  journal={Advances in Engineering Software},
  volume={132},
  pages={1--6},
  year={2019},
  publisher={Elsevier}
}
```

#### Stochastic Differential Equations

```
@article{rackauckas2017adaptive,
  title={Adaptive methods for stochastic differential equations via natural embeddings and rejection sampling with memory},
  author={Rackauckas, Christopher and Nie, Qing},
  journal={Discrete and continuous dynamical systems. Series B},
  volume={22},
  number={7},
  pages={2731},
  year={2017},
  publisher={NIH Public Access}
}
```

```
@article{rackauckas_stability-optimized_2018,
	title = {Stability-{Optimized} {High} {Order} {Methods} and {Stiffness} {Detection} for {Pathwise} {Stiff} {Stochastic} {Differential} {Equations}},
	url = {http://arxiv.org/abs/1804.04344},
	journal = {arXiv:1804.04344 [math]},
	author = {Rackauckas, Christopher and Nie, Qing},
	year = {2018},
}
```

#### Stochastic Delay Differential Equations

```
@article{sykora2020stochasticdelaydiffeq,
  title={StochasticDelayDiffEq. jl-An Integrator Interface for Stochastic Delay Differential Equations in Julia},
  author={Sykora, Henrik T and Rackauckas, Christopher V and Widmann, David and Bachrathy, D{\'a}niel},
  year={2020}
}
```

#### Sensitivity Analysis and Adjoints

```
@article{rackauckas2018comparison,
  title={A comparison of automatic differentiation and continuous sensitivity analysis for derivatives of differential equation solutions},
  author={Rackauckas, Christopher and Ma, Yingbo and Dixit, Vaibhav and Guo, Xingjian and Innes, Mike and Revels, Jarrett and Nyberg, Joakim and Ivaturi, Vijay},
  journal={arXiv preprint arXiv:1812.01892},
  year={2018}
}
```

#### Neural Differential Equations and Universal Differential Equations (DiffEqFlux.jl)

```
@article{rackauckas2019diffeqflux,
  title={Diffeqflux.jl-A julia library for neural differential equations},
  author={Rackauckas, Chris and Innes, Mike and Ma, Yingbo and Bettencourt, Jesse and White, Lyndon and Dixit, Vaibhav},
  journal={arXiv preprint arXiv:1902.02376},
  year={2019}
}
```

```
@article{rackauckas2020universal,
  title={Universal Differential Equations for Scientific Machine Learning},
  author={Rackauckas, Christopher and Ma, Yingbo and Martensen, Julius and Warner, Collin and Zubov, Kirill and Supekar, Rohit and Skinner, Dominic and Ramadhan, Ali},
  journal={arXiv preprint arXiv:2001.04385},
  year={2020}
}
```

#### Automated Sparsity Detection (SparsityDetection.jl)

```
@article{gowda2019sparsity,
  title={Sparsity Programming: Automated Sparsity-Aware Optimizations in Differentiable Programming},
  author={Gowda, Shashi and Ma, Yingbo and Churavy, Valentin and Edelman, Alan and Rackauckas, Christopher},
  year={2019}
}
```

## Algorithm Citations

Many of the algorithms which are included as part of this ecosystem of software
packages originated as part of academic research. If you know which algorithms
were used in your work, please use this as a reference for determining additional
citations. These citations are provided in the docstrings for the solvers,
i.e. `?Tsit5`.
