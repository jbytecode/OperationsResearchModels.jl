module RandomKeyGA

export Chromosome
export Population
export create_population
export onepoint_crossover
export random_mutation
export tournament_selection
export generation
export run_ga

mutable struct Chromosome
    values::Vector{Float64}
    cost::Float64
end

mutable struct Population{F<:Function}
    chromosomes::Vector{Chromosome}
    costfn::F
end

function Chromosome(len::Int)
    return Chromosome(rand(len), Inf64)
end

function Chromosome(vals::Vector{Float64})
    return Chromosome(vals, Inf64)
end

function create_population(popsize::Int, chsize::Int, costfn::F) where {F<:Function}
    chs = Chromosome[Chromosome(chsize) for i in 1:popsize]
    return Population(chs, costfn)
end

function onepoint_crossover(ch::Chromosome, ch2::Chromosome)::Chromosome
    L = length(ch.values)
    cutpoint = rand(2:(L-1))
    vals1 = vcat(ch.values[1:cutpoint], ch2.values[(cutpoint+1):end])
    return Chromosome(vals1)
end

function random_mutation(ch::Chromosome)::Chromosome
    luckyindex = rand(1:length(ch.values))
    newch = Chromosome(copy(ch.values))
    newch.values[luckyindex] = rand()
    return newch
end

function tournament_selection(pop::Population, tournament_size::Int)::Chromosome
    indices = rand(1:length(pop.chromosomes), tournament_size)
    chromosomes = pop.chromosomes[indices]
    sorted_chromosomes = sort!(chromosomes, by=ch -> ch.cost)
    return sorted_chromosomes[1]
end

function generation(initialpop::Population, pcross::Float64, pmutate::Float64, nelites::Int)::Population

    n = length(initialpop.chromosomes)

    for i in 1:n
        initialpop.chromosomes[i].cost = initialpop.costfn(sortperm(initialpop.chromosomes[i].values))
    end

    sort!(initialpop.chromosomes, by=ch -> ch.cost)


    chsize = length(initialpop.chromosomes[1].values)

    newpop = create_population(n, chsize, initialpop.costfn)

    for i in 1:nelites
        newpop.chromosomes[i] = Chromosome(initialpop.chromosomes[i].values, initialpop.chromosomes[i].cost)
    end

    for i in (nelites+1):n
        ch1 = tournament_selection(initialpop, 2)

        if rand() < pcross
            ch2 = tournament_selection(initialpop, 2)
            ch1 = onepoint_crossover(ch1, ch2)
        end

        if rand() < pmutate
            ch1 = random_mutation(ch1)
        end

        newpop.chromosomes[i] = ch1
    end

    return newpop
end

function run_ga(popsize::Int, chsize::Int, costfn::F, ngen::Int, pcross::Float64, pmutate::Float64, nelites::Int) where {F<:Function}

    pop = create_population(popsize, chsize, costfn)

    for _ in 1:ngen
        pop = generation(pop, pcross, pmutate, nelites)
    end

    # calculate costs 
    for i in 1:popsize
        pop.chromosomes[i].cost = pop.costfn(sortperm(pop.chromosomes[i].values))
    end

    sort!(pop.chromosomes, by=ch -> ch.cost)

    return pop
end


end # end of module