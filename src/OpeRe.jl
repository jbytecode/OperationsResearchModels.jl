module OpeRe

include("network.jl")
include("transportation.jl")
include("shortestpath.jl")
include("maximumflow.jl")

import .Network
import .Transportation 
import .ShortestPath
import .MaximumFlow 


import .Transportation: TransportationProblem, TransportationResult, balance, isbalanced
import .ShortestPath: ShortestPathResult
import .Network:  Connection, ShortestPathProblem, MaximumFlowProblem
import .MaximumFlow: MaximumFlowResult


export TransportationProblem, TransportationResult, balance, isbalanced
export Connection, ShortestPathResult, MaximumFlowResult 
export ShortestPathProblem, MaximumFlowProblem

solve(t::TransportationProblem) = Transportation.solve(t)

function solve(c::Array{Connection, 1}; problem = ShortestPathProblem) 
    if problem == ShortestPathProblem
        return ShortestPath.solve(c)
    elseif problem == MaximumFlowProblem
        return MaximumFlow.solve(c)
    else
        error(string("Could not find problem type: ", string(problem)))
    end
end 

export solve 

end # end of module
