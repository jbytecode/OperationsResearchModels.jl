module ProjectSelection

export ProjectSelectionProblem
export ProjectSelectionResult

using JuMP, HiGHS

import ..OperationsResearchModels: solve



"""
    ProjectSelectionProblem

# Description

    Defines the project selection problem.

# Fields

- `cost::Matrix`: A matrix where each row represents a project and each column represents a resource. The values in the matrix represent the cost of using that resource for that project.
- `budgets::Vector`: A vector where each element represents the budget available for the corresponding resource.
- `returns::Vector`: A vector where each element represents the return of selecting the corresponding project.
"""
struct ProjectSelectionProblem
    cost::Matrix
    budgets::Vector
    returns::Vector
end


"""
    ProjectSelectionResult

# Description

    A structure to hold the result of the project selection problem.

# Fields

- `selected`: A vector of booleans (0 and 1s) indicating which projects are selected.
- `objective`: The objective value of the model.
- `model`: The JuMP model used to solve the problem.
"""
struct ProjectSelectionResult
    selected::Vector
    objective::Float64
    model::JuMP.Model
end





"""
    solve(problem::ProjectSelectionProblem)::ProjectSelectionResult

# Description

    Solves the project selection problem using JuMP and HiGHS.

# Arguments

- `problem::ProjectSelectionProblem`: The project selection problem to be solved.

# Returns

- `ProjectSelectionResult`: The result of the project selection problem.
"""
function solve(problem::ProjectSelectionProblem)::ProjectSelectionResult

    n, p = size(problem.cost)

    model = Model(HiGHS.Optimizer)

    MOI.set(model, MOI.Silent(), true)

    @variable(model, x[1:n], Bin)

    @objective(model, Max, sum(problem.returns[i] * x[i] for i in 1:n))

    for colnum in 1:p
        @constraint(model, sum(problem.cost[rownum, colnum] * x[rownum] for rownum in 1:n) <= problem.budgets[colnum])
    end

    optimize!(model)

    selected = value.(x)

    objective = objective_value(model)

    return ProjectSelectionResult(selected, objective, model)
end


end # End of module ProjectSelection