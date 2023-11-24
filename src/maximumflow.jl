module MaximumFlow

using ..Network

using JuMP, HiGHS


struct MaximumFlowResult
    path::Array{Connection,1}
    flow::Float64
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
            return :f
        end
        expr = @expression(model, 0)
        for i = 1:length(lst)
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
            return :f
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
    @variable(model, f)
    @variable(model, x[1:n, 1:n])

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
        @constraint(model, x[nd.from, nd.to] >= 0)
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

export solve

end # end of module
