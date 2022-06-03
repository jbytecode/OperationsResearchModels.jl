@testset "Transportation" begin 

    @testset "Balance Check - Demand > Supply" begin
        t = TransportationProblem(
            [   1 1 1 1; 
                2 2 2 2; 
                3 3 3 3], 
            [100, 100, 100, 100], # Demands 
            [100, 100, 100])      # Supplies 

        balancedT = t |> balance 
        @test isbalanced(t) == false
        @test sum(t.supply) != sum(t.demand)

        @test isbalanced(balancedT) == true
        @test sum(balancedT.supply) == sum(balancedT.demand)  
        @test balancedT.costs[4,:] == zeros(eltype(balancedT.costs), length(balancedT.demand))
        @test balancedT.supply |> last == 100
    end 

    @testset "Balance Check - Supply > Demand" begin
        t = TransportationProblem(
            [   1 1 1 1; 
                2 2 2 2; 
                3 3 3 3], 
            [100, 100, 100, 100], # Demands 
            [200, 200, 200])      # Supplies 

        balancedT = t |> balance 
        @test isbalanced(t) == false
        @test sum(t.supply) != sum(t.demand)

        @test isbalanced(balancedT) == true
        @test sum(balancedT.supply) == sum(balancedT.demand)  
        @test balancedT.costs[:, 5] == zeros(eltype(balancedT.costs), length(balancedT.supply))
        @test balancedT.demand |> last == 200
    end

end 