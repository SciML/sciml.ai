@def rss_pubdate = Date(2016,12, 21)
@def rss = """ OrdinaryDiffEq v0.5 """
@def published = "21 December 2016"
@def title = "OrdinaryDiffEq v0.5"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""  

OrdinaryDiffEq.jl has received two tags. This latest tag, v0.5, adds compatibility with the latest Julia v0.6 nightly (similar changes have been added to many solvers like StochasticDiffEq.jl on master, but have not yet been tagged).

But the main changes of this update are bug fixes to saveat and improved Rosenbrock methods. There was a bug in `saveat` such that for large changes in `dt` there could be oscillations in the output. Also, errors would occur if values of `saveat` matched `tstops`. Both of these bugs have been fixed, and `saveat` should work properly with all combinations of `tstops`, `save_timeseries`, and `dense`, letting you mix and match the behavior.

In addition, the `Rosenbrock23` and `Rosenbrock32` methods have received some updates. There have been some minor performance improvements, but more importantly the Rosenbrock methods now have a "stiff-safe" interpolant. Before it had used the standard 3rd order Hermite interpolation, which "in theory" since it's order 3 was "good enough", but in reality for really stiff equations this showed oscillations. A new interpolation has been placed on this method which utilizes the internal steps to not oscillate (and have less error) on stiff equations, making these Rosenbrock methods now a very good general method for stiff equations with dense (continuous) output.

Coming soon are even more improvements to performance for these methods,
(finally) the ability to pass arbitrary linear solvers, and full usage of the "Performance Overloads". In addition, I am working on getting these working with more types (Unitful types, complex numbers, changing size problems). Once these Rosenbrock methods are fully optimized and integrated with this extra functionality, I'll be implementing higher order Rosenbrock methods in the same manner. This should give a really complete story for stiff equations, with the LSODA, Sundials, and DASSL available for BDF methods. 
