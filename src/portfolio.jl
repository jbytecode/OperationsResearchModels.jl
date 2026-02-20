module Portfolio

using JuMP, Statistics, LinearAlgebra

import ..OperationsResearchModels: solve

export PortfolioProblem, PortfolioResult




"""
    PortfolioProblem

# Description

Defines the portfolio optimization problem.

# Fields

- `returns::Matrix{<:Real}`: A matrix of historical returns for the assets.
- `thresholdreturn::Real`: The minimum expected return required for the portfolio.

"""
struct PortfolioProblem
    returns::Matrix{<:Real}
    thresholdreturn::Real 
end 



"""
    PortfolioResult

# Description

A structure to hold the result of the portfolio optimization problem.

# Fields

- `weights::Vector{Float64}`: The optimal weights for the assets in the portfolio.
- `expectedreturn::Float64`: The expected return of the optimal portfolio.
- `model::JuMP.Model`: The JuMP model used to solve the problem.
"""
struct PortfolioResult
    weights::Vector{Float64}
    expectedreturn::Float64
    model::JuMP.Model
end



end # end of module