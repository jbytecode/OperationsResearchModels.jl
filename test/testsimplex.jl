@testset "Simplex" verbose = true begin

    @testset "Gauss Jordan" verbose = true begin

        @testset "3x3 matrix" begin

            m = Float64[1.0 2 7; -1 6 5; 9 8 -3]

            expected = [
                0.142157 -0.151961 0.0784314
                -0.102941 0.161765 0.0294118
                0.151961 -0.0245098 -0.0196078
            ]

            result = gaussjordan(m, verbose = false)

            @test isapprox(result, expected, atol = 0.0001)

        end

        @testset "4x4 matrix" begin

            m = Float64[1 6 7 4; 5 4 3 2; 3 4 5 1; 5 5 7 5]

            expected = [
                -0.196429 0.0892857 0.0714286 0.107143
                0.309524 0.404762 -0.142857 -0.380952
                -0.14881 -0.386905 0.357143 0.202381
                0.0952381 0.047619 -0.428571 0.190476
            ]

            result = gaussjordan(m, verbose = false)

            @test isapprox(result, expected, atol = 0.0001)
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
        @test isapprox(s.rhs[1], 16.666666666666664, atol = eps)
        @test isapprox(s.rhs[2], 66.66666666666667, atol = eps)

        @test isapprox(s.objective_value, 183.33333, atol = eps)

    end

    @testset "Capacity planning example" begin 

        eps = 0.00001
        # Maximize z = 3x + 4y 
        # subject to
        # x + 2y <= 300
        # 2x + y <= 300
        # x, y >= 0
        problem1 = createsimplexproblem(
            [3.0, 4.0],
            [1.0 2.0; 2.0 1.0],
            [300.0, 300.0],
            [LE, LE],
            Maximize,
        )
        iters = simplexiterations(problem1)
        lastiter = iters[end]
        @test lastiter.converged
        @test isapprox(lastiter.objective_value, 700.0, atol = eps)
        @test isapprox(lastiter.rhs, [100.0, 100.0], atol = eps)

        # Maximize z = 3x + 4y 
        # subject to
        # x + 2y <= Cap1
        # 2x + y <= Cap2
        # Cap1 + Cap2 = 600
        # x, y, Cap1, Cap2 >= 0
        problem2 = createsimplexproblem(
            [3.0, 4.0, 0.0, 0.0],
            [1.0 2.0 -1.0 0.0; 2.0 1.0 0.0 -1.0; 0.0 0.0 1.0 1.0],
            [eps, eps, 600.0],
            [LE, LE, EQ],
            Maximize,
        )
        iters = simplexiterations(problem2)
        lastiter = iters[end]
        @test lastiter.converged
        # Problem has epsilons in rhs, so objective value is slightly off
        # due to numerical issues. Allowing a bit more tolerance here.
        @test isapprox(lastiter.objective_value, 800.0, atol = 10 * eps)
        @test isapprox(lastiter.rhs, [200.0, 200.0, 400.0], atol = 10 * eps)
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

    @testset "Mini Transportation Problem - 2" begin

        eps = 0.001
        #    M1  M2  M3  Supply
        # F1 10  20  25  150
        # F2 12  15   7  100
        # Demand  190  40  20
        s = createsimplexproblem(
            Float64[10, 20, 25, 12, 15, 7],
            Float64[1 1 1 0 0 0; 0 0 0 1 1 1; 1 0 0 1 0 0; 0 1 0 0 1 0; 0 0 1 0 0 1],
            Float64[150, 100, 190, 40, 20],
            [EQ, EQ, EQ, EQ, EQ],
            Minimize,
        )

        iters = simplexiterations(s)

        lastiter = iters[end]

        @test lastiter.converged
        @test isapprox(lastiter.objective_value, 2720.0, atol = eps)
        @test sort(lastiter.basicvariableindex) == [1, 4, 5, 6, 10]
        @test sort(lastiter.artificialvariableindices) == [7, 8, 9, 10, 11]
        @test isapprox(lastiter.rhs, [150.0, 40.0, 40.0, 0.0, 20.0], atol = eps)
    end

    @testset "Mini Transportation Problem - 1" begin

        eps = 0.001
        # Mini Transportation Problem
        #           M1       M2      M3     Supply 
        # F1        10       15      20      200
        # F2        17       13       9      100
        # Demand    110      80      110      -
        obj = Float64[10, 15, 20, 17, 13, 9]
        amat = Float64[
            1 1 1 0 0 0
            0 0 0 1 1 1
            1 0 0 1 0 0
            0 1 0 0 1 0
            0 0 1 0 0 1
        ]
        rhs = Float64[200, 100, 110, 80, 110]
        dirs = [EQ, EQ, EQ, EQ, EQ]
        opt = Minimize

        problem::SimplexProblem = createsimplexproblem(obj, amat, rhs, dirs, opt)

        iters = simplexiterations(problem)

        lastiter = iters[end]

        @test lastiter.converged
        @test isapprox(lastiter.objective_value, 3400.0, atol = eps)
        @test sort(lastiter.basicvariableindex) == [1, 2, 3, 6, 11]
        @test sort(lastiter.artificialvariableindices) == [7, 8, 9, 10, 11]
        @test isapprox(lastiter.rhs, [10.0, 100.0, 110.0, 80.0, 0.0], atol = eps)
    end


    @testset "Unbounded Problem - Should throw an error" begin

        # Maximize z = 3x + 4y
        # subject to
        # x + 2y >= 100
        # 3x +   y >= 200
        # x, y >= 0
        
        problem = createsimplexproblem(
            Float64[3, 4], 
            Float64[1 2; 3 1], 
            Float64[100, 200], 
            [GE, GE], 
            Maximize)


        @test_throws ErrorException solve!(problem)

    end

    @testset "Dual Simplex - Minimize with GE" begin

        eps = 0.001

        # Minimize z = 100x1 + 120x2
        # subject to
        # 3x1 + 2x2 >= 36
        # 2x1 + 4x2 >= 24
        # x1, x2 >= 0
        # Result:
        # x1 = 12.0, x2 = 0.0
        # Objective value = 1200.0

        s = createsimplexproblem(
            Float64[100.0, 120.0],
            Float64[3.0 2.0; 2.0 4.0],
            Float64[36.0, 24.0],
            [GE, GE],
            Minimize,
        )
        solve!(s, method = Dual)

        @test s.converged
        @test isapprox(s.objective_value, 1200.0, atol = eps)
        @test sort(s.basicvariableindex) == [1, 4]
        @test isapprox(s.rhs, [12.0, 0.0], atol = eps)

    end

    @testset "Dual Simplex - Maximize with Mixed Directions" begin

        eps = 0.001

        # Maximize z = -2x1 - x2
        # subject to
        #  x1 +  x2 >= 4
        # 2x1 + 3x2 <= 12
        # x1, x2 >= 0
        # Result:
        # x1 = 0.0, x2 = 4.0
        # Objective value = -4.0

        s = createsimplexproblem(
            Float64[-2.0, -1.0],
            Float64[1.0 1.0; 2.0 3.0],
            Float64[4.0, 12.0],
            [GE, LE],
            Maximize,
        )
        solve!(s, method = Dual)

        @test s.converged
        @test isapprox(s.objective_value, -4.0, atol = eps)
        @test sort(s.basicvariableindex) == [2, 4]
        @test isapprox(s.rhs, [4.0, 0.0], atol = eps)

    end

    @testset "Dual Simplex - Equality and Primal Consistency" begin

        eps = 0.001

        # Minimize z = 4x1 + 5x2
        # subject to
        # x1 +  x2  = 4
        # x1 + 2x2 >= 6
        # x1, x2 >= 0
        # Result:
        # x1 = 2.0, x2 = 2.0
        # Objective value = 18.0

        s_primal = createsimplexproblem(
            Float64[4.0, 5.0],
            Float64[1.0 1.0; 1.0 2.0],
            Float64[4.0, 6.0],
            [EQ, GE],
            Minimize,
        )
        solve!(s_primal, method = Primal)

        s_dual = createsimplexproblem(
            Float64[4.0, 5.0],
            Float64[1.0 1.0; 1.0 2.0],
            Float64[4.0, 6.0],
            [EQ, GE],
            Minimize,
        )
        solve!(s_dual, method = Dual)

        @test s_primal.converged
        @test s_dual.converged
        @test isapprox(s_dual.objective_value, 18.0, atol = eps)
        @test isapprox(s_primal.objective_value, s_dual.objective_value, atol = eps)

        s_iter = createsimplexproblem(
            Float64[4.0, 5.0],
            Float64[1.0 1.0; 1.0 2.0],
            Float64[4.0, 6.0],
            [EQ, GE],
            Minimize,
        )
        iters = simplexiterations(s_iter, method = Dual)
        @test iters[end].converged
        @test isapprox(iters[end].objective_value, 18.0, atol = eps)

    end

    @testset "Dual Simplex - Error Handling" begin

        # Not dual feasible initially:
        # Minimize z = -10x1 + 120x2
        # subject to
        # 3x1 + 2x2 >= 36
        # 2x1 + 4x2 >= 24
        # x1, x2 >= 0
        s1 = createsimplexproblem(
            Float64[-10.0, 120.0],
            Float64[3.0 2.0; 2.0 4.0],
            Float64[36.0, 24.0],
            [GE, GE],
            Minimize,
        )
        @test_throws ErrorException solve!(s1, method = Dual)

        s2 = createsimplexproblem(
            Float64[-10.0, 120.0],
            Float64[3.0 2.0; 2.0 4.0],
            Float64[36.0, 24.0],
            [GE, GE],
            Minimize,
        )
        @test_throws ErrorException simplexiterations(s2, method = Dual)

        # Infeasible problem (Dual unbounded):
        # Minimize z = 10x1 + 20x2
        # subject to
        # x1 + x2 <= 5
        # x1 + x2 >= 10
        # x1, x2 >= 0
        s3 = createsimplexproblem(
            Float64[10.0, 20.0],
            Float64[1.0 1.0; 1.0 1.0],
            Float64[5.0, 10.0],
            [LE, GE],
            Minimize,
        )
        @test_throws ErrorException solve!(s3, method = Dual)

        s4 = createsimplexproblem(
            Float64[10.0, 20.0],
            Float64[1.0 1.0; 1.0 1.0],
            Float64[5.0, 10.0],
            [LE, GE],
            Minimize,
        )
        @test_throws ErrorException simplexiterations(s4, method = Dual)

    end

end # end of test set Simplex
