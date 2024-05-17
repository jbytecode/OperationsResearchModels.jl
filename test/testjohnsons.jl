@testset "Johnson's algorithm" verbose = true begin

    @testset "Two machines" verbose = true begin

        @testset "Example 1 with 2-machines" begin
            times = Float64[
                3.2 4.2;
                4.7 1.5;
                2.2 5.0;
                5.8 4.0;
                3.1 2.8
            ]

            result = johnsons(times)

            @test result.permutation == [3, 1, 4, 5, 2]
        end


        @testset "Example 2 with 2-machines" begin 
            times = Float64[
                4 7;
                8 3;
                5 8;
                6 4;
                8 5;
                7 4
            ]

            result = johnsons(times)

            @test result.permutation == [1, 3, 5, 6, 4, 2]
        end 
    end


    @testset "Three machines" verbose = true begin 

        @testset "Example 1 for 3-machines" begin 

            times = Float64[
                3 3 5;
                8 4 8;
                7 2 10;
                5 1 7;
                2 5 6    
            ]

            result = johnsons(times)

            @test result.permutation == [1, 4, 5, 3, 2]
        end 
    end 


    @testset "Five machines" verbose = true begin 

        @testset "Example 1 for 5-machines" begin 

            times = Float64[
                7 5 2 3 9;
                6 6 4 5 10;
                5 4 5 6 8;
                8 3 3 2 6   
            ]

            result = johnsons(times)

            @test result.permutation == [1, 3, 2, 4]
        end 
    end


    @testset "Cannot reduce to 2-machines" begin 

            times = Float64[
                3 3 5 2;
                8 4 8 3;
                7 2 10 4;
                5 1 7 5;
                2 5 6 6
            ]

            @test_throws JohnsonException johnsons(times)

    end


end