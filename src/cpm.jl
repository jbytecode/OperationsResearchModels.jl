module CPM 

export cpm 
export CpmActivity
export CpmResult
export earliestfinishtime
export longestactivity
export PertActivity
export PertResult
export pert

struct CpmActivity 
    name::String 
    time::Float64 
    dependencies::Vector{CpmActivity}
end 

struct CpmResult 
    pathstr::Vector{String}
    path::Vector{CpmActivity}
end 

struct PertActivity 
    name::String 
    optimistic::Float64 
    mostlikely::Float64 
    pessimistic::Float64 
    dependencies::Vector{PertActivity}
end

struct PertResult 
    path::Vector{PertActivity}
    mean::Float64
    stddev::Float64 
end

function CpmActivity(name::String, time::T)::CpmActivity where {T <: Real}
    return CpmActivity(name, Float64(time), CpmActivity[])
end 

function PertActivity(name::String, o::T, m::T, p::T)::PertActivity where {T <: Real}
    return PertActivity(name, Float64(o), Float64(m), Float64(p), PertActivity[])
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

function mean(a::PertActivity)::Float64 
    return (a.optimistic + 4.0 * a.mostlikely + a.pessimistic) / 6.0
end 

function var(a::PertActivity)::Float64 
    return ((a.pessimistic - a.optimistic) / 6.0) ^ 2.0
end 

function Base.sum(activities::Vector{CpmActivity})::Float64 
    return sum([x.time for x in activities])
end

function var(as::Vector{PertActivity})::Float64
    return sum([var(x) for x in as])
end


function findpertactivities(cpmpath::Vector{CpmActivity}, pertactivities::Vector{PertActivity})
    L = length(cpmpath)
    perts = Array{PertActivity, 1}(undef, L)
    for i in 1:L
        currentcpmactivity = cpmpath[i]
        pertactivity = filter(x -> x.name == currentcpmactivity.name, pertactivities)[1]
        perts[i] = pertactivity
    end 
    return perts
end

function perttocpm(a::PertActivity)::CpmActivity
    return CpmActivity(a.name, mean(a), perttocpm.(a.dependencies))
end 



"""
    pert(activities)

# Arguments 
- `activities::Vector{PertActivity}`: Vector of Pert Activities. 

# Example 
```julia
julia> A = PertActivity("A", 1, 2, 3)
PertActivity("A", 1.0, 2.0, 3.0, PertActivity[])

julia> B = PertActivity("B", 3, 3, 3)
PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])

julia> C = PertActivity("C", 5, 5, 5, [A, B])
PertActivity("C", 5.0, 5.0, 5.0, PertActivity[PertActivity("A", 1.0, 2.0, 3.0, PertActivity[]), PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])])

julia> activities = [A, B, C]
3-element Vector{PertActivity}:
 PertActivity("A", 1.0, 2.0, 3.0, PertActivity[])
 PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])
 PertActivity("C", 5.0, 5.0, 5.0, PertActivity[PertActivity("A", 1.0, 2.0, 3.0, PertActivity[]), PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])])

julia> result = pert(activities)
PertResult(PertActivity[PertActivity("B", 3.0, 3.0, 3.0, PertActivity[]), PertActivity("C", 5.0, 5.0, 5.0, PertActivity[PertActivity("A", 1.0, 2.0, 3.0, PertActivity[]), PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])])], 8.0, 0.0)

julia> result.mean
8.0

julia> result.stddev
0.0
```
"""
function pert(activities::Vector{PertActivity})
    L = length(activities)
    cpmactivities = Array{CpmActivity, 1}(undef, L)
    for i in 1:L
        current::PertActivity = activities[i]
        cpmactivity = CpmActivity(current.name, mean(current), perttocpm.(current.dependencies))
        cpmactivities[i] = cpmactivity
    end
    cpmresult = cpm(cpmactivities)
    pertpath = cpmresult.path
    pertactivities = findpertactivities(pertpath, activities)
    pertmean = sum(pertpath)
    stddev = sqrt(var(pertactivities))
    
    return PertResult(
        pertactivities,
        pertmean,
        stddev
    )
end

end # end of module Project 