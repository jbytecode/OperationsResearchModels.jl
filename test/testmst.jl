@testset "Minimum Spanning Tree" verbose = true begin

    @testset "hasloop()" begin
        @testset "Empty network" begin
            conn = Connection[]
            @test hasloop(conn) == false
        end

        @testset "Single node network" begin
            conn = Connection[Connection(1, 2, 10)]
            @test hasloop(conn) == false
        end

        @testset "Triangular node with 3 nodes" begin
            @testset "1" begin
                conn = Connection[
                    Connection(1, 2, 10),
                    Connection(2, 3, 10),
                    Connection(3, 1, 10),
                ]
                @test hasloop(conn) == true
            end
            @testset "2" begin
                conn = Connection[
                    Connection(1, 2, 10),
                    Connection(2, 3, 10),
                    Connection(1, 3, 10),
                ]
                @test hasloop(conn) == true
            end
        end

        @testset "Loop with 4 nodes" begin
            conns = Connection[
                Connection(1, 2, 10),
                Connection(2, 3, 10),
                Connection(3, 4, 10),
                Connection(1, 4, 10),
            ]
            @test hasloop(conns) == true
        end

        @testset "Loop with 5 nodes" begin
            conns = Connection[
                Connection(1, 2, 10),
                Connection(2, 3, 10),
                Connection(3, 4, 10),
                Connection(2, 4, 10),
            ]
            @test hasloop(conns) == true
        end

        @testset "Stars" begin
            @testset "Star model" begin
                conns = Connection[
                    Connection(1, 2, 5),
                    Connection(2, 3, 5),
                    Connection(2, 4, 5),
                    Connection(2, 5, 5),
                ]
                @test hasloop(conns) == false
            end

            @testset "Two Connected Stars" begin
                conns = Connection[
                    Connection(1, 2, 5),
                    Connection(2, 3, 5),
                    Connection(2, 4, 5),
                    Connection(2, 5, 5),
                    Connection(5, 6, 5),
                    Connection(5, 7, 5),
                    Connection(5, 8, 5),
                ]
                @test hasloop(conns) == false
            end
        end
    end


    @testset "solve mst problem" begin
        conns = Connection[
            Connection(1, 2, 10),
            Connection(2, 3, 10),
            Connection(3, 4, 10),
            Connection(1, 4, 10),
        ]
        result = solve(MstProblem(conns))
        @test result isa MstResult
        @test result.distance == 30.0
        @test !hasloop(result.connections)
        @test length(result.connections) == length(nodes(conns)) - 1
    end

    @testset "6 nodes with loops" begin
        conns = Connection[
            Connection(1, 2, 5),
            Connection(1, 3, 4),
            Connection(2, 3, 5),
            Connection(2, 4, 7),
            Connection(2, 5, 9),
            Connection(3, 4, 8),
            Connection(3, 5, 6),
            Connection(4, 5, 6),
            Connection(3, 6, 10),
            Connection(5, 6, 11),
        ]
        result = solve(MstProblem(conns))
        @test result.distance == 31.0
        @test length(result.connections) == 5

        allnodes = nodes(result.connections)
        for i = 1:6
            @test i in allnodes
        end

        @test !hasloop(result.connections)
        @test length(result.connections) == length(allnodes) - 1
    end

    @testset "7 nodes with loops" begin
        conns = Connection[
            Connection(1, 2, 9),
            Connection(1, 3, 2),
            Connection(1, 4, 1),
            Connection(1, 5, 7),
            Connection(1, 6, 6),
            Connection(1, 7, 10),
            Connection(2, 3, 11),
            Connection(2, 4, 8),
            Connection(2, 5, 13),
            Connection(2, 6, 14),
            Connection(2, 7, 9),
            Connection(3, 4, 7),
            Connection(3, 5, 6),
            Connection(3, 6, 11),
            Connection(3, 7, 20),
            Connection(4, 5, 14),
            Connection(5, 6, 18),
            Connection(5, 7, 19),
            Connection(6, 7, 15),
        ]

        result = solve(MstProblem(conns))

        @test result.distance == 32.0

        allnodes = nodes(result.connections)

        for i = 1:7
            @test i in allnodes
        end

        @test !hasloop(result.connections)
        @test length(result.connections) == length(allnodes) - 1
    end

    @testset "big network" begin
        connections = Connection[]
        N = 300
        for i = 1:N
            for j = (i+1):N
                push!(connections, Connection(i, j, rand()))
            end
        end
        result = solve(MstProblem(connections))

        allnodes = nodes(result.connections)

        for i = 1:N
            @test i in allnodes
        end

        @test !hasloop(result.connections)
        @test length(result.connections) == length(allnodes) - 1
    end
end
