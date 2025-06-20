module MaximumFlow

using ..Network

using JuMP, HiGHS
import ..OperationsResearchModels: solve


export MaximumFlowProblem
export MaximumFlowResult


struct MaximumFlowResult
    path::Vector{Connection}
    flow::Float64
end

struct MaximumFlowProblem
    connections::Vector{Connection}
end


"""

    solve(problem)

# Arguments

- `problem::MaximumFlowProblem`: The problem in type of MaximumFlowProblem

# Output

- `MaximumFlowResult`: The custom data type that holds path and flow.

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
julia> problem = MaximumFlowProblem(conns)
julia> result = solve(problem);

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
function solve(problem::MaximumFlowProblem)

    cns = problem.connections

    function leftexpressions(node::Int64, nodes::Vector{Connection}, model)
        lst = []
        for conn in nodes
            if conn.to == node
                push!(lst, conn)
            end
        end
        if length(lst) == 0
            return :f
        end
        expr = @expression(model, 0)
        for i = eachindex(lst)
            expr += x[lst[i].from, lst[i].to]
        end
        return expr
    end

    function rightexpressions(node::Int64, nodes::Vector{Connection}, model)
        lst = []
        for conn in nodes
            if conn.from == node
                push!(lst, conn)
            end
        end
        if length(lst) == 0
            return :f
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
    @variable(model, f)
    @variable(model, x[1:n, 1:n] .>= 0)

    # Objective Function
    @objective(model, Max, f)

    # Constraints 
    for nextnode in mynodes
        leftexpr = leftexpressions(nextnode, cns, model)
        rightexpr = rightexpressions(nextnode, cns, model)
        if leftexpr == :f
            @constraint(model, rightexpr == f)
        elseif rightexpr == :f
            @constraint(model, leftexpr == f)
        else
            @constraint(model, leftexpr - rightexpr == 0)
        end
    end

    for nd in cns
        @constraint(model, x[nd.from, nd.to] <= nd.value)
    end

    @constraint(model, f >= 0)

    optimize!(model)

    xs = value.(x)
    cost = JuMP.objective_value(model)
    solutionnodes = []
    for i = 1:n
        for j = 1:n
            if xs[i, j] > 0
                push!(solutionnodes, Connection(i, j, xs[i, j]))
            end
        end
    end

    return MaximumFlowResult(solutionnodes, cost)
end



end # end of module
