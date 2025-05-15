module MinimumSpanningTree

import ..Network: Connection, nodes

import ..OperationsResearchModels: solve

export hasloop
export mst
export MstResult
export MstProblem

struct MstResult
    connections::Vector{Connection}
    distance::Float64
end

struct MstProblem
    connections::Vector{Connection}
end


function hasloop(conns::Vector{Connection})::Bool
    if length(conns) <= 1
        return false
    end
    nodes = Set{Int64}()
    push!(nodes, conns[1].from)
    push!(nodes, conns[1].to)
    for i = 2:length(conns)
        if conns[i].from in nodes && conns[i].to in nodes
            return true
        end
        push!(nodes, conns[i].from)
        push!(nodes, conns[i].to)
    end
    return false
end

function findconnection(
    conns::Vector{Connection},
    i::Int,
    j::Int,
)::Union{Nothing,Connection}
    for c in conns
        if (c.from == i && c.to == j) || (c.from == j && c.to == i)
            return c
        end
    end
    return nothing
end

function findnearestbetweennodes(
    conns::Vector{Connection},
    distmat::Matrix,
    assigned::Set{Int64},
    unassigned::Set{Int64},
)::Tuple{Int,Connection}
    mindist = typemax(Float64)
    theconnection = -1
    connobj = nothing
    for assignedelement in assigned
        for unassignedelement in unassigned
            cdist = distmat[assignedelement, unassignedelement]
            if cdist < mindist
                mindist = cdist
                theconnection = unassignedelement
                #connobj = Connection(assignedelement, unassignedelement, cdist)
                connobj = findconnection(conns, assignedelement, unassignedelement)
            end
        end
    end
    return (theconnection, connobj)
end

function makedistancematrix(conns::Vector{Connection})::Matrix
    allnodes = nodes(conns)
    maxnode = maximum(allnodes)
    mat = zeros(Float64, maxnode, maxnode)
    for i = 1:maxnode
        for j = (i+1):maxnode
            c = findconnection(conns, i, j)
            if !isnothing(c)
                mat[i, j] = c.value
            else
                mat[i, j] = typemax(Float64)
            end
            mat[j, i] = mat[i, j]
        end
    end
    return mat
end


"""
    solve(problem::MstProblem)

# Arguments 

- `problem::MstProblem`: The problem in type of MstProblem

# Description

Obtains the minimum spanning tree. 

# Output 

- `::MstResult`: A MstResult object that holds the results. 

# Examples 

```julia 
julia> conns = Connection[
                       Connection(1, 2, 10),
                       Connection(2, 3, 10),
                       Connection(3, 4, 10),
                       Connection(1, 4, 10)
                   ]

4-element Vector{Connection}:
 Connection(1, 2, 10, "x12")
 Connection(2, 3, 10, "x23")
 Connection(3, 4, 10, "x34")
 Connection(1, 4, 10, "x14")

 julia> result = solve(MstProblem(conns))
 MstResult(Connection[Connection(3, 4, 10, "x34"), Connection(1, 4, 10, "x14"), Connection(2, 3, 10, "x23")], 30.0)
 
 julia> result.distance
 30.0
 
 julia> result.connections
 3-element Vector{Connection}:
  Connection(3, 4, 10, "x34")
  Connection(1, 4, 10, "x14")
  Connection(2, 3, 10, "x23")
```
"""
function solve(problem::MstProblem)::MstResult

    conns = problem.connections

    totaldist = 0.0

    distmat = makedistancematrix(conns)

    assigned = Set{Int64}()
    unassigned = nodes(conns)
    connresult = Connection[]

    luckynode = pop!(unassigned)
    push!(assigned, luckynode)

    while length(unassigned) > 0
        nearestnode, conn = findnearestbetweennodes(conns, distmat, assigned, unassigned)
        push!(assigned, nearestnode)
        push!(connresult, conn)
        totaldist += conn.value
        unassigned = filter(x -> x != nearestnode, unassigned)
    end

    return MstResult(connresult, totaldist)
end

end # end of module
