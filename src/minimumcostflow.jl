module MinimumCostFlow

using JuMP, HiGHS
import ..OperationsResearchModels: solve

import ..Network: Connection, nodes, start, finish, hassameorder, inflow, outflow
import ..MaximumFlow: MaximumFlowProblem, MaximumFlowResult

export MinimumCostFlowProblem, MinimumCostFlowResult



"""
    MinimumCostFlowProblem

# Description

Defines the minimum cost flow problem.

# Fields

- `connections::Vector{Connection}`: The connections (edges) in the network.
- `costs::Vector{Connection}`: The costs associated with each connection.

"""
struct MinimumCostFlowProblem
    connections::Vector{Connection}
    costs::Vector{Connection}
end



"""
    MinimumCostFlowResult

# Description

A structure to hold the result of the minimum cost flow problem.

# Fields

- `path::Vector{Connection}`: The connections (edges) in the flow path.
- `cost::Float64`: The total cost of the flow.

"""
struct MinimumCostFlowResult
    path::Vector{Connection}
    cost::Float64
end



"""
    solve(problem, flow)

# Description

This function solves the Minimum Cost Flow problem given a flow value.

# Arguments

- `problem::MinimumCostFlowProblem`: The problem in type of MinimumCostFlowProblem
- `flow::Float64`: The flow value to be used in the problem.


"""
function solve(problem::MinimumCostFlowProblem, flow::Float64)::MinimumCostFlowResult
    cns = problem.connections
    costs = problem.costs

    if !hassameorder(cns, costs)
        throw(ArgumentError("Connections and costs must have the same order."))
    end

    model = Model(HiGHS.Optimizer)
    MOI.set(model, MOI.Silent(), true)

    mynodes = nodes(cns)
    n = length(mynodes)

    startnode = start(cns)
    finishnode = finish(cns)

    # Variables 
    @variable(model, x[1:n, 1:n] .>= 0)

    # Objective Function
    @objective(model, Min, sum(x[conn.from, conn.to] * conn.value for conn in costs))

    # Constraints 
    for nextnode in mynodes
        leftexpr = inflow(x, nextnode, cns, model)
        rightexpr = outflow(x, nextnode, cns, model)
        if leftexpr == :f
            @constraint(model, rightexpr == flow)
        elseif rightexpr == :f
            @constraint(model, leftexpr == flow)
        else
            @constraint(model, leftexpr - rightexpr == 0)
        end
    end

    for nd in cns
        @constraint(model, x[nd.from, nd.to] <= nd.value)
    end

    optimize!(model)

    xs = value.(x)
    cost = JuMP.objective_value(model)
    solutionnodes = []
    for i = 1:n
        for j = 1:n
            if xs[i, j] > 0
                push!(solutionnodes, Connection(i, j, xs[i, j]))
            end
        end
    end

    return MinimumCostFlowResult(solutionnodes, cost)
end


"""
    solve(problem)

# Description

This function solves the Minimum Cost Flow problem by first solving the Maximum Flow problem and 
then using the flow value to solve the Minimum Cost Flow problem.

# Arguments

- `problem::MinimumCostFlowProblem`: The problem in type of MinimumCostFlowProblem


!!! info "Determining start and finish nodes"

    In this function it's assumed that the problem has a unique start and finish node.
    A heuristic approach is used to find the start and finish nodes. If a node has only
    outcoming connections, it is considered the start node. If a node has only incoming connections,
    it is considered the finish node. Of course a network can have multiple start and finish nodes,
    but this heuristic simplifies the problem. Future implementations could explore more complex
    scenarios with multiple start and finish nodes. 
"""
function solve(problem::MinimumCostFlowProblem)::MinimumCostFlowResult

    maximumflowproblem = MaximumFlowProblem(problem.connections)

    maximumflowresult = solve(maximumflowproblem)

    f = maximumflowresult.flow

    result::MinimumCostFlowResult = solve(problem, f)

    return result
end


end # end of module MinimumCostFlow
