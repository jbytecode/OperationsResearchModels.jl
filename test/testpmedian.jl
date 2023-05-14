@testset "p-median" begin

    @testset "2-d example" begin
        coords = Float64[
            1 5
            2 4
            4 3
            2 1
            7 8
            8 7
        ]

        result = pmedian(coords, 2)
        y = result["y"]

        @test sort(result["centers"]) == [2, 6]
        
        @test iszero(y[1])
        @test isone(y[2])
        @test iszero(y[3])
        @test iszero(y[4])
        @test iszero(y[5])
        @test isone(y[6])
    end
end