module Game

using JuMP, HiGHS


import ..OperationsResearchModels: solve


"""
    GameProblem 

# Description

Defines the problem of a zero-sum game.

# Fields

- `decisionMatrix::Matrix{<:Real}`: The payoff matrix of the game designed for the row player.
"""
struct GameProblem
    decisionMatrix::Matrix{<:Real}
end


"""
    GameResult

# Description

A structure to hold the result of a game.

# Fields

- `probabilities`: Probabilities of the strategies
- `value`:         Value of the game
- `model::JuMP.Model`: The JuMP model used to solve the game.

"""
struct GameResult
    probabilities::Any
    value::Any
    model::JuMP.Model
end


"""
    solve(p::GameProblem; verbose::Bool = false)::Vector{GameResult}

Solves a zero-sum game using the simplex method.

# Arguments

- `p::GameProblem`: The problem instance containing the decision matrix.
- `verbose`: If true, prints the model information.

# Returns
- An array of `GameResult` objects containing the probabilities and value of the game.

# Example 

```julia
mat = [1 4 5; 5 6 2]

# 1 4 5
# 5 6 2
# The row player has 2 strategies, and the column player has 3 strategies.
# If the row player selects the first strategy and the column player selects the second strategy,
# the row player receives 4.

problem = GameProblem(mat)

result = solve(problem)

result1 = result[1]  # The result for the row player

println(result1.probabilities)
# 2-element Vector{Float64}:
#  0.42857142857142855
#  0.5714285714285714

println(result1.value)
# 3.285714285714285

result2 = result[2]  # The result for the column player

println(result2.probabilities)
# 3-element Vector{Float64}:
#   0.42857142857142855
#  -0.0
#   0.5714285714285714

println(result2.value)
# -3.285714285714285
```
"""
function solve(p::GameProblem; verbose::Bool = false)::Vector{GameResult}
    rowplayers_result = game_solver(p.decisionMatrix, verbose = verbose)
    columnplayers_result = game_solver(Matrix(p.decisionMatrix') * -1.0, verbose = verbose)
    return [rowplayers_result, columnplayers_result]
end




function game_solver(gamematrix::Matrix{<:Real}; verbose::Bool = false)::GameResult

    nrow, ncol = size(gamematrix)

    model = Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), !verbose)


    @variable(model, x[1:nrow])
    @variable(model, g)
    @objective(model, Max, g)

    for i = 1:ncol
        @constraint(model, sum(x[1:nrow] .* gamematrix[:, i]) >= g)
    end

    for i = 1:nrow
        @constraint(model, x[i] >= 0)
    end

    @constraint(model, sum(x) == 1.0)

    if verbose
        @info model
    end

    optimize!(model)

    values = JuMP.value.(x)

    gamevalue = JuMP.value(g) #objective_value(model)

    result = GameResult(values, gamevalue, model)

    return result

end

end # end of module 
