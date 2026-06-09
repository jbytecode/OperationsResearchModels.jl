@testset "Game Test" verbose = true begin
    @testset "Two-players zero-sum game example" begin
        tol = 0.00001

        mat = [
            -2 6 3
            3 -4 7
            -1 2 4
        ]

        problem = GameProblem(mat)

        result = solve(problem)

        @test isa(result, Vector{GameResult})
        @test length(result) == 2

        @test isapprox(result[1].value, 0.6666666666666661, atol = tol)

        @test isapprox(
            result[1].probabilities,
            [0.4666667, 0.5333333, 0.0000000],
            atol = tol,
        )

        @test result[1].strategytype == Mixed
    end

    @testset "Game - Rock & Paper & Scissors" begin

        tol = 0.00001

        mat = [
            0 -1 1
            1 0 -1
            -1 1 0
        ]

        problem = GameProblem(mat)

        result = solve(problem)

        @test isa(result, Vector{GameResult})
        @test length(result) == 2

        @test result[1].value == 0.0

        @test isapprox(result[1].probabilities, [0.333333, 0.333333, 0.33333], atol = tol)

        @test result[2].value == 0.0

        @test isapprox(result[2].probabilities, [0.333333, 0.333333, 0.33333], atol = tol)

        @test result[1].alpha == -1.0

        @test result[1].beta == 1.0

    end

    @testset "Simple Game" begin

        mat = [
            3 7
            5 4
        ]

        problem = GameProblem(mat)

        result = solve(problem)

        @test isa(result, Vector{GameResult})

        @test length(result) == 2

        @test result[1].value == 4.6

        @test result[2].value == -4.6

        @test isapprox(result[1].probabilities, [0.2, 0.8], atol = 0.00001)

        @test isapprox(result[2].probabilities, [0.6, 0.4], atol = 0.00001)
    end


    @testset "Pure Strategy Game" begin

        mat = [
            2 5
            1 1
        ]

        problem = GameProblem(mat)

        result = solve(problem)

        @test isa(result, Vector{GameResult})

        @test length(result) == 2

        @test result[1].value == 2.0

        # Best option is R1 - C1 
        
        @test isapprox(result[1].probabilities, [1.0, 0.0], atol = 0.00001)

        @test isapprox(result[2].probabilities, [1.0, 0.0], atol = 0.00001)

        @test result[1].strategytype == Pure

        @test result[1].alpha == 2.0

        @test result[1].beta == 2.0

    end
end
