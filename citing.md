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
  pages={15},
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
@inproceedings{rackauckas2020stability,
  title={Stability-optimized high order methods and stiffness detection for pathwise stiff stochastic differential equations},
  author={Rackauckas, Chris and Nie, Qing},
  booktitle={2020 IEEE High Performance Extreme Computing Conference (HPEC)},
  pages={1--8},
  year={2020},
  organization={IEEE}
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
@INPROCEEDINGS{9622796,
  author={Ma, Yingbo and Dixit, Vaibhav and Innes, Michael J and Guo, Xingjian and Rackauckas, Chris},
  booktitle={2021 IEEE High Performance Extreme Computing Conference (HPEC)}, 
  title={A Comparison of Automatic Differentiation and Continuous Sensitivity Analysis for Derivatives of Differential Equation Solutions}, 
  year={2021},
  volume={},
  number={},
  pages={1-9},
  doi={10.1109/HPEC49654.2021.9622796}
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

#### Symbolic Modeling (ModelingToolkit.jl)

```
@misc{ma2021modelingtoolkit,
      title={ModelingToolkit: A Composable Graph Transformation System For Equation-Based Modeling},
      author={Yingbo Ma and Shashi Gowda and Ranjan Anantharaman and Chris Laughman and Viral Shah and Chris Rackauckas},
      year={2021},
      eprint={2103.05244},
      archivePrefix={arXiv},
      primaryClass={cs.MS}
}
```

## Algorithm Citations

Many of the algorithms which are included as part of this ecosystem of software
packages originated as part of academic research. If you know which algorithms
were used in your work, please use this as a reference for determining additional
citations. These citations are provided in the docstrings for the solvers,
i.e. `?Tsit5`.
