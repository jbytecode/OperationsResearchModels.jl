module Transportation

using JuMP, HiGHS



export TransportationProblem
export TransportationResult

import ..OperationsResearchModels: solve



mutable struct TransportationProblem{T<:Real}
    costs::Array{T,2}
    demand::Array{T,1}
    supply::Array{T,1}
end

struct TransportationResult
    originalProblem::TransportationProblem
    balancedProblem::TransportationProblem
    solution::Matrix
    cost::Real
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
    solve(t)

# Arguments 
`a::TransportationProblem`: The problem in type of TransportationProblem

# Output 
`TransportationResult`: The custom data type that holds problem, solution, and optimum cost. 

# Description 
Solves a transportation problem given by an object of in type `TransportationProblem`.

# Example 

```julia
julia> t = TransportationProblem(
                   [   1 1 1 1; 
                       2 2 2 2; 
                       3 3 3 3], 
                   [100, 100, 100, 100], # Demands 
                   [100, 100, 100])      # Supplies 
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100]

julia> isbalanced(t)
false

julia> result = solve(t)
Transportation Results:
Main problem:
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100]

Balanced problem:
Transportation Problem:
Costs: [1 1 1 1; 2 2 2 2; 3 3 3 3; 0 0 0 0]
Demand: [100, 100, 100, 100]
Supply: [100, 100, 100, 100]

Cost:
600.0
Solution:
[-0.0 -0.0 -0.0 100.0; 100.0 -0.0 -0.0 -0.0; -0.0 -0.0 100.0 -0.0; -0.0 100.0 -0.0 -0.0]
```
"""
function solve(t::TransportationProblem)::TransportationResult
    newt = balance(t)

    model = JuMP.Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    n, p = size(newt.costs)

    @variable(model, x[1:n, 1:p] .>= 0)
    @objective(model, Min, sum(newt.costs .* x))

    @constraint(model, sum(x[1:n, j] for j = 1:p) .== newt.supply)
    @constraint(model, sum(x[i, 1:p] for i = 1:n) .== newt.demand)

    optimize!(model)

    solution = value.(x)
    cost = JuMP.objective_value(model)

    result = TransportationResult(t, newt, solution, cost)
    return result
end

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

    while (i <= n) || (j <= m)
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
    result = TransportationResult(t, problem, asgnmatrix, cost)
    return result
end



end # end of module  
