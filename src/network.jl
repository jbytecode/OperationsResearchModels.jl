module Network

export Connection
export nodes
export iseveronleft
export iseveronright
export finish
export start
export ShortestPathProblem


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


end # end of module Network 
