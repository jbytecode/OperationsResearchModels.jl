module MinimumSpanningTree

import ..Network: Connection, nodes

import ..OperationsResearchModels: solve

import LinearAlgebra: issymmetric

export hasloop
export MstResult
export MstProblem


"""
    MstProblem 

# Description

Defines the minimum spanning tree problem.

# Fields
- `data::Union{Vector{Connection}, AbstractMatrix{<:Real}}`: The data representing the network. 
   It can be either a vector of connections or a distance matrix.

!!! info "Interpreting the Connection object"

    The Connection object defines a directed edge, but for the minimum spanning tree problem, 
    the edges are considered undirected.

# See also [`MstResult`](@ref), [`solve(::MstProblem)`](@ref)
"""
struct MstProblem
    data::Union{Vector{Connection}, AbstractMatrix{<:Real}}
end


"""
    MstResult

# Description

A structure to hold the result of the minimum spanning tree problem.

# Fields
- `connections::Vector{Connection}`: The connections (edges) in the minimum spanning tree.
- `distance::Float64`: The total distance (weight) of the minimum spanning tree.

# See also [`MstProblem`](@ref), [`solve(::MstProblem)`](@ref)
"""
struct MstResult
    connections::Vector{Connection}
    distance::Float64
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

function makeconnections(mat::Matrix)::Vector{Connection}
    
    n, _ = size(mat)

    !issymmetric(mat)  &&  throw(AssertionError("The distance matrix must be symmetric."))
    
    conns = Vector{Connection}(undef, n * (n-1) ÷ 2)
    idx = 1
    for i = 1:n
        for j = (i+1):n
            conns[idx] = Connection(i, j, mat[i, j])
            idx += 1
        end
    end 
    
    return conns

end

function prim(conns::Vector{Connection})::MstResult
    allnodes = collect(nodes(conns))
    n = length(allnodes)
    n <= 1 && return MstResult(Connection[], 0.0)

    adjacency = Dict(node => Connection[] for node in allnodes)
    for conn in conns
        push!(adjacency[conn.from], conn)
        push!(adjacency[conn.to], conn)
    end

    in_tree = Set{Int64}()
    distances = Dict(node => typemax(Float64) for node in allnodes)
    nearest_connections = Dict{Int64,Connection}()
    distances[allnodes[1]] = 0.0
    result = Vector{Connection}(undef, n - 1)
    totaldist = 0.0

    for iteration in 1:n
        nearestnode = nothing
        mindist = typemax(Float64)
        for node in allnodes
            if !(node in in_tree) && distances[node] < mindist
                nearestnode = node
                mindist = distances[node]
            end
        end
        isnothing(nearestnode) &&
            throw(ArgumentError("The network must be connected to have a minimum spanning tree."))

        push!(in_tree, nearestnode)
        if iteration > 1
            conn = nearest_connections[nearestnode]
            result[iteration - 1] = conn
            totaldist += conn.value
        end

        for conn in adjacency[nearestnode]
            othernode = conn.from == nearestnode ? conn.to : conn.from
            if !(othernode in in_tree) && conn.value < distances[othernode]
                distances[othernode] = conn.value
                nearest_connections[othernode] = conn
            end
        end
    end

    return MstResult(result, totaldist)
end


"""
    solve(problem::MstProblem)

# Description

Obtains the minimum spanning tree. 

# Arguments 

- `problem::MstProblem`: The problem in type of MstProblem

# Output 

- `::MstResult`: A MstResult object that holds the results. 

# Details

- This function uses Prim's algorithm to find the minimum spanning tree. It tracks each unvisited node's nearest connection to the growing tree and updates only the connections adjacent to each newly selected node.

# Examples 

```julia 
conns = Connection[
    Connection(1, 2, 10),
    Connection(2, 3, 10),
    Connection(3, 4, 10),
    Connection(1, 4, 10)
]

result = solve(MstProblem(conns))

MstResult(Connection[Connection(3, 4, 10), Connection(1, 4, 10), Connection(2, 3, 10)], 30.0)

println(result.distance)

println(result.connections)
```

# See also [`MstResult`](@ref), [`solve(::MstProblem)`](@ref)
"""
function solve(problem::MstProblem)::MstResult

    if problem.data isa AbstractMatrix
        conns = makeconnections(problem.data)
    else
        conns = problem.data
    end

    return prim(conns)
end

end # end of module
