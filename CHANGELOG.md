### 0.1.4 (Upcoming release) 

### 0.1.3 

- Add tests for PERT
- Implement Simplex. Note that the implemented algorithm does not depend on JuMP and any solver. All of the Simplex iterations can be reported. Unbounded variables are not supported, that is, all of the decision variables are supposed to be $x_i \ge 0$. Maximum and minimum objective types, $\ge, \le, \eq$ type constraints are supported. This implementation is for educational purposes and it isn't implemented in an
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

  
  