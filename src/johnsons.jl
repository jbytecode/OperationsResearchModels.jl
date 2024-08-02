module Johnsons


import ..RandomKeyGA: run_ga, Chromosome, Population, generation, run_ga

export JohnsonResult
export JohnsonException
export johnsons
export makespan 
export johnsons_ga 


struct JohnsonException <: Exception
    message::String
end


struct JohnsonResult
    permutation::Vector{Int}
    # makespan::Float64
end

struct Process
    start
    duration
    finish
end 


"""
    johnsons_ga(times::Matrix; popsize = 100, ngen = 1000, pcross = 0.8, pmutate = 0.01, nelites = 1)::JohnsonResult

Given a matrix of times, returns a JohnsonResult with the permutation of the jobs.
The function uses a genetic algorithm to find the best permutation of the jobs. 
The genetic algorithm is implemented in the RandomKeyGA module.

# Arguments

- `times::Matrix`: a matrix of times
- `popsize::Int`: the population size. Default is 100
- `ngen::Int`: the number of generations. Default is 1000
- `pcross::Float64`: the crossover probability. Default is 0.8
- `pmutate::Float64`: the mutation probability. Default is 0.01
- `nelites::Int`: the number of elites. Default is 1

# Returns

- `JohnsonResult`: a custom data type that holds the permutation of the jobs


# Example

```julia
times = Float64[
    3.1 2.8;
    4.0 7.0;
    8.0 3.0;
    5.0 8.0;
    6.0 4.0;
    8.0 5.0;
    7.0 4.0
]

result = johnsons(times)

println(result.permutation)
```
"""
function johnsons_ga(times::Matrix; popsize = 100, ngen = 1000, pcross = 0.8, pmutate = 0.01, nelites = 1)::JohnsonResult

    n, m = size(times)
    
    function costfn(perm::Vector{Int})
        return makespan(times, perm)
    end 

    finalpop = run_ga(popsize, n, costfn, ngen, pcross, pmutate, nelites)

    return JohnsonResult(sortperm(finalpop.chromosomes[1].values))
end



"""
    johnsons(times::Matrix)

Given a matrix of times, returns a JohnsonResult with the permutation of the jobs. 
If number of machines is 2, it uses the Johnson's algorithm for 2 machines.
If number of machines is greater than 2, it uses the Johnson's algorithm by transforming the 
problem into a 2-machine problem.
In order to reduce the original problem to a 2-machine problem, the algorithm checks if the minimum time
of the first machine is greater or equal than the maximum time of the other machines and/or if the minimum time of the 
last machine is greater or equal than the maximum time of the other machines.

For example if we have 4 machines, namely, A, B, C, and D 
at least one of the following conditions must be satisfied:

- min(A) >= max(B, C)
- min(D) >= max(B, C)

The function throws a JohnsonException if the problem cannot be reduced to a 2-machine problem.

# Arguments

- `times::Matrix`: a matrix of times

# Returns

- `JohnsonResult`: a custom data type that holds the permutation of the jobs

# Example

```julia
times = Float64[
    3.1 2.8;
    4.0 7.0;
    8.0 3.0;
    5.0 8.0;
    6.0 4.0;
    8.0 5.0;
    7.0 4.0
]

result = johnsons(times)

println(result.permutation)
```
"""
function johnsons(times::Matrix)
    _, m = size(times)
    if m == 2
        return johnsons_2machines(times)
    else
        return johnsons_nmachines(times)
    end
end

function dofirst!(locrow::Int, permutation::Vector{Int})
    for i in 1:length(permutation)
        if permutation[i] == -1
            permutation[i] = locrow
            return
        end
    end
end

function dolast!(locrow::Int, permutation::Vector{Int})
    for i in length(permutation):-1:1
        if permutation[i] == -1
            permutation[i] = locrow
            return
        end
    end
end

function johnsons_2machines(timesmatrix::Matrix)::JohnsonResult
    times = copy(timesmatrix)
    n, m = size(times)
    @assert m == 2

    typed_inf = typemax(eltype(times))

    permutation = [-1 for i in 1:n]
    for i in 1:n
        locrow, loccol = argmin(times).I
        if loccol == 1
            dofirst!(locrow, permutation)
        else
            dolast!(locrow, permutation)
        end
        times[locrow, :] .= typed_inf
    end
    return JohnsonResult(permutation)
end


function johnsons_nmachines(times::Matrix)::JohnsonResult
    minfirst = minimum(times[:, 1])
    minlast = minimum(times[:, end])
    maxothers = maximum(times[:, 2:(end-1)])

    if !((minfirst >= maxothers) || (minlast >= maxothers))
        throw(JohnsonException("The problem cannot be reduced to a 2-machine problem: minfirst >= maxothers and/or minlast >= maxothers"))
    end

    Gcollection = times[:, 1:(end-1)]
    Hcollection = times[:, 2:end]

    G = sum(Gcollection, dims=2)
    H = sum(Hcollection, dims=2)

    return johnsons_2machines([G H])
end




"""
    makespan(times::Matrix, permutation::Vector{Int})

    Given a matrix of times and a permutation of the jobs, returns the makespan of the jobs.

# Arguments

- `times::Matrix`: a matrix of times
- `permutation::Vector{Int}`: a permutation of the jobs

# Returns
- `Float64`: the makespan of the jobs

# Example

```julia

julia> times = Float64[
    3 3 5;
    8 4 8;
    7 2 10;
    5 1 7;
    2 5 6    
]

julia> result = makespan(times, [1, 4, 5, 3, 2])
```
"""
function makespan(times::Matrix, permutation::Vector{Int})::Float64

    n, m = size(times)

    timetable = Array{Process,2}(undef, m, n)

    for machine_id in 1:m
        for task_id in 1:n
            current_task = permutation[task_id]
            if machine_id == 1
                if task_id == 1
                    start = 0
                else
                    start = timetable[machine_id, task_id-1].finish
                end
            else
                if task_id == 1
                    start = timetable[machine_id-1, task_id].finish
                else
                    start = max(timetable[machine_id, task_id-1].finish, timetable[machine_id-1, task_id].finish)
                end
            end
            duration = times[current_task, machine_id]
            finish = start + duration
            timetable[machine_id, task_id] = Process(start, duration, finish)
        end
    end

    return timetable[end, end].finish
end

end # end of module Johnsons