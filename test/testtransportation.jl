@testset "Transportation" verbose = true begin

    @testset "Balance Check - Demand > Supply" begin
        t = TransportationProblem(
            [
                1 1 1 1
                2 2 2 2
                3 3 3 3
            ],
            [100, 100, 100, 100], # Demands 
            [100, 100, 100],
        )      # Supplies 

        balancedT = t |> balance
        @test isbalanced(t) == false
        @test sum(t.supply) != sum(t.demand)

        @test isbalanced(balancedT) == true
        @test sum(balancedT.supply) == sum(balancedT.demand)
        @test balancedT.costs[4, :] ==
              zeros(eltype(balancedT.costs), length(balancedT.demand))
        @test balancedT.supply |> last == 100
    end

    @testset "Balance Check - Supply > Demand" begin
        t = TransportationProblem(
            [
                1 1 1 1
                2 2 2 2
                3 3 3 3
            ],
            [100, 100, 100, 100], # Demands 
            [200, 200, 200],
        )      # Supplies 

        balancedT = t |> balance
        @test isbalanced(t) == false
        @test sum(t.supply) != sum(t.demand)

        @test isbalanced(balancedT) == true
        @test sum(balancedT.supply) == sum(balancedT.demand)
        @test balancedT.costs[:, 5] ==
              zeros(eltype(balancedT.costs), length(balancedT.supply))
        @test balancedT.demand |> last == 200
    end

    @testset "Solution - 1" begin
        #=
        |        |  D1       |  D2      |  D3      |  D4       |  Supply  |
        |  S1    |  1        |  5 (100) |  7       |  8        |  100     |
        |  S2    |  2        |  6       |  4 (100) |  9        |  100     |
        |  S3    |  3 (100)  |  10      |  11      |  12 (100) |  200     |
        | Demand | 100       | 100      | 100      | 100       |          |

        cost = 5 * 100 + 4 * 100 + 3 * 100 + 12 * 100 
             = 500 + 400 + 300 + 1200 
             = 2400
        =#
        t = TransportationProblem(
            [
                1 5 7 8
                2 6 4 9
                3 10 11 12
            ],
            [100, 100, 100, 100],
            [100, 100, 200],
        )

        result = solve(t)

        @test result isa TransportationResult
        @test result.cost == 2400
        @test result.solution == [
            0 100 0 0
            0 0 100 0
            100 0 0 100
        ]
    end

    @testset "Solution - 2" begin
        t = TransportationProblem(
            Float64[10 20 25; 12 15 7],
            Float64[190, 40, 20],
            Float64[150, 100])

        result = solve(t)

        @test result.cost == 2720.0
        @test result.solution == [150.0 0.0 0.0; 40.0 40.0 20.0]
    end

    @testset "North-West Corner" begin
        @testset "Example 1" begin
            t = TransportationProblem(
                [
                    1 5 7 8
                    2 6 4 9
                    3 10 11 12
                ],
                [4, 6, 10, 15],
                [9, 11, 15],
            )

            result = northwestcorner(t)
            expected = Float64[
                4 5 0 0
                0 1 10 0
                0 0 0 15
            ]
            @test result.solution == expected
            @test result.cost == 255
        end

        @testset "Example 2" begin
            t = TransportationProblem(
                [
                    10 9 15
                    7 19 9
                    11 21 11
                    15 8 10
                ],
                [100, 100, 50],     # Demand
                [100, 50, 60, 40],
            )  # Supply

            result = northwestcorner(t)
            expected = Float64[
                100 0 0
                0 50 0
                0 50 10
                0 0 40
            ]
            @test result.solution == expected
            @test result.cost == 3510
        end
    end




    @testset "Least Cost Method" begin
        @testset "Example 1" begin
            t = TransportationProblem(
                Float64[1 2 8 10; 7 3 4 5; 12 11 9 6],
                Float64[50, 60, 30, 130],
                Float64[90, 110, 70]
            )
            result = leastcost(t)
            expected = Float64[
                50 40 0 0;
                0 20 30 60;
                0 0 0 70
            ]
            @test result.solution == expected
            @test result.cost == 1030
        end

        @testset "Example 2" begin
            t = TransportationProblem(
                Float64[10 2 20 11; 12 7 9 20; 4 14 16 18],
                Float64[5, 15, 15, 15],
                Float64[15, 25, 10]
            )
            
            result = leastcost(t)
            
            expected = Float64[0 15 0 0; 0 0 15 10; 5 0 0 5]
            
            @test result.solution == expected
            
            @test result.cost == 475
        end
    end




    @testset "Big Example with Nortwest-corner initial solution - Check if it is solved in reasonable times" verbose = true begin

        t = TransportationProblem(
            rand(10:1000, 350, 450) * 1.0,
            rand(1:100, 450) * 1.0,
            rand(1:100, 350) * 1.0,
        )


        result = solve(t, initial = northwestcorner)

        @test result.cost > 0

    end

    @testset "Big Example with least cost initial solution - Check if it is solved in reasonable times" verbose = true begin

        t = TransportationProblem(
            rand(10:1000, 350, 450) * 1.0,
            rand(1:100, 450) * 1.0,
            rand(1:100, 350) * 1.0,
        )


        result = solve(t, initial = leastcost)

        @test result.cost > 0

    end
end
