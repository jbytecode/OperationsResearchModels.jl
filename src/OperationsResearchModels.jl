module OperationsResearchModels


# Default Optimizer 
using HiGHS
const theoptimizerpackage = Symbol("HiGHS")
const theoptimizer = HiGHS.Optimizer

include("network.jl")
include("transportation.jl")
include("assignment.jl")
include("shortestpath.jl")
include("maximumflow.jl")
include("game.jl")
include("mst.jl")
include("pmedian.jl")

import .Network
import .Transportation
import .Assignment 
import .ShortestPath
import .MaximumFlow 
import .Game
import .MinimumSpanningTree
import .PMedian

import .Transportation: TransportationProblem, TransportationResult, balance, isbalanced
import .ShortestPath: ShortestPathResult
import .Network:  Connection, ShortestPathProblem, MaximumFlowProblem
import .MaximumFlow: MaximumFlowResult
import .Assignment: AssignmentProblem, AssignmentResult
import .Game: game, GameResult
import .MinimumSpanningTree: hasloop
import .PMedian: pmedian

export TransportationProblem, TransportationResult, balance, isbalanced
export Connection, ShortestPathResult, MaximumFlowResult 
export ShortestPathProblem, MaximumFlowProblem
export AssignmentProblem, AssignmentResult
export game, GameResult
export hasloop
export pmedian 

"""
    solve(t)

# Arguments 
`a::TransportationProblem`: The problem in type of TransportationProblem

# Output 
`TransportationResult`: The custom data type that holds problem, solution, and optimum cost. 

# Description 
Solves a transportation problem given by an object of in type `TransportationProblem`.

# Example 

```julia
julia> t = TransportationProblem(
                   [   1 1 1 1; 
                       2 2 2 2; 
                       3 3 3 3], 
                   [100, 100, 100, 100], # Demands 
                   [100, 100, 100])      # Supplies 
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100]

julia> isbalanced(t)
false

julia> result = solve(t)
Transportation Results:
Main problem:
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100]

Balanced problem:
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3; 0 0 0 0]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100, 100]

Cost:
600.0
Solution:
[-0.0 -0.0 -0.0 100.0; 100.0 -0.0 -0.0 -0.0; -0.0 -0.0 100.0 -0.0; -0.0 100.0 -0.0 -0.0]
```
"""
solve(t::TransportationProblem) = Transportation.solve(t)


"""
    solve(a)

# Arguments 
`a::AssignmentProblem`: The problem in type of AssignmentProblem

# Output 
`AssignmentResult`: The custom data type that holds problem, solution, and optimum cost. 

# Description 
Solves an assignment problem given by an object of in type `AssignmentProblem`.

# Example 

```julia
julia> mat = [
                   4 8 1;
                   3 1 9;
                   1 6 7;
               ];

julia> problem = AssignmentProblem(mat);

julia> result = solve(problem);

julia> result.solution

3×3 Matrix{Float64}:
 0.0  0.0  1.0
 0.0  1.0  0.0
 1.0  0.0  0.0

julia> result.cost

3.0
```
"""
solve(a::AssignmentProblem) = Assignment.solve(a)


"""
    solve(c; problem = ShortestPathProblem)

# Arguments 
- `c::Vector{Connection}`: Vector of connections 
- `problem`: Type of problem. Either `ShortestPathProblem` or `MaximumFlowProblem`

# Example 
```julia 
julia> conns = [
                   Connection(1, 2, 3),
                   Connection(1, 3, 2),
                   Connection(1, 4, 4),
                   Connection(2, 5, 3),
                   Connection(3, 5, 1),
                   Connection(3, 6, 1),
                   Connection(4, 6, 2),
                   Connection(5, 7, 6),
                   Connection(6, 7, 5),
               ];

julia> solve(conns, problem = ShortestPathProblem);

julia> result.path
3-element Vector{Connection}:
 Connection(1, 3, 2, "x13")
 Connection(3, 6, 1, "x36")
 Connection(6, 7, 5, "x67")

julia> result.cost
8.0

julia> result = solve(conns, problem = MaximumFlowProblem);

julia> result.path
9-element Vector{Connection}:
 Connection(1, 2, 3.0, "x12")
 Connection(1, 3, 2.0, "x13")
 Connection(1, 4, 2.0, "x14")
 Connection(2, 5, 3.0, "x25")
 Connection(3, 5, 1.0, "x35")
 Connection(3, 6, 1.0, "x36")
 Connection(4, 6, 2.0, "x46")
 Connection(5, 7, 4.0, "x57")
 Connection(6, 7, 3.0, "x67")

julia> result.flow
7.0

```
"""
function solve(c::Array{Connection, 1}; problem = ShortestPathProblem) 
    if problem == ShortestPathProblem
        return ShortestPath.solve(c)
    elseif problem == MaximumFlowProblem
        return MaximumFlow.solve(c)
    else
        error(string("Could not find problem type: ", string(problem)))
    end
end 

export solve 

end # end of module
