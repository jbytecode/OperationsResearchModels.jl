module Transportation

using JuMP, HiGHS



export TransportationProblem
export TransportationResult
export northwestcorner
export leastcost
export isbalanced
export balance

import ..OperationsResearchModels: solve, balance, isbalanced


"""
    TransportationProblem

# Fields

- `costs::Matrix{T}`: The cost matrix of the transportation problem.
- `demand::Vector{T}`: The demand vector of the transportation problem.
- `supply::Vector{T}`: The supply vector of the transportation problem.

# Description

The `TransportationProblem` struct represents a transportation problem with a cost matrix, demand vector, and supply vector.
"""
mutable struct TransportationProblem{T<:Real}
    costs::Matrix{T}
    demand::Vector{T}
    supply::Vector{T}
end


"""
    TransportationResult(problem, balancedProblem, solution, cost)

# Fields

- `problem::TransportationProblem`: The original transportation problem.
- `balancedProblem::TransportationProblem`: The balanced transportation problem.
- `solution::Matrix`: The solution matrix of the transportation problem.
- `cost::Real`: The optimal cost of the transportation problem.
- `model::Union{JuMP.Model, Nothing}`: The JuMP model used to solve the transportation problem. Methods that 
    do not use JuMP will set this field to `nothing`.


# Description

The `TransportationResult` struct represents the result of solving a transportation problem.
It contains the original problem, the balanced problem, the solution matrix, and the optimal cost.

"""
struct TransportationResult
    originalProblem::TransportationProblem
    balancedProblem::TransportationProblem
    solution::Matrix
    cost::Real
    model::Union{JuMP.Model, Nothing}
end

function Base.show(io::IO, t::TransportationProblem)
    println(io, "Transportation Problem:")
    println(io, "Costs: ", t.costs)
    println(io, "Demand: ", t.demand)
    println(io, "Supply: ", t.supply)
end

function Base.show(io::IO, r::TransportationResult)
    println(io, "Transportation Results:")
    println(io, "Main problem:")
    println(io, r.originalProblem)
    println(io, "Balanced problem:")
    println(io, r.balancedProblem)
    println(io, "Cost:")
    println(io, r.cost)
    println(io, "Solution:")
    println(io, r.solution)
end

function copy(t::TransportationProblem)::TransportationProblem
    return TransportationProblem(
        Base.copy(t.costs),
        Base.copy(t.demand),
        Base.copy(t.supply),
    )
end

function isbalanced(t::TransportationProblem)::Bool
    return sum(t.demand) == sum(t.supply)
end

function balance(t::TransportationProblem)::TransportationProblem
    if isbalanced(t)
        return t
    end

    newt = copy(t)

    sumdemand = sum(t.demand)
    sumsupply = sum(t.supply)

    if sumdemand < sumsupply
        addDemandCentre!(newt, sumsupply - sumdemand)
    else
        addSupplyCentre!(newt, sumdemand - sumsupply)
    end

    return newt
end


function addDemandCentre!(t::TransportationProblem, amount::T) where {T<:Real}
    t.costs = hcat(t.costs, zeros(T, length(t.supply)))
    push!(t.demand, amount)
end

function addSupplyCentre!(t::TransportationProblem, amount::T) where {T<:Real}
    z = zeros(T, length(t.demand))
    t.costs = vcat(t.costs, z')
    push!(t.supply, amount)
end



"""
    solve(t, initial = NoInitial)

# Arguments 

- `t::TransportationProblem`: The problem in type of TransportationProblem
- `initial::TransportationResult`: The initial solution of the transportation problem (optional). The default is `NoInitial`.

# Output 

- `TransportationResult`: The custom data type that holds problem, solution, and optimum cost. 

# Description 

Solves a transportation problem given by an object of in type `TransportationProblem`.

`initial` is used to store the initial solution of the transportation problem. Any custom 
implementation should take a `TransportationProblem` and return a `TransportationResult` object.
Currently, `northwestcorner` and `leastcost` are implemented as custom initial solutions.

# Example 

```julia
t = TransportationProblem(
    [   1 1 1 1; 
        2 2 2 2; 
        3 3 3 3], 
    [100, 100, 100, 100], # Demands 
    [100, 100, 100])      # Supplies 


println(isbalanced(t))
# false

result = solve(t)

println(result)

# Transportation Results:
# Main problem:
# Transportation Problem:
# Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3]
# Demand: [100, 100, 100, 100]
# Supply: [100, 100, 100]
# 
# Balanced problem:
# Transportation Problem:
# Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3; 0 0 0 0]
# Demand: [100, 100, 100, 100]
# Supply: [100, 100, 100, 100]
# 
# Cost:
# 600.0
# Solution:
# [-0.0 -0.0 -0.0 100.0; 100.0 -0.0 -0.0 -0.0; -0.0 -0.0 100.0 -0.0; -0.0 100.0 -0.0 -0.0]
```
"""
function solve(
    t::TransportationProblem;
    initial::Function = NoInitial,
)::TransportationResult
    newt = balance(t)

    model = JuMP.Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    n, p = size(newt.costs)

    @variable(model, x[1:n, 1:p] .>= 0)
    @objective(model, Min, sum(newt.costs .* x))

    @constraint(model, sum(x[1:n, j] for j = 1:p) .== newt.supply)
    @constraint(model, sum(x[i, 1:p] for i = 1:n) .== newt.demand)

    initial_solution = initial(newt).solution
    JuMP.set_start_value.(x, initial_solution)

    optimize!(model)

    solution = value.(x)
    cost = JuMP.objective_value(model)

    result = TransportationResult(t, newt, solution, cost, model)
    return result
end



"""
    northwestcorner(a::TransportationProblem)::TransportationResult

# Description

The northwest corner method is a heuristic for finding an initial basic feasible solution to a transportation problem. It starts at the northwest corner of the cost matrix and allocates as much as possible to the cell, then moves either down or right depending on whether the supply or demand has been met.
The method continues until all supply and demand constraints are satisfied.

# Arguments
- `a::TransportationProblem`: The problem in type of TransportationProblem

# Output
- `TransportationResult`: The custom data type that holds problem, solution, and optimum cost.
"""
function northwestcorner(t::TransportationProblem)::TransportationResult
    problem = t
    if !isbalanced(t)
        problem = balance(t)
    end
    supply = Base.copy(problem.supply)
    demand = Base.copy(problem.demand)
    n, m = size(problem.costs)
    asgnmatrix = zeros(Float64, n, m)

    i = 1
    j = 1

    while (i <= n) && (j <= m)
        amount = min(supply[i], demand[j])
        asgnmatrix[i, j] = amount
        supply[i] -= amount
        demand[j] -= amount
        if (iszero(supply[i]) && iszero(demand[j])) || iszero(amount)
            i += 1
            j += 1
        elseif iszero(demand[j])
            j += 1
        elseif iszero(supply[i])
            i += 1
        else
            @error "Something unexpected happened!"
        end
    end

    cost = problem.costs .* asgnmatrix |> sum
    result = TransportationResult(t, problem, asgnmatrix, cost, nothing)
    return result
end


"""
    leastcost(a::TransportationProblem)::TransportationResult

# Description

The least cost method is a heuristic for finding an initial basic feasible solution to a transportation problem. It starts by selecting the cell with the lowest cost and allocating as much as possible to that cell, then it moves to the next lowest cost cell and repeats the process until all supply and demand constraints are satisfied.

# Arguments
- `a::TransportationProblem`: The problem in type of TransportationProblem

# Output
- `TransportationResult`: The custom data type that holds problem, solution, and optimum cost.
"""
function leastcost(t::TransportationProblem)::TransportationResult
    problem = t
    if !isbalanced(t)
        problem = balance(t)
    end
    supply = Base.copy(problem.supply)
    demand = Base.copy(problem.demand)
    n, m = size(problem.costs)
    asgnmatrix = zeros(Float64, n, m)
    cost = 0.0
    while (sum(supply) > 0) && (sum(demand) > 0)
        mincost = minimum(problem.costs)
        mincostrow, mincostcol = argmin(problem.costs).I
        amount = min(supply[mincostrow], demand[mincostcol])
        asgnmatrix[mincostrow, mincostcol] = amount
        supply[mincostrow] -= amount
        demand[mincostcol] -= amount
        if supply[mincostrow] == 0
            problem.costs[mincostrow, :] .= Inf
        elseif demand[mincostcol] == 0
            problem.costs[:, mincostcol] .= Inf
        end
        cost += amount * mincost
    end
    result = TransportationResult(t, problem, asgnmatrix, cost, nothing)
    return result
end


function NoInitial(t::TransportationProblem)::TransportationResult
    TransportationResult(t, t, zeros(size(t.costs)), 0.0, nothing)
end


end # end of module  
