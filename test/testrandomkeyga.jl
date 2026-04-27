@testset "Random Key Genetic Algorithm" verbose = true begin

    @testset "Uniform Biased Crossover" begin
        elite = Chromosome([0.1, 0.2, 0.3, 0.4, 0.5])
        other = Chromosome([0.5, 0.4, 0.3, 0.2, 0.1])
        alpha = 0.7

        offspring = OperationsResearchModels.RandomKeyGA.uniform_crossover(elite, other; alpha)

        @test length(offspring.values) == length(elite.values)
        for i in 1:length(elite.values)
            @test offspring.values[i] == elite.values[i] || offspring.values[i] == other.values[i]
        end
    end

    @testset "Create Mutant" begin
        len = 5
        mutant = OperationsResearchModels.RandomKeyGA.create_mutant(len)

        @test length(mutant.values) == len
        for val in mutant.values
            @test 0.0 <= val <= 1.0
        end
    end

    @testset "Example with chsize = 5" begin

        # Correct order is 1 2 3 4 5
        function costfn(permutation::Vector{Int})::Float64
            sum = 0.0
            for i = 1:5
                sum += abs(permutation[i] - i)
            end
            return sum
        end

        popsize = 100
        chsize = 5
        maxiter = 5000
        crossoverprob = 0.8
        mutationprob = 0.1
        elitism = 1

        # Random key genetic algorithm
        # popsize::Int, chsize::Int, costfn::F, ngen::Int, pcross::Float64, pmutate::Float64, nelites::Int
        result =
            run_ga(popsize, chsize, costfn, maxiter, crossoverprob, mutationprob, elitism)

        @test sortperm(result.chromosomes[1].values) == [1, 2, 3, 4, 5]
        @test costfn(sortperm(result.chromosomes[1].values)) == 0.0

    end


    @testset "Example with chsize = 10" begin

        # Correct order is 1 2 3 4 5 6 7 8 9 10
        function costfn(permutation::Vector{Int})::Float64
            sum = 0.0
            for i = 1:10
                sum += abs(permutation[i] - i)
            end
            return sum
        end

        popsize = 100
        chsize = 10
        maxiter = 5000
        crossoverprob = 0.8
        mutationprob = 0.1
        elitism = 1

        # Random key genetic algorithm
        # popsize::Int, chsize::Int, costfn::F, ngen::Int, pcross::Float64, pmutate::Float64, nelites::Int
        result =
            run_ga(popsize, chsize, costfn, maxiter, crossoverprob, mutationprob, elitism)

        @test sortperm(result.chromosomes[1].values) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        @test costfn(sortperm(result.chromosomes[1].values)) == 0.0

    end
end
