@testset "Bin Packing" verbose=true begin 

    @testset "Problem 1 - 2 3 2 3 to 5 5" begin
        problem = BinPackingProblem([2, 3, 2, 3], [5, 5])
        result = solve(problem)
        @test result.used_bins == [1, 2]
        @test result.bin_assignments == [1, 1, 2, 2]
    end 

    @testset "Problem 2 - 1 4 2 to 2 7" begin
        problem = BinPackingProblem([1, 4, 2, 3, 5], [5, 5, 5])
        result = solve(problem)
        @test result.used_bins == [1, 2, 3]
    end 

    @testset "Problem 3 - Unused bins" begin
        problem = BinPackingProblem([1, 2, 3], [5, 5, 5, 5, 5])
        result = solve(problem)
        @test length(result.used_bins) == 2
    end 
end 