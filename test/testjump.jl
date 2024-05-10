@testset "JuMP and HiGHS" begin 

    eps = 0.001

    import OperationsResearchModels: JuMP, HiGHS
    import .JuMP: MOI

    m = JuMP.Model(OperationsResearchModels.HiGHS.Optimizer)
    MOI.set(m, MOI.Silent(), true)

    JuMP.@variable(m, x >= 0)
    JuMP.@variable(m, y >= 0)

    JuMP.@objective(m, Max, x + 2y)

    JuMP.@constraint(m, x + y <= 1)

    JuMP.optimize!(m)

    @test isapprox(JuMP.value(x), 0.0, atol = eps)
    @test isapprox(JuMP.value(y), 1.0, atol = eps)

    @test isapprox(JuMP.objective_value(m), 2.0, atol = eps)
end 