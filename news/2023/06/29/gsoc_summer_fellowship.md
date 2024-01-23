@def rss_pubdate = Date(2023,6,29)
@def rss = """2023 Google Summer of Code and SciML's Summer Fellowship!"""
@def published = " 29 June 2023 "
@def title = "2023 Google Summer of Code and SciML's Summer Fellowship!"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# 2023 Google Summer of Code and SciML's Summer Fellowship!

Interested in what work is going on over the summer? Meet our top students who are describing their fellowship and GSoC projects!

## Qingyu Qu: Adaptive MIRK BVP Solvers

Project description: My GSoC project is Adaptive MIRK BVP Solvers, this project focuses on improving the SciML diffeq solvers, especially the BVP solvers. For now, there are only Shooting methods and MIRK methods in BoundaryValueDiffEq.jl, although the MIRK solvers are working fine, there is still a lot we could improve. This summer, I will add the defect control techniques to the current MIRK solvers and make these solvers adaptive. According to the defect estimate, we can redistribute the mesh to diminish the defect and achieve more accurate solutions and avoid extra computations. Additionally, I will also add more test problems, benchmarks, and documentation for SciML BVP solvers.

About me: My name is Qingyu Qu(曲庆宇), I just graduated from Shandong University and will pursue my master's degree in Zhejiang University in control theory. I am interested in numerical algorithms for differential equations and scientific machine learning. I am really excited to participate in SciML GSoC this year, wish us a happy summer!

![image](https://github.com/SciML/sciml.ai/assets/1814174/c7f90fd0-7e23-4c82-9a0a-691bec480081)

## Astitva Aggarwal: Adding Uncertainty Quantification via the Bayesian framework to NeuralPDE.jl

Project Description: I will be working on adding Uncertainty Quantification via the Bayesian framework to the NeuralPDE.jl package, essentially facilitating use of Bayesian Physics Informed Neural Networks Solvers for Inverse and forward nonlinear PDE, ODE problems.BPINNs in addition to being able to quantify aleatoric uncertainty arising from noisy data obtain more accurate predictions than PINNs in scenarios with large noise due its capability of avoiding overfitting. I will be using Markov Chain Monte Carlo algorithms for effective sampling from posteriors of model parameters. The Turing.jl ecosystem provides a general-purpose probabilistic programming language,tools for this. Additionally benchmarks and documentation for the BPINN solvers will be added.

About me: My name is Astitva Aggarwal, a third year undergraduate in Computer Engineering at VJTI, Mumbai. I am interested in evolutionary algorithms,computational statistics for differential equations and scientific machine learning. I am grateful for being in the SciML fellowship program. I look forward to learning and exploring!

![image](https://github.com/SciML/sciml.ai/assets/1814174/9825b7ba-2c12-4b44-b5c1-c66f516e1eea)

## Criston Hyett: Improved Automatic Discretizations of PDESystems

Project Description: I'm working to implement some common bookkeeping to enable discretization and solution of PDEs on networks. I hope to have the package be largely transparent, and inherit all of the good things about DifferentialEquations.jl with minimal overhead, while enabling natural inspection and easy extensibility.

About me: I am a 4th year Applied Mathematics PhD student at the University of Arizona. I'm based in sunny Tucson AZ, and enjoy hiking and biking when I'm not writing software. My research interests are somewhat broad, but revolve around data-enhanced dynamical systems modeling. I've been a long admirer of the Julia ecosystem, and am excited to contribute with yall!

![profile](https://github.com/SciML/sciml.ai/assets/1814174/31db74fc-0a5f-40f3-a4e4-2d7947b1f7b7)

## Lalit Chauhan: PubChemReactions.jl, automated chemical data extraction for Catalyst using the PubChem API

Project description: I will be working towards the creation of a new package named PubChemReactions.jl that will enable the user to fetch chemical data on compounds using the PubChem API. It will then be integrated into the existing library Catalyst.jl to improve upon its functionalities, further leading to improved accuracy in identifying chemical species and enzymes in reaction networks. I plan on implementing exciting features such as automatic stoich balancing for chemical reactions, the ability to simulate chemical pathways etc.

About me: I am a 3rd year Computer Science Engineering student from JECRC University, Jaipur. I enjoy gaming, watching Formula 1 and reading about military technology and war politics. I love all animals, but mostly my dog. I am minoring in Cyber Security but am excited to explore this relatively new field of scientific machine learning and contribute to the Julia ecosystem.

![Lalit_Chauhan](https://github.com/SciML/sciml.ai/assets/1814174/5186549d-728e-4fdc-a3f9-7ce59e4e53c0)

## Yash Raj: Improving NonlinearSolve.jl

My Project: I would be working majorly on NonlinearSolve.jl, adding some new methods and enhancing the previous ones. The enhancements will be done in making the methods faster and more robust. I am going to implement new radius update schemes for the Trust Regions method and test their convergence in comparison to the conventional method. It will also be very interesting to explore a multi-initialization approach in Trust regions to make it a 'global root finder', which I am going to do. In Newton-Raphson, the goal will be to implement some line-search algorithms as well as integrate them fully with the Jacobian-free Krylov subspace linear solver. Finally, I will implement a derivative-free fast version of Halley's method (using some AD tricks) which is known to converge faster than Newton-Raphson (although there are several caveats to this claim). I will also start the appropriate benchmarking of the package.

About me: I completed my Bachelor's degree in India and currently, I am studying Applied Mathematics at the Technical University of Munich in Germany. I started contributing about two months back and absolutely fell in love with it. When I am not studying, I like to work out, play the piano (and sing :)) and go on hikes. I am very excited to be a part of the SciML Summer Fellowship and I hope to get to know all of you through it. Here is a photo of me on a trek in the Indian Himalayas :)

![](https://user-images.githubusercontent.com/1814174/249878468-97b52c09-bec6-466e-9898-3f1d6e8ac118.png)

## Samedh Desai: Improvements to NeuarlPDE.jl's ODE/DAE/etc. Support

My Project: I have been in contact with Chris about continuing to contribute with the lab as a part of GSoC on some different projects. One of these potential projects would be exploring new neural networks training strategies or improvements to existing strategies for solving ordinary differential equation (ODE) problems. A potential example of an improvement could be adding a standard loss function to the PINN loss. This added loss can be useful in various applications because it can push us away from the standard PDE solution from the PINN loss if the data suggests otherwise. This is effectively a method of regularization that pushes the PINN loss towards a more appropriate physical outcome, which can be useful in some contexts. I have also been in touch with a Julia Lab mentor named Alex Jones about a potential collaboration in the near future. I would like to work with him on developing a new and improved front end parser for solving partial differential equations (PDEs). Our goal is to apply the powerful symbolics interface by using rewriter chains to rebuild loss function generation.

About me: My name is Samedh Desai and I am a third year undergraduate student at the University of Washington, Seattle. By taking several courses about Artificial Intelligence and Machine Learning at my university and online, I have developed a keen passion in these areas. I am excited to pursue these interests by participating in the SciML fellowship at the Julia Lab.

![image](https://github.com/SciML/sciml.ai/assets/1814174/3f89db17-3c7e-481e-8463-2dfdf2d90d6a)

## Sagar Arora: Efficient Mesh-Free Solvers in NeuralPDE.jl

Project Description: I will mainly be focusing on developing efficient mesh-free solvers (Deep Galerkin and Deep Ritz algorithms) for high dimension PDEs. As meshing becomes infeasible in higher dimensions, these algorithms approximate the PDEs by training the neural network on batches of randomly sampled time and space points. So, essentially we would be trying to approximate the solution by a neural network instead of a combination of basis functions.  The latter part of my project will be focused on developing interfaces for solving PDEs on general domains/complex geometries. For this, I have been trying to understand the interplay between PDEBase, MOL and SymbolicUtils packages to understand the PDE parsing methodology. Appropriate benchmarks and documentation will also be added for the solvers developed as part of the project.

About me: I'm Sagar Arora. I am pursuing my Master's degree in IIT Kanpur focused on computational math. I have only recently been introduced to machine learning concepts revolving around PDEs and it has caught my eye ever since.

![image](https://github.com/SciML/sciml.ai/assets/1814174/b686a4d0-2190-487e-a059-d20c45fb60e7)

## Saravan Kumar: Improvements to OrdinaryDiffEq.jl

Project Description: My project aims to optimize Ordinary Differential Equation (ODE) solvers in the OrdinaryDiffEq.jl package to minimize precompilation times while maintaining solver efficiency. The current implementation incurs performance overhead due to the tableau form, resulting in longer compilation times. By leveraging code generation techniques and optimizing the interpolation process, the project seeks to reduce this overhead and enhance solver performance. The plan involves updating the ODETableau constructor to support interpolation coefficients, adding interpolation coefficients to specific tableaus, and implementing interpolation overloads for ExplicitRK similarly, it is extended to Rosenbrock and SDIRK and performing comprehensive performance testing and benchmarking.

About Me:  My name is Saravan Kumar, and I am currently pursuing my Master's degree at Cranfield University, United Kingdom. With a background in physics and a strong inclination towards computational methods, my research interests revolve around computational modelling in physics using differential equations and predicting the behaviour of physical systems, particularly in the context of robotics and manufacturing processes. In addition to my studies, I like to explore various places in the UK, try out new recipes in the kitchen, and enjoy watching and playing football.

![IMG_0215](https://github.com/SciML/sciml.ai/assets/1814174/910eebc0-7948-480e-8640-fe7884e4559f)