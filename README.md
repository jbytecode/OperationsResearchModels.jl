[![Doc](https://img.shields.io/badge/docs-dev-blue.svg)](https://jbytecode.github.io/OperationsResearchModels.jl/dev/)

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

# Documentation 

Please visit [https://jbytecode.github.io/OperationsResearchModels.jl/dev/](The Documentation Page). 
This page includes both the API documentation and examples.


# Implemented Problems and Algorithms

- [Assignment Problem](https://jbytecode.github.io/OperationsResearchModels.jl/dev/assignment/)
- [Transportation Problem](https://jbytecode.github.io/OperationsResearchModels.jl/dev/transportation/)
- [The Shortest Path](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Shortest-Path)
- [Maximum Flow](https://jbytecode.github.io/OperationsResearchModels.jl/dev/network/#Maximum-Flow)
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


# How to contribute

Please 

- First open an issue and share you idea 
- Discuss what is your purpose, what is the implementation details 
- Please provide tests from text books and any other problems that the result is known
- Use methods of `solve()` function if possible. That requires defining a structure of the given problem
- Define a struct to hold the solution
- The solution may rely on linear programming or other efficient algorithms such like in the transportation problem


# Notes for the users

The package is implemented for mostly academic purposes. The implementations are not optimized for large-scale problems. The users are encouraged to use the package for educational purposes and small-scale problems. 
