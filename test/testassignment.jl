@testset "Assignment Problem" verbose = true begin

    @testset "Simple Assigment Problem" begin
        mat = [
            4 8 1
            3 1 9
            1 6 7
        ]
        # x13 = 1
        # x22 = 1
        # x31 = 1
        # cost = 3 

        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == 3.0
        @test result.solution == [
            0 0 1
            0 1 0
            1 0 0
        ]
    end
end
