module CPM 

export cpm 
export CpmActivity
export CpmResult
export earliestfinishtime
export longestactivity

struct CpmActivity 
    name::String 
    time::Float64 
    dependencies::Vector{CpmActivity}
end 

struct CpmResult 
    pathstr::Vector{String}
    path::Vector{CpmActivity}
end 

function CpmActivity(name::String, time::T)::CpmActivity where {T <: Real}
    return CpmActivity(name, Float64(time), CpmActivity[])
end 


function earliestfinishtime(activity::CpmActivity)

    L = length(activity.dependencies)

    if L == 0
        return activity.time
    end 

    v = Float64[]

    for i in 1:L
        push!(v, earliestfinishtime(activity.dependencies[i]))
    end  

    return maximum(v) + activity.time
end 

function longestactivity(activies::Vector{CpmActivity})::CpmActivity
    activity = CpmActivity("", -1, CpmActivity[])
    maxval = typemin(Float64)

    for a in activies
        ea = earliestfinishtime(a)
        if ea > maxval 
            maxval = ea 
            activity = a 
        end 
    end 
    
    return activity 
end 

function pathtostring(activities::Vector{CpmActivity})::Vector{String}
    L = length(activities)
    v = String[]
    for i in 1:L 
        push!(v, activities[i].name)
    end
    return reverse(v)
end 

"""
    cpm(activities)

# Arguments 
- `activities::Vector{CpmActivity}`

# Output 
- `::CpmResult`: The object holds the results 

# Description 
Calculates CPM (Critical Path Method) and reports the critical path for a given set of activities. 

# Example 
```julia 
julia> A = CpmActivity("A", 2);

julia> B = CpmActivity("B", 3);

julia> C = CpmActivity("C", 2, [A]);

julia> D = CpmActivity("D", 3, [B]);

julia> E = CpmActivity("E", 2, [B]);

julia> F = CpmActivity("F", 3, [C, D]);

julia> G = CpmActivity("G", 7, [E]);

julia> H = CpmActivity("H", 5, [E]);

julia> I = CpmActivity("I", 6, [G, F]);

julia> J = CpmActivity("J", 2, [C, D]);

julia> activities = [A, B, C, D, E, F, G, H, I, J];

julia> result = cpm(activities);

julia> result.pathstr
4-element Vector{String}:
 "B"
 "E"
 "G"
 "I"

 julia> result.path == [B, E, G, I]
true
``` 
"""
function cpm(activities::Vector{CpmActivity})::CpmResult
    path = CpmActivity[]

    while true
        longest = longestactivity(activities)
        push!(path, longest)
        if length(longest.dependencies) == 0 
            break
        end
        activities = longest.dependencies
    end

    return CpmResult(pathtostring(path), reverse(path))
end 



end # end of module Project 