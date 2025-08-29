using OperationsResearchModels.Utility

@testset "Utility" verbose = true begin

    @testset "numround" begin
        @test numround(123.123456789) == 123.123
        @test numround(0.1111111) == 0.111
        @test numround(0.1) == 0.1
        @test numround(123.123456789) == round(123.123456789, digits = 3)
    end
end
