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

    @testset "p-median with distances 2" begin
        distance_matrix = Float64[
            0 8 7 9 3;
            8 0 2 6 1;
            7 2 0 4 5;
            9 6 4 0 10;
            3 1 5 10 0
        ]

        number_of_depots = 3

        result = pmedian_with_distances(distance_matrix, number_of_depots)

        @test sort(result.centers) == [1, 2, 4]
        @test result.objective == 3.0
        @test result.z ≈ [
            1 0 0 0 0;
            0 1 0 0 0;
            0 1 0 0 0;
            0 0 0 1 0;
            0 1 0 0 0
        ]
    end

    @testset "p-median with multiple number of centers" begin
        distance_matrix = Float64[
            0 10 6 15 8;
            10 0 7 8 12;
            6 7 0 11 9;
            15 8 11 0 16;
            8 12 9 16 0
        ]


        result1 = pmedian_with_distances(distance_matrix, 2)
        result2 = pmedian_with_distances(distance_matrix, 3)
        result3 = pmedian_with_distances(distance_matrix, 4)

        @test sort(result1.centers) == [3, 4]
        @test result1.objective == 22.0

        @test sort(result2.centers) == [3, 4, 5]
        @test result2.objective == 13.0

        @test sort(result3.centers) == [2, 3, 4, 5]
        @test result3.objective == 6.0
    end
end
