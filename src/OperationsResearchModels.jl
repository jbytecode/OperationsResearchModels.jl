module OperationsResearchModels

using JuMP, HiGHS

# This function has several methods to solve different types of problems including: 
# solve(t::TransportationProblem)::TransportationResult
# solve(s::ShortestPathProblem)::ShortestPathResult
# solve(m::MaximumFlowProblem)::MaximumFlowResult
# solve(m::MinimumCostFlowProblem)::MinimumCostFlowResult
# solve(m::CpmProblem)::CpmResult
# solve(m: PertProblem)::PertResult
# solve(a::AssignmentProblem)::AssignmentResult
# solve(g::Game)::GameResult
# solve(m::MstProblem)::MstResult
solve() = nothing 

# balance(m::TransportationProblem)::TransportationProblem
# balance(a::AssignmentProblem)::AssignmentProblem
balance() = nothing

# isbalanced(m::TransportationProblem)::Bool
# isbalanced(a::AssignmentProblem)::Bool
isbalanced() = nothing


export solve 
export balance
export isbalanced 


include("utility.jl")
include("network.jl")
include("transportation.jl")
include("assignment.jl")
include("shortestpath.jl")
include("maximumflow.jl")
include("minimumcostflow.jl")
include("game.jl")
include("mst.jl")
include("pmedian.jl")
include("cpm.jl")
include("simplex.jl")
include("knapsack.jl")
include("latex.jl")
include("randomkeyga.jl")
include("johnsons.jl")
include("travelingsalesman.jl")

import .Network
import .Transportation
import .Assignment
import .ShortestPath
import .MaximumFlow
import .MinimumCostFlow
import .Game
import .MinimumSpanningTree
import .PMedian
import .CPM
import .Simplex
import .Knapsack
import .Latex
import .Utility
import .RandomKeyGA
import .Johnsons
import .TravelingSalesman


import .Transportation:
    TransportationProblem, 
    TransportationResult, 
    balance, isbalanced, 
    northwestcorner, 
    leastcost

import .ShortestPath: ShortestPathResult, ShortestPathProblem

import .Network: Connection, nodes
import .MaximumFlow: MaximumFlowResult, MaximumFlowProblem
import .MinimumCostFlow: MinimumCostFlowProblem, MinimumCostFlowResult
import .Assignment: AssignmentProblem, AssignmentResult, isbalanced, balance
import .Game: game, GameResult, game_solver
import .MinimumSpanningTree: hasloop, MstResult, MstProblem
import .PMedian: pmedian, pmedian_with_distances, PMedianResult
import .CPM: CpmActivity, earliestfinishtime, longestactivity, CpmProblem, CpmResult
import .CPM: PertActivity, PertProblem, PertResult
import .Knapsack: KnapsackResult, KnapsackProblem
import .Latex: latex
import .Johnsons: JohnsonResult, johnsons, JohnsonException, makespan, johnsons_ga
import .RandomKeyGA: Chromosome, run_ga
import .TravelingSalesman: TravelinSalesmenResult, travelingsalesman
import .Simplex: SimplexProblem, simplexiterations, createsimplexproblem, gaussjordan

export TransportationProblem, TransportationResult, balance, isbalanced, northwestcorner, leastcost
export Connection, ShortestPathResult, MaximumFlowResult, MinimumCostFlowResult, nodes
export ShortestPathProblem, MaximumFlowProblem, MinimumCostFlowProblem
export AssignmentProblem, AssignmentResult, isbalanced, balance
export game, GameResult, game_solver
export hasloop, MstResult, MstProblem
export pmedian, pmedian_with_distances, PMedianResult
export CpmActivity, earliestfinishtime, longestactivity, CpmProblem, CpmResult
export PertActivity, PertProblem, PertResult
export KnapsackResult, KnapsackProblem
export Simplex
export Utility
export latex
export Chromosome, run_ga
export JohnsonResult, johnsons, JohnsonException, makespan, johnsons_ga
export TravelinSalesmenResult, travelingsalesman
export simplexiterations, SimplexProblem, createsimplexproblem, gaussjordan

export JuMP, HiGHS




end # end of module
