@testset "Pert" begin
    @testset "Basic Pert" begin
        A = PertActivity("A", 1, 2, 3)
        B = PertActivity("B", 3, 3, 3)
        C = PertActivity("C", 5, 5, 5, [A, B])

        activities = [A, B, C]

        result::PertResult = pert(activities)

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

        result::PertResult = pert(activities)

        @test result.mean == 10.0
        @test isapprox(result.stddev, 0.4714045207910317, atol = epsilon )
        @test result.path == PertActivity[B, C]
    end 
end