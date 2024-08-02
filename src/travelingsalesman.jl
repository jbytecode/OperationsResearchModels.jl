module TravelingSalesman

import ..RandomKeyGA: run_ga 

export TravelinSalesmenResult
export travelingsalesman

struct TravelinSalesmenResult
    route::Vector{Int}
    cost::Float64
end

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