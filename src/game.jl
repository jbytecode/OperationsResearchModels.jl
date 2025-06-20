module Game

using JuMP, HiGHS


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
    game(decisionMatrix::Matrix{<:Real}; verbose::Bool = false)::Vector{GameResult}

    Solves a zero-sum game using the simplex method.

# Arguments

- `decisionMatrix`: The payoff matrix of the game.
- `verbose`: If true, prints the model information.

# Returns
- An array of `GameResult` objects containing the probabilities and value of the game.
"""
function game(decisionMatrix::Matrix{<:Real}; verbose::Bool = false)::Vector{GameResult}
    rowplayers_result = game_solver(decisionMatrix, verbose = verbose)
    columnplayers_result = game_solver(Matrix(decisionMatrix') * -1.0, verbose = verbose)
    return [rowplayers_result, columnplayers_result]
end



"""
    game_solver(gamematrix::Matrix{<:Real}; verbose::Bool = false)::GameResult

    Solves a zero-sum game using the simplex method.

# Arguments

- `gamematrix`: The payoff matrix of the game.
- `verbose`: If true, prints the model information.

# Returns

- A `GameResult` object containing the probabilities and value of the game.
"""
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
