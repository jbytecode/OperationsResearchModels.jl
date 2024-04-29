module Knapsack

export knapsack
export KnapsackResult

using JuMP, HiGHS

struct KnapsackResult
    selected::Vector{Bool}
    model::JuMP.Model
    objective::Float64
end 


"""
    knapsack(values, weights, capacity)


# Description

Solves the knapsack problem.

# Arguments

- `values::Vector{Float64}`: Values of items.
- `weights::Vector{Float64}`: Weights of items.
- `capacity::Float64`: Capacity of the knapsack.

# Output

- `KnapsackResult`: The custom data type that holds selected items, model, and objective value.

"""
function knapsack(values, weights, capacity)::KnapsackResult

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