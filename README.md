[![Doc](https://img.shields.io/badge/docs-dev-blue.svg)](https://jbytecode.github.io/OperationsResearchModels.jl/dev/)
[![status](https://joss.theoj.org/papers/0f312c63cdc147d43c2b899478461769/status.svg)](https://joss.theoj.org/papers/0f312c63cdc147d43c2b899478461769)

# OperationsResearchModels.jl

A package for Operations Research problems.


# Installation 

```julia
julia> ]
(@v1.xx) pkg> add OperationsResearchModels
```

or 

```julia
julia> using Pkg
julia> Pkg.add("OperationsResearchModels")
```

If you want to install latest source that is not registered yet, you can 

```julia
julia> ]
(@1.xx) pkg> add https://github.com/jbytecode/OperationsResearchModels.jl
```

but it's not recommended.

# Documentation 

Please visit [The Documentation Page](https://jbytecode.github.io/OperationsResearchModels.jl/dev/). 
This page includes both the API documentation and examples.


# Implemented Problems and Algorithms

- [Assignment Problem](https://jbytecode.github.io/OperationsResearchModels.jl/dev/assignment/)
- [Transportation Problem](https://jbytecode.github.io/OperationsResearchModels.jl/dev/transportation/)
- [The Shortest Path](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Shortest-Path)
- [Maximum Flow](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Maximum-Flow)
- [Minimum Cost-Flow](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Minimum-Cost-Flow)
- [Minimum Spanning Tree](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Minimum-Spanning-Tree)
- [p-median for Location Selection](https://jbytecode.github.io/OperationsResearchModels.jl/dev/locationselection/)
- [CPM - Critical Path Method](https://jbytecode.github.io/OperationsResearchModels.jl/dev/project/#CPM-(Critical-Path-Method))
- [PERT - Project Evaluation and Review Technique](https://jbytecode.github.io/OperationsResearchModels.jl/dev/project/#PERT-(Project-Evaluation-and-Review-Technique))
- [The Knapsack Problem](https://jbytecode.github.io/OperationsResearchModels.jl/dev/knapsack/)
- [Johnson's Rule for Flow-Shop Scheduling](https://jbytecode.github.io/OperationsResearchModels.jl/dev/scheduling/#Johnson's-Rule-for-Flow-shop-Scheduling)
- [Flow-shop Scheduling using Permutation Encoded Genetic Algorithms (using a Random Key Genetic Algorithm)](https://jbytecode.github.io/OperationsResearchModels.jl/dev/scheduling/#Genetic-Algorithm-for-the-problems-that-cannot-be-solved-with-using-Johnson's-Rule)
- [Traveling Salesman with Random Key Genetic Algorithm](https://jbytecode.github.io/OperationsResearchModels.jl/dev/travelingsalesman/)
- [Simplex Method with Real Valued Decision Variables](https://jbytecode.github.io/OperationsResearchModels.jl/dev/simplex/)
- [2-player zero-sum game solver](https://jbytecode.github.io/OperationsResearchModels.jl/dev/game/)


# How to cite

Please use the citation info below if you use this package in your work. If you use a tex distribution you can cite with the bibtex entry

```bibtex
@article{Satman2025, 
    doi = {10.21105/joss.08592}, 
    url = {https://doi.org/10.21105/joss.08592}, 
    year = {2025}, 
    publisher = {The Open Journal}, 
    volume = {10}, 
    number = {113}, 
    pages = {8592}, 
    author = {Satman, Mehmet Hakan}, 
    title = {OperationsResearchModels.jl: A Julia package for operations research models}, 
    journal = {Journal of Open Source Software}
}
```

or within text editors:

> Satman, M. H., (2025). OperationsResearchModels.jl: A Julia package for operations research models. Journal of Open Source Software, 10(113), 8592, https://doi.org/10.21105/joss.08592


Thank you in advance for citing my work! 

# How to contribute

Please read the page [Contributing](https://github.com/jbytecode/OperationsResearchModels.jl/blob/main/CONTRIBUTING.md) before contributing.

# Notes for the users

The package is implemented for mostly academic purposes. The implementations are not optimized for large-scale problems. The users are encouraged to use the package for educational purposes and small-scale problems. 
