### 0.2.1 (Upcoming Release)


### 0.2.1

- Export JuMP and HiGHS for external use
- Fix documentation of CpmActivity
- Fix documentation of Knapsack solver
- Implement Johnson's Rule for Flow Shop Scheduling problems (for m = 2, 3, ... machines)


### 0.2.0 

- Iterations for single `solve()` method for many problems to provide a uniform way, e.g., `solve(p)` and `solve(r)` should work at the same time where `p` and `r` would be `TransportationProblem`, `AssignmentProblem`, `ShortestPathProblem`, `MaximumFlowProblem`, `MstProblem`, `KnapsackProblem`, etc.

- In the release iterations, some of the methods will be removed so this release is planned to be a breaking one.
- Make `cpm` and `pert` solvable using `solve(::CpmProblem)` and `solve(::PertProblem)`.
- Update documentation


### 0.1.8

- pmedian now returns a PMedianResult object rather than a Dict{String, Any}.
- Implement knapsack() for solving the classical Knapsack problem using mathematical optimization.

### 0.1.7

- Add pmedian_with_distances for calculating p-median problems with predefined distance matrices


### 0.1.6 

- Add Latex support for Transportation tables
- Pretty printing simplex iterations
- Automatic calculation of objective value by iterations and manual calculation code is removed
- Non-negativity conditions of models in the definition stage

### 0.1.5 

- Add objective value in Simplex iterations
- $\LaTeX$ support for outputting simplex iterations

### 0.1.4 

- Numbers rounded with 3 decimal points in Simplex iterations.

### 0.1.3 

- Add tests for PERT
- Implement Simplex. Note that the implemented algorithm does not depend on JuMP and any solver. All of the Simplex iterations can be reported. Unbounded variables are not supported, that is, all of the decision variables are supposed to be $x_i \ge 0$. Maximum and minimum objective types, $\ge, \le, =$ type constraints are supported. This implementation is for educational purposes and it isn't implemented in an
efficient way. 


### 0.1.2  

- Add pert() for Project Evaluation and Review Technique (PERT)


### 0.1.1 

- Add/update documentation
- Add mst() for minimum spanning tree
- Add cpm() for critical path method

### 0.1.0 

- Transportation problem definition
- Linear programming solution of transportation problems 
- Linear programming solution of shortest path problem
- Linear programming solution of maximum flow problem
- Linear programming solution of assignment problem
- Linear programming solution of 2-players zero-sum game (Mostly copy-pasted from our JMcDM)
- Default solver changed from GLPK to HiGHS
- p-median problem and its linear programming solution  

  
  
