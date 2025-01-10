@testset "Simplex" verbose = true begin

    @testset "Gauss Jordan" verbose=true begin

        @testset "3x3 matrix" begin

            m = Float64[1.0 2 7; -1 6 5; 9 8 -3]

            expected = [
                0.142157 -0.151961 0.0784314;
                -0.102941 0.161765 0.0294118;
                0.151961 -0.0245098 -0.0196078
            ]

            result = gaussjordan(m, verbose=false)

            @test isapprox(result, expected, atol=0.0001)

        end

        @testset "4x4 matrix" begin 
            
            m = Float64[1 6 7 4; 5 4 3 2; 3 4 5 1; 5 5 7 5]

            expected = [
                -0.196429    0.0892857   0.0714286   0.107143;
                0.309524    0.404762   -0.142857   -0.380952;
               -0.14881    -0.386905    0.357143    0.202381;
                0.0952381   0.047619   -0.428571    0.190476              
            ]

            result = gaussjordan(m, verbose=false)

            @test isapprox(result, expected, atol=0.0001)
        end
    end



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
        @test isapprox(s.rhs[1], 16.666666666666664, atol=eps)
        @test isapprox(s.rhs[2], 66.66666666666667, atol=eps)

        @test isapprox(s.objective_value, 183.33333, atol=eps)

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
        @test isapprox(s.rhs[1], 0.3333333333, atol=eps)
        @test isapprox(s.rhs[2], 1.3333333333, atol=eps)

        @test isapprox(s.objective_value, 183.33333, atol=eps)
    end

    @testset "Maximization problem with single equality constraint" begin

        # Maximize 3x + 5y
        # subject to x + y = 10
        # x, y >= 0
        # Result:
        # x = 0.0
        # y = 5.0
        # Objective value = 50.0

        obj = [3.0, 5.0]
        amat = [1.0 1.0]
        rhs = [10.0]
        dirs = [EQ]
        opt = Maximize

        s = SimplexProblem()
        setobjectivecoefs(s, obj)
        setlhs(s, amat)
        setrhs(s, rhs)
        setdirections(s, dirs)
        setopttype(s, opt)
        setautomaticvarnames(s)

        solve!(s)

        @test s.converged
        @test isapprox(s.rhs[1], 10.0)
        @test isapprox(s.objective_value, 50.0)

    end



    @testset "Mini Transportation Problem" begin

        eps = 0.001
        # Mini Transportation Problem
        #           M1       M2      M3     Supply 
        # F1        10       15      20      200
        # F2        17       13       9      100
        # Demand    110      80      110      -
        obj = Float64[10, 15, 20, 17, 13, 9]
        amat = Float64[
            1 1 1 0 0 0;
            0 0 0 1 1 1;
            1 0 0 1 0 0;
            0 1 0 0 1 0;
            0 0 1 0 0 1
        ]
        rhs = Float64[200, 100, 110, 80, 110]
        dirs = [EQ, EQ, EQ, EQ, EQ]
        opt = Minimize

        problem::SimplexProblem = createsimplexproblem(obj, amat, rhs, dirs, opt)

        iters = simplexiterations(problem)

        lastiter = iters[end]

        @test lastiter.converged
        @test isapprox(lastiter.objective_value, 3400.0, atol=eps)
        @test sort(lastiter.basicvariableindex) == [1, 2, 3, 6, 11]
        @test sort(lastiter.artificialvariableindices) == [7, 8, 9, 10, 11]
        @test isapprox(lastiter.rhs, [10.0, 100.0, 110.0, 80.0, 0.0], atol=eps)
    end



end # end of test set Simplex
