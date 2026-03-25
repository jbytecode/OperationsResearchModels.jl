@testset "Project Selection" verbose = true begin

    @testset "Problem 1" begin
        costmatrix = [
            3 5 6;
            2 4 5;
            5 4 2;
            2 1 5;
            8 9 6;
        ]

        returns = [10, 12, 15, 8, 200]

        budgets = [8, 9, 6]

        problem = ProjectSelectionProblem(costmatrix, budgets, returns)

        result = solve(problem)

        @test result.objective == 200.0

        @test result.selected == [0, 0, 0, 0, 1]
    end

    end