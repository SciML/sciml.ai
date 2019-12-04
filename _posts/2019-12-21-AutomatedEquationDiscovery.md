---
layout: post
title:  "DifferentialEquations.jl v6.10.0: Automated Multi-GPU Implicit ODE Solving, SciPy/R Bindings"
date:   2019-12-3 12:00:00
categories:
---

## Automated Discovery of Differential Equations from Data with DataDrivenDiffEq.jl

Give us timeseries data, and we will give you a TeX'd equation for the differential
equations that generated the data. Driven by Julius Martensen (@AlCap23), the
new DataDrivenDiffEq.jl module makes this a reality. Automatically learn equations
with SInDy or develop linear approximations to differential equations directly
from data with Koopman operator approaches like Extended Dynamic Mode Decomposition
(eDMD). For more information on doing this, consult
[the new documentation page on structural estimation](https://docs.juliadiffeq.org/latest/analysis/structural_estimation/)
