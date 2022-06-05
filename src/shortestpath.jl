module ShortestPath

using JuMP, GLPK

struct Connection
    from::Int64
    to::Int64
    cost::Any
    varsym::Any
    Connection(from, to, cost) = new(from, to, cost, string("x", from, to))
end

struct ShortestPathResult 
    path::Array{Connection, 1}
    cost::Float64
end 

function nodes(cns::Array{Connection,1})::Set{Int64}
    s = Set{Int64}()
    for conn in cns
        push!(s, conn.from)
        push!(s, conn.to)
    end
    return s
end

function iseveronleft(cns::Array{Connection,1}, n::Int64)::Bool
    for conn in cns
        if conn.from == n
            return true
        end
    end
    return false
end

function iseveronright(cns::Array{Connection,1}, n::Int64)::Bool
    for conn in cns
        if conn.to == n
            return true
        end
    end
    return false
end

function finish(cns::Array{Connection,1})::Int64
    nodeset = nodes(cns)
    for n in nodeset
        if !iseveronleft(cns, n)
            return n
        end
    end
    error("No start node found in connection list.")
end

function start(cns::Array{Connection,1})::Int64
    nodeset = nodes(cns)
    for n in nodeset
        if !iseveronright(cns, n)
            return n
        end
    end
    error("No start node found in connection list.")
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
            return 0
        end
        expr = @expression(model, 0)
        for i = 1:length(lst)
            expr += x[lst[i].from, lst[i].to]
        end
        return expr
    end


    model = Model(GLPK.Optimizer)
    mynodes = nodes(cns)
    n = length(mynodes)

    startnode = start(cns)
    finishnode = finish(cns)

    # Variables 
    @variable(model, x[1:n, 1:n], Bin)

    # Objective Function
    obj_expr = @expression(model, 0)
    for conn in cns
        obj_expr = obj_expr + x[conn.from, conn.to] * conn.cost
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
