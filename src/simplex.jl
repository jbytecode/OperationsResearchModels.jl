module Simplex

export SimplexProblem
export OptimizationType, Maximize, Minimize
export Direction, LE, GE, EQ
export setautomaticvarnames, setdirections
export setlhs, setrhs, setobjectivecoefs, setopttype
export standardform!
export update!
export singleiteration!
export simplexiterations
export simplexpretty
export createsimplexproblem
export solve!

import ..Utility: numround


@enum OptimizationType begin
    Maximize
    Minimize
end

@enum Direction begin
    LE
    GE
    EQ
end

mutable struct SimplexProblem
    lhs::Matrix
    rhs::Vector
    z::Vector
    opttype::OptimizationType
    directions::Vector{Direction}
    varnames::Vector{String}
    slackvariableindices::Vector{Int}
    surplusvariableindices::Vector{Int}
    artificialvariableindices::Vector{Int}
    basicvariableindex::Vector{Int}
    biggestvalue::Float64
    isinstandardform::Bool
    converged::Bool
    objective_value::Float64
end

function SimplexProblem()::SimplexProblem
    SimplexProblem(
        Array{Float64,2}(undef, 0, 0),   # LHS 
        Float64[],                       # RHS 
        Float64[],                       # z 
        Maximize,                        # opttype
        Direction[],                     # Direction 
        String[],                        # Variable names 
        Int[],                           # Slack indices 
        Int[],                           # Surplus indices 
        Int[],                           # Artificial indices 
        Int[],                          # Basic variables 
        -Inf64,                           # Biggest value for M - Method 
        false,                             # is it in standard form?
        false,                              # Converged?
        0.0,                                # Objective Value
    )
end

function Base.copy(source::SimplexProblem)
    s = SimplexProblem()
    s.artificialvariableindices = copy(source.artificialvariableindices)
    s.basicvariableindex = copy(source.basicvariableindex)
    s.biggestvalue = copy(source.biggestvalue)
    s.converged = copy(source.converged)
    s.directions = copy(source.directions)
    s.isinstandardform = copy(source.isinstandardform)
    s.lhs = copy(source.lhs)
    s.opttype = copy(source.opttype)
    s.rhs = copy(source.rhs)
    s.slackvariableindices = copy(source.slackvariableindices)
    s.surplusvariableindices = copy(source.surplusvariableindices)
    s.varnames = copy(source.varnames)
    s.z = copy(source.z)
    s.objective_value = copy(source.objective_value)
    return s
end

function Base.copy(source::OptimizationType)
    return source
end


function updatebiggestvalue(s::SimplexProblem)
    ms = []

    if !isempty(s.lhs)
        push!(ms, maximum(s.lhs) |> abs)
    end

    if !isempty(s.rhs)
        push!(ms, maximum(s.rhs) |> abs)
    end

    if !isempty(s.z)
        push!(ms, maximum(s.z) |> abs)
    end

    s.biggestvalue = maximum(ms) * 10
end

function setautomaticvarnames(s::SimplexProblem)
    _, p = size(s.lhs)
    s.varnames = Array{String,1}(undef, p)
    for i = 1:p
        s.varnames[i] = string("x", i)
    end
end


function setvariablenames(s::SimplexProblem, names::Vector{String})
    s.varnames = names
end

function setlhs(s::SimplexProblem, lhs::Matrix)
    s.lhs = lhs
end

function setrhs(s::SimplexProblem, rhs::Vector)
    s.rhs = rhs
end

function setobjectivecoefs(s::SimplexProblem, z::Vector)
    s.z = z
end

function setopttype(s::SimplexProblem, t::OptimizationType)
    s.opttype = t
end

function setdirections(s::SimplexProblem, d::Vector{Direction})
    s.directions = d
end

function sumproduct(io::IO, coefs::Vector, varnames::Vector)
    @assert length(coefs) == length(varnames)
    l = length(coefs)
    for i = 1:l
        print(io, numround(coefs[i]), varnames[i])
        if i < l
            print(io, " + ")
        end
    end
end

function Base.show(io::IO, s::SimplexProblem)
    n, p = size(s.lhs)
    print(s.opttype, " -> ")
    sumproduct(io, s.z, s.varnames)
    print(" = ", numround(s.objective_value))
    println(io)
    println(io, "S.t:")
    for i = 1:n
        if !isempty(s.basicvariableindex)
            bi = s.basicvariableindex[i]
            bis = s.varnames[bi]
            print(io, bis, ": ")
        end
        sumproduct(io, s.lhs[i, :], s.varnames)
        println(io, " ", s.directions[i], " ", numround(s.rhs[i]))
    end
    if !isempty(s.slackvariableindices)
        println(io, "Slack: ", s.slackvariableindices)
    end
    if !isempty(s.surplusvariableindices)
        println(io, "Surplus: ", s.surplusvariableindices)
    end
    if !isempty(s.artificialvariableindices)
        println(io, "Artificial: ", s.artificialvariableindices)
    end
    if !isempty(s.basicvariableindex)
        println(io, "Basic Variables: ", s.basicvariableindex)
    end
    println(io, "All variables are non-negative")
    if s.converged
        println(io, "Status: CONVERGED!")
    end
end

function addslackvariable!(s::SimplexProblem, constraintindex::Int)
    n, p = size(s.lhs)
    @assert constraintindex <= n
    zs = zeros(Float64, n)

    # Update LHS 
    s.lhs = hcat(s.lhs, zs)
    s.lhs[constraintindex, p+1] = 1.0

    # Update objective coef vector 
    push!(s.z, 0.0)

    push!(s.slackvariableindices, p + 1)

    push!(s.basicvariableindex, p + 1)

    push!(s.varnames, string("x", p + 1))

    s.directions[constraintindex] = EQ
end


function addsurplusvariable!(s::SimplexProblem, constraintindex::Int)
    n, p = size(s.lhs)
    @assert constraintindex <= n
    zs = zeros(Float64, n)

    # Update LHS 
    s.lhs = hcat(s.lhs, zs)
    s.lhs[constraintindex, p+1] = -1.0

    # Update objective coef vector 
    push!(s.z, 0.0)

    push!(s.surplusvariableindices, p + 1)

    push!(s.varnames, string("x", p + 1))

    s.directions[constraintindex] = EQ
end

function addartificialvariable(s::SimplexProblem, constraintindex::Int)
    M = s.biggestvalue

    n, p = size(s.lhs)
    @assert constraintindex <= n

    zs = zeros(Float64, n)

    # Update LHS 
    s.lhs = hcat(s.lhs, zs)
    s.lhs[constraintindex, p+1] = 1.0

    # Update objective coef vector 
    if s.opttype == Maximize
        push!(s.z, -M)
    elseif s.opttype == Minimize
        push!(s.z, M)
    else
        error("Optimization type not found: " + string(s.opttype))
    end

    push!(s.artificialvariableindices, p + 1)

    push!(s.basicvariableindex, p + 1)

    push!(s.varnames, string("x", p + 1))

    s.directions[constraintindex] = EQ
end

function invert(d::Direction)::Direction
    if d == LE
        return GE
    elseif d == GE
        return LE
    else
        return EQ
    end
end

function Base.print(io::IO, dir::Direction)
    if dir == LE
        print(io, "<=")
    elseif dir == GE
        print(io, ">=")
    elseif dir == EQ
        print(io, "==")
    else
        error("Undefined dir: $dir")
    end
end



function makerhspositive!(s::SimplexProblem)
    nc = length(s.rhs)
    for i = 1:nc
        if s.rhs[i] < 0
            s.lhs[i, :] = (-1) .* s.lhs[i, :]
            s.rhs[i] = (-1) * s.rhs[i]
            s.directions[i] = invert(s.directions[i])
        end
    end
end

function standardform!(s::SimplexProblem)
    if s.isinstandardform
        @warn "The problem is already in standard form"
        return
    end
    updatebiggestvalue(s)
    makerhspositive!(s)
    n, p = size(s.lhs)
    for i = 1:n
        d = s.directions[i]
        if d == LE
            addslackvariable!(s, i)
        elseif d == GE
            addsurplusvariable!(s, i)
            addartificialvariable(s, i)
        elseif d == EQ
            addartificialvariable(s, i)
        else
            error("Direction not found: " + string(d))
        end
    end
    s.isinstandardform = true
end

function mmethodcorrection(s::SimplexProblem)
    M = s.biggestvalue
    n, p = size(s.lhs)
    for i = 1:n
        idx = s.basicvariableindex[i]
        if idx in s.artificialvariableindices
            if s.opttype == Maximize
                s.z .= s.z .+ M * s.lhs[i, :]
                s.objective_value = s.objective_value - M * s.rhs[i]
            else
                s.z .= s.z .- M * s.lhs[i, :]
                s.objective_value = s.objective_value + M * s.rhs[i]
            end
        end
    end
end


function update!(s::SimplexProblem, enteringvarindex::Int, exitingvarindex::Int)::Nothing

    n, p = size(s.lhs)

    rowindex = findfirst(x -> x == exitingvarindex, s.basicvariableindex)

    pivot = Float64(s.lhs[rowindex, enteringvarindex])

    s.lhs[rowindex, :] ./= pivot
    s.rhs[rowindex] /= pivot

    for i = 1:n
        if i != rowindex
            pp = s.lhs[i, enteringvarindex]
            s.lhs[i, :] = s.lhs[i, :] - pp * s.lhs[rowindex, :]
            s.rhs[i] = s.rhs[i] - pp * s.rhs[rowindex]
        end
    end

    pp = s.z[enteringvarindex]
    s.z = s.z .- pp * s.lhs[rowindex, :]

    s.objective_value = s.objective_value + pp * s.rhs[rowindex]

    s.basicvariableindex[rowindex] = enteringvarindex

    return nothing
end


function getenteringvariableindex(s::SimplexProblem)::Union{Nothing,Int}
    if s.opttype == Maximize
        value, index = findmax(s.z)
        if value <= 0
            return nothing
        else
            return index
        end
    else
        value, index = findmin(s.z)
        if value >= 0
            return nothing
        else
            return index
        end
    end
end

function getexitingvariableindex(s::SimplexProblem, entering::Int)::Union{Nothing,Int}
    therow = s.lhs[:, entering]
    ratios = s.rhs ./ therow
    eindex = nothing
    minval = Inf64
    n = length(ratios)
    for i = 1:n
        rs = ratios[i]
        if rs > 0 && !isinf(rs)
            if rs < minval
                minval = rs
                eindex = i
            end
        end
    end
    return eindex
end

function singleiteration!(s::SimplexProblem)
    enteringvariableindex = getenteringvariableindex(s)

    if isnothing(enteringvariableindex)
        s.converged = true
        return
    end

    exitingvariableindex = getexitingvariableindex(s, enteringvariableindex)
    rowindex = s.basicvariableindex[exitingvariableindex]

    update!(s, enteringvariableindex, rowindex)
end

function solve!(s::SimplexProblem)::SimplexProblem
    standardform!(s)

    mmethodcorrection(s)

    while !s.converged
        singleiteration!(s)
    end

    return s
end

function simplexiterations(s::SimplexProblem)::Vector{SimplexProblem}
    iterations = Array{SimplexProblem,1}(undef, 0)

    s1 = copy(s)
    standardform!(s1)
    push!(iterations, s1)

    s2 = copy(s1)
    mmethodcorrection(s2)
    push!(iterations, s2)

    while !s2.converged
        s2 = copy(s2)
        singleiteration!(s2)
        push!(iterations, s2)
    end

    return iterations
end

function simplexpretty(s::SimplexProblem; maxiter::Int = 1000)::Nothing

    copied::SimplexProblem = copy(s)

    @info "The problem:"
    println(copied)

    @info "The standard form:"
    standardform!(copied)
    println(copied)

    @info "M Method corrections:"
    mmethodcorrection(copied)
    println(copied)


    for i = 1:maxiter
        if copied.converged
            break
        end
        singleiteration!(copied)
        @info "Iteration $i"
        println(copied)
    end

    @info "The problem is converged"
    @info "Here is the result"
    varnames = copied.varnames[copied.basicvariableindex]
    for i = 1:length(varnames)
        @info "$(varnames[i]) = $(copied.rhs[i])"
    end

    @info "Objective value: $(copied.objective_value)"
    println()
end


function createsimplexproblem(
    obj::Vector,
    amat::Matrix,
    rhs::Vector,
    dir::Vector,
    opttype::OptimizationType,
)::SimplexProblem

    s = SimplexProblem()
    setobjectivecoefs(s, obj)
    setlhs(s, amat)
    setrhs(s, rhs)
    setdirections(s, dir)
    setopttype(s, opttype)
    setautomaticvarnames(s)

    return s
end


end # end of module Simplex 
