module ShortestPath

using JuMP, HiGHS

import ..OperationsResearchModels: solve

using ..Network


export ShortestPathProblem
export ShortestPathResult


struct ShortestPathProblem 
    connections::Array{Connection,1}
end 

struct ShortestPathResult
    path::Array{Connection,1}
    cost::Float64
end



"""
    solve(problem)

# Description

Solves a shortest path problem given by an object of in type `ShortestPathProblem`.

# Arguments

`problem::ShortestPathProblem`: The problem in type of ShortestPathProblem

# Output

`ShortestPathResult`: The custom data type that holds path and cost.

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
 Connection(1, 3, 2, "x13")
 Connection(3, 6, 1, "x36")
 Connection(6, 7, 5, "x67")

julia> result.cost
8.0
```
"""
function solve(problem::ShortestPathProblem)

    cns = problem.connections

    function leftexpressions(node::Int64, nodes::Array{Connection,1}, model)
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

    function rightexpressions(node::Int64, nodes::Array{Connection,1}, model)
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
        leftexpr = leftexpressions(nextnode, cns, model)
        rightexpr = rightexpressions(nextnode, cns, model)
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
