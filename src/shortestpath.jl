module ShortestPath

using JuMP, HiGHS

using ..Network

struct ShortestPathResult
    path::Array{Connection,1}
    cost::Float64
end



function solve(cns::Array{Connection,1})

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
        for i = 1:length(lst)
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

export solve

end # end of module Shortest Path
