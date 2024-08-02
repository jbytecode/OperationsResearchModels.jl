module TravelingSalesman

import ..RandomKeyGA: run_ga 

export TravelinSalesmenResult
export travelingsalesman

struct TravelinSalesmenResult
    route::Vector{Int}
    cost::Float64
end



"""
    travelingsalesman(distancematrix::Matrix; popsize = 100, ngen = 1000, pcross = 0.8, pmutate = 0.01, nelites = 1)::TravelinSalesmenResult

Given a matrix of distances, returns a TravelinSalesmenResult with the best route and its cost.

# Arguments

- `distancematrix::Matrix`: a matrix of distances
- `popsize::Int`: the population size. Default is 100
- `ngen::Int`: the number of generations. Default is 1000
- `pcross::Float64`: the crossover probability. Default is 0.8
- `pmutate::Float64`: the mutation probability. Default is 0.01
- `nelites::Int`: the number of elites. Default is 1

# Returns

- `TravelinSalesmenResult`: a custom data type that holds the best route and its cost

# Example

```julia
pts = Float64[
    0 0;
    0 1;
    0 2;
    1 2;
    2 2;
    3 2;
    4 2; 
    5 2;
    5 1;
    5 0;
    4 0;
    3 0;
    2 0;
    1 0;
]

n = size(pts, 1
distmat = zeros(n, n)

for i in 1:n
    for j in 1:n
        distmat[i, j] = sqrt(sum((pts[i, :] .- pts[j, :]).^2))
    end 
end

result = travelingsalesman(distmat, ngen = 1000, popsize = 100, pcross = 1.0, pmutate = 0.10)
```
"""
function travelingsalesman(distancematrix::Matrix{TType}; 
    popsize = 100, ngen = 1000, pcross = 0.8, pmutate = 0.01, nelites = 1):: TravelinSalesmenResult where {TType<:Float64} 

    n, _ = size(distancematrix)

    function costfn(route::Vector{Int})::Float64 
        cost = 0.0
        for i in 1:length(route)-1
            cost += distancematrix[route[i], route[i+1]]
        end
        cost += distancematrix[route[end], route[1]]
        return cost
    end 


    # popsize::Int, chsize::Int, costfn::F, ngen::Int, pcross::Float64, pmutate::Float64, nelites::Int
    garesult = run_ga(popsize, n, costfn, ngen, pcross, pmutate, nelites)

    best = garesult.chromosomes[1]
    cost = costfn(sortperm(best.values))

    return TravelinSalesmenResult(sortperm(best.values), cost)
end 


end # end of module TravelingSalesman