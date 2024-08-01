@testset "Random Key Genetic Algorithm" verbose = true begin

    @testset "Example with chsize = 5" begin

        # Correct order is 1 2 3 4 5
        function costfn(permutation::Vector{Int})::Float64
            sum = 0.0
            for i in 1:5
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
        result = run_ga(popsize, chsize, costfn, maxiter, crossoverprob, mutationprob, elitism)

        @test sortperm(result.chromosomes[1].values) == [1, 2, 3, 4, 5]
        @test costfn(sortperm(result.chromosomes[1].values)) == 0.0

    end


    @testset "Example with chsize = 10" begin

        # Correct order is 1 2 3 4 5 6 7 8 9 10
        function costfn(permutation::Vector{Int})::Float64
            sum = 0.0
            for i in 1:10
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
        result = run_ga(popsize, chsize, costfn, maxiter, crossoverprob, mutationprob, elitism)

        @test sortperm(result.chromosomes[1].values) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        @test costfn(sortperm(result.chromosomes[1].values)) == 0.0

    end
end