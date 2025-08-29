module ShortestPath

using JuMP, HiGHS

import ..OperationsResearchModels: solve

using ..Network


export ShortestPathProblem
export ShortestPathResult


"""
    ShortestPathProblem

# Description

Defines the shortest path problem.

# Fields

- `connections::Vector{Connection}`: The connections (edges) in the network.

"""
struct ShortestPathProblem 
    connections::Vector{Connection}
end 


"""
    ShortestPathResult

# Description

A structure to hold the result of the shortest path problem.

# Fields

- `path::Vector{Connection}`: The connections (edges) in the shortest path.
- `cost::Float64`: The total cost of the shortest path.

"""
struct ShortestPathResult
    path::Vector{Connection}
    cost::Float64
end



"""
    solve(problem)

# Description

Solves a shortest path problem given by an object of in type `ShortestPathProblem`.

# Arguments

- `problem::ShortestPathProblem`: The problem in type of ShortestPathProblem

# Output

- `ShortestPathResult`: The custom data type that holds path and cost.

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

julia> solve(ShortestPathProblem(conns));

julia> result.path
3-element Vector{Connection}:
 Connection(1, 3, 2)
 Connection(3, 6, 1)
 Connection(6, 7, 5)

julia> result.cost
8.0
```

# NOTE 

    In this function it's assumed that the problem has a unique start and finish node.
    A heuristic approach is used to find the start and finish nodes. If a node has only
    outcoming connections, it is considered the start node. If a node has only incoming connections,
    it is considered the finish node. Of course a network can have multiple start and finish nodes,
    but this heuristic simplifies the problem. Future implementations could explore more complex
    scenarios with multiple start and finish nodes. 
"""
function solve(problem::ShortestPathProblem)

    cns = problem.connections

    function inflow(node::Int64, nodes::Vector{Connection}, model)
        lst = []
        for conn in nodes
            if conn.to == node
                push!(lst, conn)
            end
        end
        if length(lst) == 0
            return 0
        end
        expr = @expression(model, 0)
        for i in eachindex(lst)
            expr += x[lst[i].from, lst[i].to]
        end
        return expr
    end

    function outflow(node::Int64, nodes::Vector{Connection}, model)
        lst = []
        for conn in nodes
            if conn.from == node
                push!(lst, conn)
            end
        end
        if length(lst) == 0
            return 0
        end
        expr = @expression(model, 0)
        for i = eachindex(lst)
            expr += x[lst[i].from, lst[i].to]
        end
        return expr
    end


    model = Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    mynodes = nodes(cns)
    n = length(mynodes)

    startnode = start(cns)
    finishnode = finish(cns)

    # Variables 
    @variable(model, x[1:n, 1:n], Bin)

    # Objective Function
    obj_expr = @expression(model, 0)
    for conn in cns
        obj_expr = obj_expr + x[conn.from, conn.to] * conn.value
    end
    @objective(model, Min, obj_expr)

    # Constraints 
    for nextnode in mynodes
        leftexpr = inflow(nextnode, cns, model)
        rightexpr = outflow(nextnode, cns, model)
        if nextnode in [startnode, finishnode]
            @constraint(model, leftexpr + rightexpr == 1)
        else
            @constraint(model, leftexpr == rightexpr)
        end
    end

    optimize!(model)

    xs = value.(x)
    cost = JuMP.objective_value(model)
    solutionnodes = []
    for i = 1:n
        for j = 1:n
            if xs[i, j] == 1
                indx = findfirst(x -> x.from == i && x.to == j, cns)
                push!(solutionnodes, cns[indx])
            end
        end
    end

    return ShortestPathResult(solutionnodes, cost)
end



end # end of module Shortest Path
