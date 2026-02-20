module OperationsResearchModelsIpoptExt

using OperationsResearchModels
using Ipopt
using JuMP
using LinearAlgebra
using Statistics


import OperationsResearchModels: solve
import OperationsResearchModels.Portfolio: PortfolioProblem, PortfolioResult

"""
    solve(problem)

# Description

Solves a portfolio optimization problem given by an object of in type `PortfolioProblem`.
The optimization problem is formulated as a quadratic programming problem where the objective
is to minimize the portfolio variance (risk) subject to constraints on the expected return and the weights.

Mathematically, the problem can be stated as:

Minimize: w' * Covmat * w
Subject to:
- sum(w) == 1 (the weights must sum to 1)
- sum(w[i] * means[i] for i in 1:m) >= thresholdreturn
- 0 <= w[i] <= 1 for all i (weights must be between 0 and 1)

Where:
- w is the vector of asset weights
- Covmat is the covariance matrix of asset returns
- means is the vector of expected returns for each asset
- thresholdreturn is the minimum expected return required for the portfolio

# Note

Ipopt is used to solve the quadratic programming problem. Make sure to have 
Ipopt installed and properly configured in your Julia environment to use this function.


# Arguments

- `problem::PortfolioProblem`: The problem in type of PortfolioProblem

# Returns

- `PortfolioResult`: The result of the portfolio optimization problem, containing the optimal weights, expected return, and the JuMP model used to solve the problem.

# Example
```julia
using OperationsResearchModels
using Ipopt

problem = PortfolioProblem(rand(100, 5), 0.01)
result = solve(problem)
println("Optimal Weights: ", result.weights)
println("Expected Return: ", result.expectedreturn)
```
"""
function solve(p::PortfolioProblem)::PortfolioResult
    model = Model(Ipopt.Optimizer)

    MOI.set(model, MOI.Silent(), true)

    means = mean(p.returns, dims = 1)
    covmat = cov(p.returns)

    _, m = size(p.returns)

    @variable(model, 0 <= w[1:m] <= 1)
    @constraint(model, sum(w) == 1)
    @constraint(model, sum(w[i] * means[i] for i in 1:m) >= p.thresholdreturn)
    @objective(model, Min, w' * covmat * w)

    optimize!(model)

    weights = value.(w)
    expectedreturn = sum(weights[i] * means[i] for i in 1:m)

    return PortfolioResult(weights, expectedreturn, model)
end

end
