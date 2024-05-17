module Johnsons

export JohnsonResult, johnsons

struct JohnsonResult
    permutation::Vector{Int}
    # makespan::Float64
end

"""
    johnsons(times::Matrix)

Given a matrix of times, returns a JohnsonResult with the permutation of the jobs

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
    permutation = [-1 for i in 1:n]
    for i in 1:n
        locrow, loccol = argmin(times).I
        if loccol == 1
            dofirst!(locrow, permutation)
        else
            dolast!(locrow, permutation)
        end
        times[locrow, :] .= Inf
    end
    return JohnsonResult(permutation)
end


function johnsons_nmachines(times::Matrix)::JohnsonResult
    minfirst = minimum(times[:, 1])
    minlast = minimum(times[:, end])
    maxothers = maximum(times[:, 2:(end-1)])

    @assert (minfirst >= maxothers) || (minlast >= maxothers)

    Gcollection = times[:, 1:(end-1)]
    Hcollection = times[:, 2:end]

    G = sum(Gcollection, dims=2)
    H = sum(Hcollection, dims=2)

    return johnsons_2machines([G H])
end

end # end of module Johnsons