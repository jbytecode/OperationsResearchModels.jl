module OpeRe


# Default Optimizer 
using HiGHS
const theoptimizerpackage = Symbol("HiGHS")
const theoptimizer = HiGHS.Optimizer

include("network.jl")
include("transportation.jl")
include("assignment.jl")
include("shortestpath.jl")
include("maximumflow.jl")
include("game.jl")

import .Network
import .Transportation
import .Assignment 
import .ShortestPath
import .MaximumFlow 
import .Game

import .Transportation: TransportationProblem, TransportationResult, balance, isbalanced
import .ShortestPath: ShortestPathResult
import .Network:  Connection, ShortestPathProblem, MaximumFlowProblem
import .MaximumFlow: MaximumFlowResult
import .Assignment: AssignmentProblem, AssignmentResult
import .Game: game, GameResult


export TransportationProblem, TransportationResult, balance, isbalanced
export Connection, ShortestPathResult, MaximumFlowResult 
export ShortestPathProblem, MaximumFlowProblem
export AssignmentProblem, AssignmentResult
export game, GameResult

solve(t::TransportationProblem) = Transportation.solve(t)
solve(a::AssignmentProblem) = Assignment.solve(a)

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
