module PMedian

export pmedian

using JuMP, HiGHS 

function euclidean(u, v)::Float64
    d = (u .- v)
    return (d .* d) |> sum |> sqrt 
end 

function pmedian(data::Matrix, ncenters:: Int)
    
    n, p = size(data)

    distances = zeros(Float64, n, n)

    for i in 1:n
        for j in i:n
            d = euclidean(data[i, :], data[j, :])
            distances[i, j] = d
            distances[j, i] = d
        end 
    end 

    model = Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    @variable(model, z[1:n, 1:n], Bin)
    @variable(model, y[1:n], Bin)

    @constraint(model, sum(y) == ncenters)

    for i in 1:n
        for j in 1:n
            @constraint(model, z[i, j] .<= y[j])
        end 
    end

    for i in 1:n
        @constraint(model, sum(z[i, :]) == 1)
    end 

    @objective(model, Min, sum(distances[1:n, 1:n] .* z[1:n, 1:n]))

    optimize!(model)

    return Dict(
        "z" => value.(z),
        "y" => value.(y),
        "centers" => findall(x -> x == 1, value.(y)),
        "objective" => JuMP.objective_value(model),
        "model" => model
    )
end 

end # end of module