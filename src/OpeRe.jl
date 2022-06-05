module OpeRe

include("transportation.jl")
include("shortestpath.jl")

import .Transportation 
import .ShortestPath


import .Transportation: TransportationProblem, TransportationResult, balance, isbalanced
import .ShortestPath: Connection, nodes, finish, start, ShortestPathResult

export TransportationProblem, TransportationResult, balance, isbalanced
export Connection, nodes, finish, start, ShortestPathResult

solve(t::TransportationProblem) = Transportation.solve(t)
solve(c::Array{Connection, 1}) = ShortestPath.solve(c)
export solve 

end # end of module
