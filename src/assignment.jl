module Assignment

using JuMP, HiGHS

struct AssignmentProblem{T<:Real}
    costs::Array{T,2}
end

struct AssignmentResult
    problem::AssignmentProblem
    solution::Matrix
    cost::Real
end


function solve(a::AssignmentProblem)::AssignmentResult
    model = JuMP.Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    n, p = size(a.costs)
    @assert n == p

    @variable(model, x[1:n, 1:p], Bin)
    @objective(model, Min, sum(a.costs .* x))

    @constraint(model, sum(x[1:n, j] for j = 1:p) .== 1.0)
    @constraint(model, sum(x[i, 1:p] for i = 1:n) .== 1.0)

    optimize!(model)

    solution = value.(x)
    cost = JuMP.objective_value(model)

    result = AssignmentResult(a, solution, cost)
    return result
end

export solve
export AssignmentProblem
export AssignmentResult

end # end of module 
