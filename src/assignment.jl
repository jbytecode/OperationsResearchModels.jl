module Assignment

using JuMP, HiGHS


export AssignmentProblem
export AssignmentResult
export isbalanced
export balance

import ..OperationsResearchModels: solve, isbalanced, balance


"""
    AssignmentProblem

# Arguments

- `costs::Matrix{T}`: The cost matrix of the assignment problem.

# Description

The `AssignmentProblem` struct represents an assignment problem with a cost matrix.
"""
struct AssignmentProblem{T<:Real}
    costs::Matrix{T}
end





"""
    AssignmentResult(problem, solution, cost) 

# Arguments

- `problem::AssignmentProblem`: The original assignment problem.
- `solution::Matrix`: The solution matrix of the assignment problem.
- `cost::Real`: The optimal cost of the assignment.

# Description

The `AssignmentResult` struct represents the result of solving an assignment problem.
It contains the original problem, the solution matrix, and the optimal cost.
"""
struct AssignmentResult
    problem::AssignmentProblem
    solution::Matrix
    cost::Real
end


"""
    isbalanced(problem::AssignmentProblem)::Bool

# Description

Checks if the assignment problem is balanced, meaning the number of workers equals the number of tasks.

# Arguments

- `problem::AssignmentProblem`: The assignment problem to check.

# Returns

- `Bool`: Returns `true` if the problem is balanced, otherwise `false`.
"""
function isbalanced(problem::AssignmentProblem)::Bool
    n, p = size(problem.costs)
    return n == p
end


"""
    balance(problem::AssignmentProblem)::AssignmentProblem

# Description

Balances the assignment problem by adding dummy rows or columns if necessary.

# Arguments

- `problem::AssignmentProblem`: The assignment problem to balance.

# Returns

- `AssignmentProblem`: A new `AssignmentProblem` instance with balanced costs.
"""
function balance(problem::AssignmentProblem)::AssignmentProblem
    n, p = size(problem.costs)
    if n == p
        return problem
    elseif n < p
        new_costs = vcat(problem.costs, zeros(p-n, p))
        return AssignmentProblem(new_costs)
    else
        new_costs = hcat(problem.costs, zeros(n, n-p))
        return AssignmentProblem(new_costs)
    end
end



"""
    solve(a)

# Arguments 
`a::AssignmentProblem`: The problem in type of AssignmentProblem

# Output 
`AssignmentResult`: The custom data type that holds problem, solution, and optimum cost. 

# Description 
Solves an assignment problem given by an object of in type `AssignmentProblem`.

# Example 

```julia
julia> mat = [
                   4 8 1;
                   3 1 9;
                   1 6 7;
               ];

julia> problem = AssignmentProblem(mat);

julia> result = solve(problem);

julia> result.solution

3×3 Matrix{Float64}:
 0.0  0.0  1.0
 0.0  1.0  0.0
 1.0  0.0  0.0

julia> result.cost

3.0
```
"""
function solve(a::AssignmentProblem)::AssignmentResult
    model = JuMP.Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    n, p = size(a.costs)
    problem = a

    if n != p 
        problem  = balance(a)
        n, p = size(problem.costs)
    end

    @variable(model, x[1:n, 1:p], Bin)
    @objective(model, Min, sum(problem.costs .* x))

    @constraint(model, sum(x[1:n, j] for j = 1:p) .== 1.0)
    @constraint(model, sum(x[i, 1:p] for i = 1:n) .== 1.0)

    optimize!(model)

    solution = value.(x)
    cost = JuMP.objective_value(model)

    result = AssignmentResult(a, solution, cost)
    return result
end



end # end of module 
