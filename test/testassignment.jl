@testset "Assignment Problem" verbose = true begin

    @testset "Simple Assignment Problem" begin
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


    @testset "Relatively big Assignment Problem (100x100)" begin

        n = 100

        mat = rand(10:1000, n, n)

        # Ensure that the ith row has a 1 in the ith column
        for i in 1:n
            mat[i, i] = 1
        end

        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == n
        
        for i in 1:n
            @test result.solution[i, i] == 1
        end 

    end
end
