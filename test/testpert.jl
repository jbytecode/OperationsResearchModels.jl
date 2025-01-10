@testset "Pert" verbose = true begin
    @testset "Basic Pert" begin
        A = PertActivity("A", 1, 2, 3)
        B = PertActivity("B", 3, 3, 3)
        C = PertActivity("C", 5, 5, 5, [A, B])

        activities = [A, B, C]

        problem = PertProblem(activities)

        result::PertResult = solve(problem)

        @test result.mean == 8.0
        @test result.stddev == 0.0
        @test result.path == PertActivity[B, C]
    end

    @testset "Basic Pert 2" begin

        epsilon = 0.0001

        A = PertActivity("A", 1, 2, 3)
        B = PertActivity("B", 3, 4, 5)
        C = PertActivity("C", 5, 6, 7, [A, B])

        activities = [A, B, C]

        problem = PertProblem(activities)

        result::PertResult = solve(problem)

        @test result.mean == 10.0
        @test isapprox(result.stddev, 0.4714045207910317, atol = epsilon)
        @test result.path == PertActivity[B, C]
    end

    @testset "Comprehensive example" begin

        epsilon = 0.0001

        A = PertActivity("A", 3, 7, 9)
        B = PertActivity("B", 2, 2, 2)
        C = PertActivity("C", 3, 4, 5)
        D = PertActivity("D", 3, 4, 4, [A, B])
        E = PertActivity("E", 4, 4, 5, [B, C])
        F = PertActivity("F", 1, 3, 4, [A, B, E])
        G = PertActivity("G", 2, 3, 3, [D, E])
        H = PertActivity("H", 3, 3, 3, [E, F])
        I = PertActivity("I", 3, 4, 5, [G, H])
        J = PertActivity("J", 4, 5, 6, [G, H])
        K = PertActivity("K", 1, 4, 4, [H, I, J])
        L = PertActivity("L", 3, 4, 5, [G, H, I])

        activities = [A, B, C, D, E, F, G, H, I, J, K, L]


        problem = PertProblem(activities)   

        result = solve(problem)

        @test result isa PertResult
        @test result.mean == 22.5
        @test isapprox(result.stddev, 0.8660254, atol = epsilon)

        @test !(A in result.path)
        @test !(B in result.path)
        @test C in result.path
        @test !(D in result.path)
        @test E in result.path
        @test F in result.path
        @test !(G in result.path)
        @test H in result.path
        @test !(I in result.path)
        @test J in result.path
        @test K in result.path
        @test !(L in result.path)
    end
end
