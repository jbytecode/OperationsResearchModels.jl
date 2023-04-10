module MinimumSpanningTree

import ..Network: Connection 

export hasloop

function hasloop(conns::Vector{Connection})::Bool
    if length(conns) <= 1
        return false 
    end 
    nodes = Set{Int64}()
    push!(nodes, conns[1].from)
    push!(nodes, conns[1].to)
    for i in 2:length(conns)
        if conns[i].from in nodes && conns[i].to in nodes
            return true 
        end 
        push!(nodes, conns[i].from)
        push!(nodes, conns[i].to)
    end
    return false
end 

end # end of module