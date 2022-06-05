module Game 

using JuMP, HiGHS

struct GameResult
    probabilities
    value
end

function game(decisionMatrix::Matrix{<: Real}; verbose::Bool=false)::Array{GameResult, 1}
    rowplayers_result = game_solver(decisionMatrix, verbose = verbose)
    columnplayers_result = game_solver(Matrix(decisionMatrix') * -1.0, verbose = verbose)
    return [rowplayers_result, columnplayers_result]
end

function game_solver(gamematrix::Matrix{<: Real}; verbose::Bool=false)::GameResult
    
    nrow, ncol = size(gamematrix)

    model = Model(HiGHS.Optimizer);
    MOI.set(model, MOI.Silent(), !verbose)


    @variable(model, x[1:nrow])
    @variable(model, g)
    @objective(model, Max, g)

    for i in 1:ncol
        @constraint(model, sum(x[1:nrow] .* gamematrix[:, i]) >= g)
    end

    for i in 1:nrow
        @constraint(model, x[i] >= 0)
    end

    @constraint(model, sum(x) == 1.0)

    if verbose
        @info model 
    end 
    
    optimize!(model);

    values = JuMP.value.(x)

    gamevalue = JuMP.value(g) #objective_value(model)
    
    result = GameResult(
        values,
        gamevalue
    )
    
    return result

end

end # end of module 