module Network

using JuMP

export Connection
export nodes
export iseveronleft
export iseveronright
export finish
export start
export rightexpressions
export leftexpressions
export hassameorder


"""
     Connection 

# Description

A structure to hold a directed connection between two nodes in a network.

# Fields
- `from::Int64`: The starting node of the connection.
- `to::Int64`: The ending node of the connection.
- `value::Any`: The value associated with the connection (e.g. distance, time, capacity). 

# Example 

```julia
# Create a connection from node 1 to node 2 with a distance of 5 kms.
conn = Connection(1, 2, 5)
```
"""
struct Connection
    from::Int64
    to::Int64
    value::Any
    varsym::Any
    Connection(from, to, value) = new(from, to, value, string("x", from, to))
end


function nodes(cns::Vector{Connection})::Set{Int64}
    s = Set{Int64}()
    for conn in cns
        push!(s, conn.from)
        push!(s, conn.to)
    end
    return s
end

function iseveronleft(cns::Vector{Connection}, n::Int64)::Bool
    for conn in cns
        if conn.from == n
            return true
        end
    end
    return false
end

function iseveronright(cns::Vector{Connection}, n::Int64)::Bool
    for conn in cns
        if conn.to == n
            return true
        end
    end
    return false
end

function finish(cns::Vector{Connection})::Int64
    nodeset = nodes(cns)
    for n in nodeset
        if !iseveronleft(cns, n)
            return n
        end
    end
    error("No finish node found in connection list.")
end

function start(cns::Vector{Connection})::Int64
    nodeset = nodes(cns)
    for n in nodeset
        if !iseveronright(cns, n)
            return n
        end
    end
    error("No start node found in connection list.")
end



function rightexpressions(x::Matrix{JuMP.VariableRef}, node::Int64, nodes::Vector{Connection}, model)::Union{JuMP.AffExpr, Symbol}
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



function leftexpressions(x::Matrix{JuMP.VariableRef}, node::Int64, nodes::Vector{Connection}, model)::Union{JuMP.AffExpr, Symbol}
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



function hassameorder(a::Vector{Connection}, b::Vector{Connection})::Bool

    if length(a) != length(b)
        return false
    end

    for i = 1:length(a)
        if a[i].from != b[i].from || a[i].to != b[i].to
            return false
        end
    end

    return true
end


end # end of module Network 
