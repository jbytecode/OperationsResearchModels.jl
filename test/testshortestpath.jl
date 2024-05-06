@testset "Shortest Path" begin

    @testset "Simple Problem 1" begin

        problem = ShortestPathProblem(
            Connection[
            Connection(1, 2, 3),
            Connection(1, 3, 2),
            Connection(1, 4, 4),
            Connection(2, 5, 3),
            Connection(3, 5, 1),
            Connection(3, 6, 1),
            Connection(4, 6, 2),
            Connection(5, 7, 6),
            Connection(6, 7, 5),
        ])

        # Shortest path: 1 -> 3 -> 6 -> 7
        CorrectShortestPath = [problem.connections[2], problem.connections[6], problem.connections[9]]

        result = solve(problem)

        @test result isa ShortestPathResult
        @test result.cost == 8.0

        for element in result.path
            @test element in CorrectShortestPath
        end
    end
end
