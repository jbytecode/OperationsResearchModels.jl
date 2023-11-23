using OperationsResearchModels.Simplex

@testset "Simplex" begin
	@testset "Maximization Problem" begin

		eps = 0.0001

		s = SimplexProblem()
		setobjectivecoefs(s, [2, 3])
		setlhs(s, [1 2; 2 1])
		setrhs(s, [100.0, 150.0])
		setdirections(s, [LE, LE])
		setopttype(s, Maximize)
		setautomaticvarnames(s)
		solve!(s)

		@test s.converged
		@test isapprox(s.rhs[1], 16.666666666666664, atol = eps)
		@test isapprox(s.rhs[2], 66.66666666666667, atol = eps)

		@test isapprox(s.objective_value, 183.33333, atol = eps)

	end



	@testset "Minimization Problem" begin

		eps = 0.0001

		s = SimplexProblem()
		setobjectivecoefs(s, [100, 150])
		setlhs(s, Float64[1 2; 2 1])
		setrhs(s, Float64[2, 3])
		setopttype(s, Minimize)
		setdirections(s, [GE, GE])
		setautomaticvarnames(s)

		solve!(s)

		@test s.converged
		@test isapprox(s.rhs[1], 0.3333333333, atol = eps)
		@test isapprox(s.rhs[2], 1.3333333333, atol = eps)

		@test isapprox(s.objective_value, 183.33333, atol = eps)

	end


	

end # end of test set Simplex
