@testset "Assignment Problem" verbose = true begin

    @testset "isbalanced -> true" begin
        mat = [
            4 8 1
            3 1 9
            1 6 7
        ]
        a = AssignmentProblem(mat)
        @test isbalanced(a) == true
    end

    @testset "isbalanced -> false" begin
        mat = [
            4 8 1
            3 1 9
        ]
        a = AssignmentProblem(mat)
        @test isbalanced(a) == false
    end

    @testset "balance (2x3)" begin
        mat = [
            4 8 1
            3 1 9
        ]
        a = AssignmentProblem(mat)
        balanced_a = balance(a)

        @test balanced_a isa AssignmentProblem
        @test size(balanced_a.costs) == (3, 3)
        @test balanced_a.costs == [
            4 8 1
            3 1 9
            0 0 0
        ]
    end

    @testset "balance (2x4)" begin
        mat = [
            4 8 1 2
            3 1 9 5
        ]
        a = AssignmentProblem(mat)
        balanced_a = balance(a)

        @test balanced_a isa AssignmentProblem
        @test size(balanced_a.costs) == (4, 4)
        @test balanced_a.costs == [
            4 8 1 2
            3 1 9 5
            0 0 0 0
            0 0 0 0
        ]
    end

    @testset "balance (3x2)" begin
        mat = [
            4 8
            3 1
            1 6
        ]
        a = AssignmentProblem(mat)
        balanced_a = balance(a)

        @test balanced_a isa AssignmentProblem
        @test size(balanced_a.costs) == (3, 3)
        @test balanced_a.costs == [
            4 8 0
            3 1 0
            1 6 0
        ]
    end

    @testset "balance (4x2)" begin
        mat = [
            4 8
            3 1
            1 6
            2 5
        ]
        a = AssignmentProblem(mat)
        balanced_a = balance(a)

        @test balanced_a isa AssignmentProblem
        @test size(balanced_a.costs) == (4, 4)
        @test balanced_a.costs == [
            4 8 0 0
            3 1 0 0
            1 6 0 0
            2 5 0 0
        ]
    end


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
        for i = 1:n
            mat[i, i] = 1
        end

        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == n

        for i = 1:n
            @test result.solution[i, i] == 1
        end

    end


    @testset "Solve Unbalanced Assignment Problem (2x3)" begin
        mat = [
            4 8 1
            3 1 9
        ]
        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == 2.0
        @test size(result.solution) == (3, 3)
        @test result.solution == [
            0 0 1
            0 1 0
            1 0 0
        ]
    end

    @testset "Solve Unbalanced Assignment Problem (2x4)" begin
        mat = [
            4 8 1 2
            3 1 9 5
        ]
        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == 2.0
        @test size(result.solution) == (4, 4)

        # Problem has alternative solutions.
        @test result.solution[1, 3] == 1
        @test result.solution[2, 2] == 1
    end

    @testset "Solve Unbalanced Assignment Problem (3x2)" begin
        mat = [
            4 8
            3 1
            1 6
        ]
        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == 2.0
        @test size(result.solution) == (3, 3)
        @test result.solution == [
            0 0 1
            0 1 0
            1 0 0
        ]
    end

    @testset "Solve Unbalanced Assignment Problem (4x2)" begin
        mat = [
            4 8
            3 1
            1 6
            2 5
        ]
        a = AssignmentProblem(mat)
        result::AssignmentResult = solve(a)

        @test result.problem isa AssignmentProblem
        @test result.cost == 2.0


        @test size(result.solution) == (4, 4)

        # Problem has alternative solutions.
        @test result.solution[2, 2] == 1
        @test result.solution[3, 1] == 1
    end
end
