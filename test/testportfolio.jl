@testset "Portfolio Optimization" begin
    @testset "Markowitz Portfolio Optimization - Example 1" begin
        eps = 1e-5
        mydata = rand(100, 3)
        mydata[:, 3] = mydata[:, 1] * 0.6 + mydata[:, 2] * 0.3 + randn(100) * 0.1 
        thresholdreturn = 0.1

        problem = PortfolioProblem(mydata, thresholdreturn)
        
        result = solve(problem)

        @test result.expectedreturn >= thresholdreturn
        @test isapprox(sum(result.weights), 1.0; atol=eps)
        @test all(result.weights .>= 0.0)
        @test all(result.weights .<= 1.0)
        # @info "Optimal weights: $(result.weights)"
        # @info "Expected return: $(result.expectedreturn)"
        # println(result.model)

    end
end