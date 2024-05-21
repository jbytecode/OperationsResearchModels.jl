module Johnsons

export JohnsonResult, JohnsonException, johnsons

# TODO: Add makespan calculation 

struct JohnsonException <: Exception
    message::String
end


struct JohnsonResult
    permutation::Vector{Int}
    # makespan::Float64
end



"""
    johnsons(times::Matrix)

Given a matrix of times, returns a JohnsonResult with the permutation of the jobs. 
If number of machines is 2, it uses the Johnson's algorithm for 2 machines.
If number of machines is greater than 2, it uses the Johnson's algorithm by transforming the 
problem into a 2-machine problem.
In order to reduce the original problem to a 2-machine problem, the algorithm checks if the minimum time
of the first machine is greater or equal than the maximum time of the other machines and/or if the minimum time of the 
last machine is greater or equal than the maximum time of the other machines.

For example if we have 4 machines, namely, A, B, C, and D 
at least one of the following conditions must be satisfied:

- min(A) >= max(B, C)
- min(D) >= max(B, C)

The function throws a JohnsonException if the problem cannot be reduced to a 2-machine problem.

# Arguments

- `times::Matrix`: a matrix of times

# Returns

- `JohnsonResult`: a custom data type that holds the permutation of the jobs

# Example

```julia
times = Float64[
    3.1 2.8;
    4.0 7.0;
    8.0 3.0;
    5.0 8.0;
    6.0 4.0;
    8.0 5.0;
    7.0 4.0
]

result = johnsons(times)

println(result.permutation)
```
"""
function johnsons(times::Matrix)
    _, m = size(times)
    if m == 2
        return johnsons_2machines(times)
    else
        return johnsons_nmachines(times)
    end
end

function dofirst!(locrow::Int, permutation::Vector{Int})
    for i in 1:length(permutation)
        if permutation[i] == -1
            permutation[i] = locrow
            return
        end
    end
end

function dolast!(locrow::Int, permutation::Vector{Int})
    for i in length(permutation):-1:1
        if permutation[i] == -1
            permutation[i] = locrow
            return
        end
    end
end

function johnsons_2machines(timesmatrix::Matrix)::JohnsonResult
    times = copy(timesmatrix)
    n, m = size(times)
    @assert m == 2

    typed_inf = typemax(eltype(times))

    permutation = [-1 for i in 1:n]
    for i in 1:n
        locrow, loccol = argmin(times).I
        if loccol == 1
            dofirst!(locrow, permutation)
        else
            dolast!(locrow, permutation)
        end
        times[locrow, :] .= typed_inf
    end
    return JohnsonResult(permutation)
end


function johnsons_nmachines(times::Matrix)::JohnsonResult
    minfirst = minimum(times[:, 1])
    minlast = minimum(times[:, end])
    maxothers = maximum(times[:, 2:(end-1)])

    if !((minfirst >= maxothers) || (minlast >= maxothers))
        throw(JohnsonException("The problem cannot be reduced to a 2-machine problem: minfirst >= maxothers and/or minlast >= maxothers"))
    end

    Gcollection = times[:, 1:(end-1)]
    Hcollection = times[:, 2:end]

    G = sum(Gcollection, dims=2)
    H = sum(Hcollection, dims=2)

    return johnsons_2machines([G H])
end

end # end of module Johnsons