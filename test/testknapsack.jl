@testset "Knapsack" verbose = true begin

    @testset "Problem 1" begin
        values = [1, 2, 3, 4, 5]
        weights = [1, 2, 3, 4, 5]
        capacity = 10

        problem = KnapsackProblem(values, weights, capacity)

        result = solve(problem)

        @test result.objective == 10.0
        @test result.selected == [1, 0, 0, 1, 1]
    end


    @testset "Problem 2" begin
        values = [1, 2, 3, 4, 5]
        weights = [1, 2, 3, 4, 5]
        capacity = 5


        problem = KnapsackProblem(values, weights, capacity)

        result = solve(problem)

        @test result.objective == 5.0
        @test result.selected == [0, 0, 0, 0, 1]
    end
end
