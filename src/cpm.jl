module CPM

import ..OperationsResearchModels: solve

export CpmActivity
export CpmProblem
export CpmResult
export earliestfinishtime
export longestactivity
export PertActivity
export PertProblem
export PertResult


"""
    CpmActivity(name::String, time::Float64, dependencies)

# Description

The object that represents an activity in CPM (Critical Path Method).

# Fields 
- `name::String`: The name of the activity.
- `time::Float64`: The time of the activity.
- `dependencies`: The dependencies of the activity in type of `Vector{CpmActivity}`.

# Example

```julia
A = CpmActivity("A", 2, []);

B = CpmActivity("B", 3, []);

C = CpmActivity("C", 2, [A, B]);

```
"""
struct CpmActivity
    name::String
    time::Float64
    dependencies::Vector{CpmActivity}
end


"""
    CpmProblem(activities::Vector{CpmActivity})

# Description

Represents a CPM (Critical Path Method) problem instance, containing the activities.

# Fields

- `activities::Vector{CpmActivity}`: A vector of activities in the CPM problem.
"""
struct CpmProblem
    activities::Vector{CpmActivity}
end



"""
    CpmResult(pathstr::Vector{String}, path::Vector{CpmActivity})

# Description 

Represents the result of a CPM (Critical Path Method) analysis, containing the critical path and its activities.

# Fields

- `pathstr::Vector{String}`: A vector of strings representing the names of the activities in the critical path.
- `path::Vector{CpmActivity}`: A vector of activities representing the critical path.
"""
struct CpmResult
    pathstr::Vector{String}
    path::Vector{CpmActivity}
end





"""
    PertActivity(name::String, o::Float64, m::Float64, p::Float64)::PertActivity

# Description

The object that represents an activity in PERT (Program Evaluation and Review Technique).

# Fields
- `name::String`: The name of the activity.
- `o::Float64`: The optimistic time of the activity.
- `m::Float64`: The most likely time of the activity.
- `p::Float64`: The pessimistic time of the activity.
- `dependencies`: The dependencies of the activity in type of `Vector{PertActivity}`.

# Example
```julia
A = PertActivity("A", 1, 2, 3);
B = PertActivity("B", 3, 3, 4);
C = PertActivity("C", 5, 6, 7, [A, B]);
```
"""
struct PertActivity
    name::String
    optimistic::Float64
    mostlikely::Float64
    pessimistic::Float64
    dependencies::Vector{PertActivity}
end




"""
    PertProblem(activities::Vector{PertActivity})

# Description 

Represents a PERT (Program Evaluation and Review Technique) problem instance, containing the activities.

# Fields

- `activities::Vector{PertActivity}`: A vector of activities in the PERT problem.
"""
struct PertProblem
    activities::Vector{PertActivity}
end



"""
    PertResult(path::Vector{PertActivity}, mean::Float64, stddev::Float64)

# Description 

Represents the result of a PERT (Program Evaluation and Review Technique) analysis, containing the critical path and its activities.

# Fields

- `path::Vector{PertActivity}`: A vector of activities representing the critical path.
- `mean::Float64`: The mean duration of the critical path.
- `stddev::Float64`: The standard deviation of the critical path.
"""
struct PertResult
    path::Vector{PertActivity}
    mean::Float64
    stddev::Float64
end

function CpmActivity(name::String, time::T)::CpmActivity where {T<:Real}
    return CpmActivity(name, Float64(time), CpmActivity[])
end

function PertActivity(name::String, o::T, m::T, p::T)::PertActivity where {T<:Real}
    return PertActivity(name, Float64(o), Float64(m), Float64(p), PertActivity[])
end



function earliestfinishtime(activity::CpmActivity)

    L = length(activity.dependencies)

    if L == 0
        return activity.time
    end

    v = Float64[]

    for i = 1:L
        push!(v, earliestfinishtime(activity.dependencies[i]))
    end

    return maximum(v) + activity.time
end

function longestactivity(activities::Vector{CpmActivity})::CpmActivity
    activity = CpmActivity("", -1, CpmActivity[])
    maxval = typemin(Float64)

    for a in activities
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
    for i = 1:L
        push!(v, activities[i].name)
    end
    return reverse(v)
end


"""
    solve(problem)

# Arguments 

- `problem::CpmProblem`: The problem in type of CpmProblem.

# Output 

- `::CpmResult`: The object holds the results 

# Description 

Calculates CPM (Critical Path Method) and reports the critical path for a given set of activities. 

# Example 

```julia 
A = CpmActivity("A", 2);
B = CpmActivity("B", 3);
C = CpmActivity("C", 2, [A]);
D = CpmActivity("D", 3, [B]);
E = CpmActivity("E", 2, [B]);
F = CpmActivity("F", 3, [C, D]);
G = CpmActivity("G", 7, [E]);
H = CpmActivity("H", 5, [E]);
I = CpmActivity("I", 6, [G, F]);
J = CpmActivity("J", 2, [C, D]);

activities = [A, B, C, D, E, F, G, H, I, J];

problem = CpmProblem(activities);

result = solve(problem);

``` 
"""
function solve(problem::CpmProblem)::CpmResult

    activities = problem.activities

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
    return ((a.pessimistic - a.optimistic) / 6.0)^2.0
end

function Base.sum(activities::Vector{CpmActivity})::Float64
    return sum([x.time for x in activities])
end

function var(as::Vector{PertActivity})::Float64
    return sum([var(x) for x in as])
end


function findpertactivities(
    cpmpath::Vector{CpmActivity},
    pertactivities::Vector{PertActivity},
)
    L = length(cpmpath)
    perts = Vector{PertActivity}(undef, L)
    for i = 1:L
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
    solve(problem::PertProblem)::PertResult

# Arguments 

- `problem::PertProblem`: The problem in type of PertProblem.

# Output

- `::PertResult`: The object holds the results

# Example

```julia
A = PertActivity("A", 1, 2, 3)

B = PertActivity("B", 3, 3, 3)

C = PertActivity("C", 5, 5, 5, [A, B])

activities = [A, B, C]

problem = PertProblem(activities);

result = pert(activities)

println(result.mean)
println(result.stddev)
```
"""
function solve(problem::PertProblem)::PertResult

    activities = problem.activities

    L = length(activities)

    cpmactivities = Vector{CpmActivity}(undef, L)

    for i = 1:L
        current::PertActivity = activities[i]
        cpmactivity =
            CpmActivity(current.name, mean(current), perttocpm.(current.dependencies))
        cpmactivities[i] = cpmactivity
    end

    cpmresult = solve(CpmProblem(cpmactivities))

    pertpath = cpmresult.path

    pertactivities = findpertactivities(pertpath, activities)

    pertmean = sum(pertpath)

    stddev = sqrt(var(pertactivities))

    return PertResult(pertactivities, pertmean, stddev)
end

end # end of module Project 
