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
        y = result.y

        @test sort(result.centers) == [2, 6]

        @test iszero(y[1])
        @test isone(y[2])
        @test iszero(y[3])
        @test iszero(y[4])
        @test iszero(y[5])
        @test isone(y[6])
    end

    @testset "p-median with distances" begin 
        distance_matrix = Float64[0 6 3 2; 6 0 4 7; 3 4 0 10; 2 7 10 0]

        number_of_depots = 2

        result = pmedian_with_distances(distance_matrix, number_of_depots)

        @test sort(result.centers) == [1, 2]
        @test result.objective == 5.0
        @test result.z ≈ [1 0 0 0; 0 1 0 0; 1 0 0 0; 1 0 0 0]
    end 
end
