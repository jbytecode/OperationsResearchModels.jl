@testset "Shortest Path" verbose = true begin

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
            ],
        )

        # Shortest path: 1 -> 3 -> 6 -> 7
        CorrectShortestPath =
            [problem.connections[2], problem.connections[6], problem.connections[9]]

        result = solve(problem)

        @test result isa ShortestPathResult
        @test result.cost == 8.0

        for element in result.path
            @test element in CorrectShortestPath
        end
    end


    @testset "Simple Problem 2" begin
        problem = ShortestPathProblem(
            Connection[
                Connection(1, 2, 2),
                Connection(1, 3, 3),
                Connection(1, 4, 4),
                Connection(2, 3, 1),
                Connection(3, 4, 1),
                Connection(2, 5, 4),
                Connection(3, 7, 2),
                Connection(4, 6, 3),
                Connection(6, 7, 1),
                Connection(5, 7, 3),
                Connection(5, 8, 8),
                Connection(6, 9, 7),
                Connection(8, 10, 5),
                Connection(9, 10, 6),
                Connection(7, 10, 10),
            ],
        )

        # Shortest path: 1 -> 3 -> 7 -> 10
        CorrectShortestPath =
            [problem.connections[2], problem.connections[7], problem.connections[15]]

        result = solve(problem)

        @test result isa ShortestPathResult
        @test result.cost == 15.0

        for element in result.path
            @test element in CorrectShortestPath
        end

    end

    @testset "Simple Problem - Two way connections" begin
        problem = ShortestPathProblem(
            Connection[
                Connection(1, 2, 4),    #1
                Connection(1, 3, 15),   #2 

                # Two way connection
                Connection(2, 3, 2),    #3
                Connection(3, 2, 3),    #4
                Connection(2, 4, 15),   #5
                Connection(3, 4, 6),    #6
            ],
        )

        # Shortest path: 1 -> 2 -> 3 -> 4
        CorrectShortestPath =
            [problem.connections[1], problem.connections[3], problem.connections[6]]

        result = solve(problem)

        @test result isa ShortestPathResult
        @test result.cost == 12.0

        for element in result.path
            @test element in CorrectShortestPath
        end

    end
end
