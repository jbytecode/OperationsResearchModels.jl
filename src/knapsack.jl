module Knapsack

import ..OperationsResearchModels: solve

export knapsack
export KnapsackResult

using JuMP, HiGHS


"""
    KnapsackResult

# Description

A structure to hold the result of the knapsack problem.

# Fields

- `selected`: A vector of booleans indicating which items are selected.
- `model`: The JuMP model used to solve the problem.
- `objective`: The objective value of the model.
"""
struct KnapsackResult
    selected::Vector{Bool}
    model::JuMP.Model
    objective::Float64
end



"""
    KnapsackProblem

# Description

Defines the knapsack problem.

# Fields

- `values::Vector{Float64}`: The values of the items.
- `weights::Vector{Float64}`: The weights of the items.
- `capacity::Float64`: The maximum capacity of the knapsack.

# Output
- `KnapsackResult`: The custom data type that holds selected items, model, and objective value.
"""
struct KnapsackProblem
    values::Vector{Float64}
    weights::Vector{Float64}
    capacity::Float64
end


"""
    solve(problem::KnapsackProblem)::KnapsackResult


# Description

Solves the knapsack problem.


# Arguments

- `problem::KnapsackProblem`: The problem in type of KnapsackProblem.

# Output

- `KnapsackResult`: The custom data type that holds selected items, model, and objective value.

# Example
```julia
julia> values = [10, 20, 30, 40, 50];
julia> weights = [1, 2, 3, 4, 5];
julia> capacity = 10;
julia> solve(KnapsackProblem(values, weights, capacity));
```
"""
function solve(problem::KnapsackProblem)::KnapsackResult

    values = problem.values
    weights = problem.weights
    capacity = problem.capacity


    n = length(values)
    model = Model(HiGHS.Optimizer)

    MOI.set(model, MOI.Silent(), true)

    @variable(model, x[1:n], Bin)
    @objective(model, Max, sum(values[i] * x[i] for i = 1:n))
    @constraint(model, sum(weights[i] * x[i] for i = 1:n) <= capacity)
    optimize!(model)

    selected = value.(x)
    return KnapsackResult(selected, model, objective_value(model))
end

end # End of module Knapsack
