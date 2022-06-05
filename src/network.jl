module Network 

struct Connection
    from::Int64
    to::Int64
    value::Any
    varsym::Any
    Connection(from, to, value) = new(from, to, value, string("x", from, to))
end

struct ShortestPathProblem end 
struct MaximumFlowProblem end 

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


export Connection 
export nodes 
export iseveronleft
export iseveronright
export finish
export start
export ShortestPathProblem
export MaximumFlowProblem


end # end of module Network 
