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

end
"""
struct GameResult
    probabilities
    value
end


"""
    solve(p::GameProblem; verbose::Bool = false)::Vector{GameResult}

    Solves a zero-sum game using the simplex method.

# Arguments

- `p::GameProblem`: The problem instance containing the decision matrix.
- `verbose`: If true, prints the model information.

# Returns
- An array of `GameResult` objects containing the probabilities and value of the game.
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

    result = GameResult(values, gamevalue)

    return result

end

end # end of module 
