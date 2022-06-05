@testset "Shortest Path" begin

    @testset "Simple Problem 1" begin

        conns = [
            Connection(1, 2, 3),
            Connection(1, 3, 2),
            Connection(1, 4, 4),
            Connection(2, 5, 3),
            Connection(3, 5, 1),
            Connection(3, 6, 1),
            Connection(4, 6, 2),
            Connection(5, 7, 6),
            Connection(6, 7, 5),
        ]
        # Shortest path: 1 -> 3 -> 6 -> 7
        CorrectShortestPath = [conns[2], conns[6], conns[9]]

        result = solve(conns)

        @test result isa ShortestPathResult
        @test result.cost == 8.0
        
        @test Connection(1, 3, 2) in CorrectShortestPath 
        @test Connection(3, 6, 1) in CorrectShortestPath 
        @test Connection(6, 7, 5) in CorrectShortestPath 
    end
end
