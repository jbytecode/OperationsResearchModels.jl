@testset "Minimum Cost Flow" verbose = true begin
    @testset "Basic Minimum Cost Flow example" begin
        conns = [
            Connection(1, 2, 20),
            Connection(1, 3, 30),
            Connection(2, 4, 10),
            Connection(3, 4, 5)
        ]

        costs = [
            Connection(1, 2, 1),
            Connection(1, 3, 2),
            Connection(2, 4, 3),
            Connection(3, 4, 3)
        ]

        problem = MinimumCostFlowProblem(conns, costs)

        result = solve(problem)

        @test result isa MinimumCostFlowResult
        @test result.cost == 65.0
    end

    @testset "Basic Minimum Cost Flow example -2" begin
        conns = [
            Connection(1, 2, 20),
            Connection(1, 3, 30),
            Connection(2, 4, 10),
            Connection(3, 4, 5),
            Connection(3, 2, 25)
        ]

        costs = [
            Connection(1, 2, 1),
            Connection(1, 3, 2),
            Connection(2, 4, 3),
            Connection(3, 4, 3),
            Connection(3, 2, 2)
        ]

        problem = MinimumCostFlowProblem(conns, costs)

        result = solve(problem)

        @test result isa MinimumCostFlowResult
        @test result.cost == 95.0

    end
end