@testset "Maximum Flow" verbose = true begin
    @testset "Basic Maximum Flow example" begin
        # x12 = 20
        # x13 = 30
        # x14 = 10
        # x25 = 20
        # x34 = 10
        # x35 = 20
        # x43 = 0
        # x45 = 20
        #  f = 60
        maxflowresult = [
            Connection(1, 2, 20.0),
            Connection(1, 3, 30.0),
            Connection(1, 4, 10.0),
            Connection(2, 5, 20.0),
            Connection(3, 4, 10.0),
            Connection(3, 5, 20.0),
            Connection(4, 5, 20.0),
        ]


        conns = [
            Connection(1, 4, 10),
            Connection(1, 2, 20),
            Connection(1, 3, 30),
            Connection(2, 3, 30),
            Connection(4, 5, 20),
            Connection(3, 5, 20),
            Connection(2, 5, 30),
            Connection(3, 4, 10),
            Connection(4, 3, 5),
        ]


        problem = MaximumFlowProblem(conns)

        result = solve(problem)

        @test result isa MaximumFlowResult

        @test result.flow == 60.0

        for element in result.path
            @test element in maxflowresult
        end
    end
end
