@testset "Traveling Salesman with Random Key GA" verbose = true begin 

    @testset "Points in a rectangle" begin 
        
        #
        # * * * * * * 
        # *         *
        # * * * * * *
        pts = Float64[
            0 0;
            0 1;
            0 2;
            1 2;
            2 2;
            3 2;
            4 2; 
            5 2;
            5 1;
            5 0;
            4 0;
            3 0;
            2 0;
            1 0;
        ]

        n = size(pts, 1)

        distmat = zeros(n, n)
        
        # create the distance matrix 
        for i in 1:n
            for j in 1:n
                distmat[i, j] = sqrt(sum((pts[i, :] .- pts[j, :]).^2))
            end 
        end

        bestval = Inf64

        for i in 1:10
            result = travelingsalesman(distmat, ngen = 1000, popsize = 100, pcross = 1.0, pmutate = 0.10)
            if result.cost < bestval
                bestval = result.cost
                bestresult = result
            end
        end 

        @test bestval == 14.0
    end 


end # end of whole @testset