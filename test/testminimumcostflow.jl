@testset "Minimum Cost Flow" verbose = true begin
    @testset "Basic Minimum Cost Flow example" begin
        conns = [
            Connection(1, 2, 20),
            Connection(1, 3, 30),
            Connection(2, 4, 10),
            Connection(3, 4, 5),
        ]

        costs = [
            Connection(1, 2, 1),
            Connection(1, 3, 2),
            Connection(2, 4, 3),
            Connection(3, 4, 3),
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
            Connection(3, 2, 25),
        ]

        costs = [
            Connection(1, 2, 1),
            Connection(1, 3, 2),
            Connection(2, 4, 3),
            Connection(3, 4, 3),
            Connection(3, 2, 2),
        ]

        problem = MinimumCostFlowProblem(conns, costs)

        result = solve(problem)

        @test result isa MinimumCostFlowResult
        @test result.cost == 65.0
    end

    @testset "Book example - 1" verbose = true begin

        # Example is given from the url:
        # https://www.ams.jhu.edu/~castello/625.414/Handouts/WV8.5.pdf

        conns = Connection[
            Connection(1, 2, 800),
            Connection(1, 3, 600),
            Connection(2, 5, 100),
            Connection(2, 4, 600),
            Connection(5, 6, 600),
            Connection(4, 5, 600),
            Connection(4, 6, 400),
            Connection(3, 5, 400),
            Connection(3, 4, 300),
        ]

        costs = Connection[
            Connection(1, 2, 10),
            Connection(1, 3, 50),
            Connection(2, 5, 70),
            Connection(2, 4, 30),
            Connection(5, 6, 30),
            Connection(4, 5, 30),
            Connection(4, 6, 60),
            Connection(3, 5, 60),
            Connection(3, 4, 10),
        ]

        definedflow = 900.0

        problem = MinimumCostFlowProblem(conns, costs)

        result = solve(problem, definedflow)

        @test result isa MinimumCostFlowResult
        @test result.cost == 95000.0

    end
end
