module BinPacking

import OperationsResearchModels: solve 

export BinPackingProblem, BinPackingResult


using JuMP, HiGHS

"""
BinPackingProblem represents a bin packing problem with item sizes and bin capacities.

# Fields
- `item_sizes::Vector{T1 <: Real}`: The sizes of the items.
- `bin_capacity::Vector{T2 <: Real}`: The capacities of the bins.
"""
struct BinPackingProblem{T1 <: Real, T2 <: Real} 
    item_sizes::Vector{T1} 
    bin_capacity::Vector{T2}
end 


"""
BinPackingResult represents the result of a bin packing problem.

# Fields
- `used_bins::Vector{Int}`: The indices of the bins that are used.
- `bin_assignments::Vector{Int}`: The bin assignment for each item.
- `model::JuMP.Model`: The JuMP model used to solve the problem.
"""
struct BinPackingResult 
    used_bins::Vector{Int}
    bin_assignments::Vector{Int}
    model::JuMP.Model
end 



"""
Solve a bin packing problem.

# Description

Suppose we have a set of items with given sizes and a set of bins with given capacities. 
The goal is to assign each item to a bin such that the total size of items in each bin 
does not exceed its capacity, and the number of used bins is minimized. For example 
we have items with sizes `[2, 3, 2, 3]` and bins with capacities `[5, 5]`. 
The optimal assignment would be to place the first two items in the first bin and 
the last two items in the second bin.

# Arguments
- `problem::BinPackingProblem`: The bin packing problem to solve.

# Returns
- `BinPackingResult`: The result of the bin packing problem.
"""
function solve(problem::BinPackingProblem)::BinPackingResult
    
    nitems = length(problem.item_sizes)
    
    nbins = length(problem.bin_capacity)
    
    model = Model(HiGHS.Optimizer)

    MOI.set(model, MOI.Silent(), true)

    @variable(model, y[1:nbins], Bin)
    
    @variable(model, x[1:nitems, 1:nbins], Bin)

    @objective(model, Min, sum(y))

    @constraint(model, [i=1:nitems], sum(x[i, j] for j=1:nbins) == 1)

    @constraint(model, [j=1:nbins], sum(problem.item_sizes[i] * x[i, j] for i=1:nitems) <= problem.bin_capacity[j] * y[j])

    optimize!(model)

    used_bins = [j for j in 1:nbins if value(y[j]) > 0.5]

    bin_assignments = [argmax([value(x[i, j]) for j in 1:nbins]) for i in 1:nitems]

    return BinPackingResult(used_bins, bin_assignments, model)
end 

end # end of module BinPacking