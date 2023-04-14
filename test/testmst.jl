@testset "Minimum Spanning Tree" begin 

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
            conn = Connection[Connection(1, 2, 10), Connection(2, 3, 10), Connection(3, 1, 10)]
            @test hasloop(conn) == true
        end 
        @testset "2" begin 
            conn = Connection[Connection(1, 2, 10), Connection(2, 3, 10), Connection(1, 3, 10)]
            @test hasloop(conn) == true
        end
    end

    @testset "Loop with 4 nodes" begin 
        conns = Connection[
            Connection(1, 2, 10),
            Connection(2, 3, 10),
            Connection(3, 4, 10),
            Connection(1, 4, 10)    
        ]
        @test hasloop(conns) == true
    end 

    @testset "Loop with 5 nodes" begin 
        conns = Connection[
            Connection(1, 2, 10),
            Connection(2, 3, 10),
            Connection(3, 4, 10),
            Connection(2, 4, 10)    
        ]
        @test hasloop(conns) == true
    end 

    @testset "Start model" begin
        conns = Connection[
            Connection(1, 2, 5),
            Connection(2, 3, 5),
            Connection(2, 4, 5),
            Connection(2, 5, 5)
        ]
        @test hasloop(conns) == false
    end


end 