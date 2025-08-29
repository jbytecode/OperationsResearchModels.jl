module PMedian

export pmedian
export pmedian_with_distances

using JuMP, HiGHS

"""
    PMedianResult

# Fields

- `centers::Vector`: Indices of selected centers.
- `model::JuMP.Model`: JuMP model.
- `objective::Float64`: Objective value.
- `z::Matrix`: Binary matrix of assignments. If z[i, j] = 1 then ith point is connected to the jth point.
- `y::Vector`: Binary vector. If y[i] is 1 then ith point is a depot.
"""
struct PMedianResult
    centers::Vector
    model::JuMP.Model
    objective::Float64
    z::Matrix
    y::Vector
end




function euclidean(u, v)::Float64
    d = (u .- v)
    return (d .* d) |> sum |> sqrt
end




"""

    pmedian(data, ncenters)

# Description

The function calculates Euclidean distances between all possible rows of the matrix data. 
`ncenters` locations are then selected that minimizes the total distances to the nearest rows.


# Arguments 

- `data::Matrix`: Coordinates of locations 
- `ncenters::Int`: Number of centers  

# Output 

- `PMedianResult`: PMedianResult object. 

# Example 

```julia
julia> data1 = rand(10, 2);

julia> data2 = rand(10, 2) .+ 50;

julia> data3 = rand(10, 2) .+ 100;

julia> data = vcat(data1, data2, data3);

julia> result = pmedian(data, 3);

julia> result.centers
3-element Vector{Int64}:
  1
 16
 21

 julia> result.objective
 11.531012240599605
``` 

"""
function pmedian(data::Matrix, ncenters::Int)::PMedianResult

    n, _ = size(data)

    distances = zeros(Float64, n, n)

    for i = 1:n
        for j = i:n
            d = euclidean(data[i, :], data[j, :])
            distances[i, j] = d
            distances[j, i] = d
        end
    end

    return pmedian_with_distances(distances, ncenters)
end



"""

    pmedian_with_distances(distancematrix, ncenters)

# Description

`ncenters` locations are selected that minimizes the total distances to the nearest rows. 

# Arguments 

- `distancematrix::Matrix`: n x n matrix of distances
- `ncenters::Int`: Number of centers 

# Output 
- `PMedianResult`: PMedianResult object. 
"""
function pmedian_with_distances(distancematrix::Matrix, ncenters::Int)::PMedianResult

    n, _ = size(distancematrix)

    # M is a big number enough to make sure that the constraint is always satisfied
    M = 100000.0 * n

    # Utilize the optimizer 
    model = Model(HiGHS.Optimizer)

    # Set the optimizer to be silent
    MOI.set(model, MOI.Silent(), true)

    @variable(model, z[1:n, 1:n], Bin)
    @variable(model, y[1:n], Bin)

    # We ensure that we have exactly ncenters of depots
    @constraint(model, sum(y) == ncenters)

    # We ensure that if a point is connected to another point, then the other point is a depot
    for i = 1:n
        @constraint(model, sum(z[:, i]) <= M * y[i])
    end

    # We ensure that if a point is a depot, then it is connected to at least one point
    for i = 1:n
        @constraint(model, sum(z[i, :]) == 1)
    end

    # If a point is connected to a center then we have some cost
    @objective(model, Min, sum(distancematrix[1:n, 1:n] .* z[1:n, 1:n]))

    optimize!(model)

    return PMedianResult(
        findall(x -> x == 1, value.(y)),
        model,
        JuMP.objective_value(model),
        value.(z),
        value.(y),
    )
end

end # end of module
