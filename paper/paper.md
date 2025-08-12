---
title: "OperationsResearchModels.jl: A Julia package for operations research models"
tags:
  - Julia
  - Operations Research
  - Optimization
  - Linear Programming

authors:
  - name: "Mehmet Hakan Satman"
    orcid: 0000-0002-9402-1982
    affiliation: 1
affiliations:
  - name: "Department of Econometrics, Istanbul University, Turkiye"
    index: 1
date: June 18 2025
bibliography: paper.bib
---


# Summary

`OperationsResearchModels.jl` is a Julia package [@julia] that offers comprehensive implementations for numerous topics typically covered in an Operations Research (OR) curriculum. Its primary objective during development was to serve academic and pedagogical purposes, providing a clear and accessible platform for learning and applying OR concepts. While not optimized for high-performance computing, the package leverages JuMP for its underlying mathematical modeling, which inherently provides a reasonable level of computational efficiency. This design allows the package to deliver a suite of functions that solve classical operations research problems with remarkable ease and consistency, simplifying the process for students and researchers alike.

# State of the field

Gurobi OptiMods is an open-source Python package that provides pre-implemented optimization use cases built on the Gurobi solver. Each module includes comprehensive documentation detailing its application and the underlying mathematical model [@gurobi-optimods]. Julia's `Graphs.jl` [@Graphs2021] package provides efficient methods for important network analysis topics such as minimal spanning tree and the shortest path. 

# Statement of Need

JuMP [@JuMP] provides an excellent interface and macros for uniformly accessing optimizer functionality. Any mathematical optimization problem can be assembled with three core components: the objective function (`@objective`), variable definitions (`@variable`), and constraints (`@constraints`). The researcher's role is to formulate the original problem as a mathematical optimization problem and then translate it using JuMP's macros.

OperationsResearchModels.jl streamlines the model translation stage by automatically constructing mathematical problems from problem-specific input data. Its extensive functionality encompasses a significant portion of the Operations Research domain. This includes, but is not limited to: the linear transportation problem, the assignment problem, the classical knapsack problem, various network models (Shortest Path, Maximum Flow, Minimum Cost-Flow, Minimum Spanning Tree), project management techniques (CPM and PERT), the uncapacitated p-median problem for location selection, Johnson's Rule for flow-shop scheduling, a genetic algorithm for scheduling problems intractable by Johnson's Rule, a zero-sum game solver, and a Simplex solver for real-valued decision variables.

Although the majority of computations are performed by the HiGHS optimizer [@HiGHS] through JuMP, OperationsResearchModels.jl incorporates dedicated, hand-coded Simplex routines. These routines serve a valuable pedagogical purpose in Operations Research curricula, enabling users to observe and verify the detailed, step-by-step calculations involved in solving linear programming problems.

# An Example

The example below defines a linear transportation problem with a given matrix 
of transportation costs between sources and targets, demand vector of targets, and 
supply vector of sources. 

```Julia
julia> problem = TransportationProblem(
            [
                1 5 7 8;
                2 6 4 9;
                3 10 11 12
            ],                    # Cost matrix
            [100, 100, 100, 100], # Demand vector
            [100, 100, 200],      # Supply vector
        )
```

The multiple-dispacthed `solve` function is responsible to solve many of the models implemented in the package. When the problem is in type of `TransportationProblem`, a special method called and the result is in type `TransportationResult`.

```Julia
julia> result = solve(problem);
julia> result.cost
2400.0
julia> result.solution
[0.0 100.0 0.0 0.0; 0.0 0.0 100.0 0.0; 100.0 -0.0 -0.0 100.0]
```

# Acknowledgements

Our deepest appreciation goes to the Julia core and package developers for creating such a powerful computational tool and supportive environment.

# References
