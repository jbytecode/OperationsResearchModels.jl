@testset "Johnson's algorithm" verbose = true begin

    @testset "Two machines" verbose = true begin

        @testset "Example 1 with 2-machines" begin
            times = Float64[
                3.2 4.2
                4.7 1.5
                2.2 5.0
                5.8 4.0
                3.1 2.8
            ]

            problem = JohnsonProblem(times)

            result = solve(problem)

            @test result.permutation == [3, 1, 4, 5, 2]
        end


        @testset "Example 2 with 2-machines" begin
            times = Float64[
                4 7
                8 3
                5 8
                6 4
                8 5
                7 4
            ]

            problem = JohnsonProblem(times)

            result = solve(problem)

            time_elapsed = makespan(problem, result.permutation)

            @test result.permutation == [1, 3, 5, 6, 4, 2]

            @test time_elapsed == 41
        end
    end


    @testset "Three machines" verbose = true begin

        @testset "Example 1 for 3-machines" begin

            times = Float64[
                3 3 5
                8 4 8
                7 2 10
                5 1 7
                2 5 6
            ]

            problem = JohnsonProblem(times)

            result = solve(problem)

            time_elapsed = makespan(problem, result.permutation)

            @test result.permutation == [1, 4, 5, 3, 2]

            @test time_elapsed == 42
        end
    end


    @testset "Five machines" verbose = true begin

        @testset "Example 1 for 5-machines" begin

            times = Float64[
                7 5 2 3 9
                6 6 4 5 10
                5 4 5 6 8
                8 3 3 2 6
            ]

            problem = JohnsonProblem(times)

            result = solve(problem)

            time_elapsed = makespan(problem, result.permutation)

            @test result.permutation == [1, 3, 2, 4]

            @test time_elapsed == 51
        end
    end


    @testset "Cannot reduce to 2-machines" begin

        times = Float64[
            3 3 5 2
            8 4 8 3
            7 2 10 4
            5 1 7 5
            2 5 6 6
        ]

        problem = JohnsonProblem(times)

        @test_throws JohnsonException solve(problem)

    end

    @testset "Other types of matrices (Int)" begin

        mat = rand(1:10, 10, 2)

        result = solve(JohnsonProblem(mat))

        # expect no error 
        @test true
    end

    @testset "Other types of matrices (UInt8)" begin

        mat = convert(Matrix{UInt8}, rand(1:10, 10, 2))

        result = solve(JohnsonProblem(mat))

        # expect no error 
        @test true
    end



    @testset "makespan" begin

        best_permutation = [1, 4, 5, 3, 2]
        best_makespan = 42


        times = Float64[
            3 3 5
            8 4 8
            7 2 10
            5 1 7
            2 5 6
        ]

        problem = JohnsonProblem(times)


        ms = Float64[
            makespan(problem, [1, 2, 3, 4, 5]),
            makespan(problem, [1, 2, 3, 5, 4]),
            makespan(problem, [1, 2, 4, 3, 5]),
            makespan(problem, [1, 2, 4, 5, 3]),
            makespan(problem, [1, 2, 5, 3, 4]),
            makespan(problem, [1, 2, 5, 4, 3]),
            makespan(problem, [1, 3, 2, 4, 5]),
            makespan(problem, [1, 3, 2, 5, 4]),
            makespan(problem, [1, 3, 4, 2, 5]),
            makespan(problem, [1, 3, 4, 5, 2]),
            makespan(problem, [1, 3, 5, 2, 4]),
            makespan(problem, [1, 3, 5, 4, 2]),
            makespan(problem, [1, 4, 2, 3, 5]),
            makespan(problem, [1, 4, 2, 5, 3]),
            makespan(problem, [1, 4, 3, 2, 5]),
            makespan(problem, [1, 4, 3, 5, 2]),
            makespan(problem, [1, 4, 5, 2, 3]),
            makespan(problem, [1, 4, 5, 3, 2]),
        ]

        @test minimum(ms) == best_makespan
    end



    @testset "GA" verbose = true begin

        @testset "Two machines - with ga" verbose = true begin

            @testset "Example 1 with 2-machines with ga" begin
                times = Float64[
                    3.2 4.2
                    4.7 1.5
                    2.2 5.0
                    5.8 4.0
                    3.1 2.8
                ]

                problem = JohnsonProblem(times)

                result = johnsons_ga(problem)

                @test makespan(problem, result.permutation) == 20.5
            end


            @testset "Example 2 with 2-machines with ga" begin
                times = Float64[
                    4 7
                    8 3
                    5 8
                    6 4
                    8 5
                    7 4
                ]


                problem = JohnsonProblem(times)

                result = johnsons_ga(problem)

                time_elapsed = makespan(problem, result.permutation)

                @test time_elapsed == 41
            end
        end


        @testset "Three machines - with ga" verbose = true begin

            @testset "Example 1 for 3-machines with ga" begin

                times = Float64[
                    3 3 5
                    8 4 8
                    7 2 10
                    5 1 7
                    2 5 6
                ]

                problem = JohnsonProblem(times)

                result = johnsons_ga(problem)

                time_elapsed = makespan(problem, result.permutation)

                @test time_elapsed == 42
            end
        end

        @testset "Five machines - with ga" verbose = true begin

            @testset "Example 1 for 5-machines - with ga " begin

                times = Float64[
                    7 5 2 3 9
                    6 6 4 5 10
                    5 4 5 6 8
                    8 3 3 2 6
                ]

                problem = JohnsonProblem(times)

                result = johnsons_ga(problem)

                time_elapsed = makespan(problem, result.permutation)

                @test time_elapsed == 51
            end
        end

        @testset "Cannot reduce to 2-machine - but solvable with GA" begin

            times = Float64[
                3 3 5 2
                8 4 8 3
                7 2 10 4
                5 1 7 5
                2 5 6 6
            ]

            problem = JohnsonProblem(times)

            result = johnsons_ga(problem)

            time_elapsed = makespan(problem, result.permutation)

            @test time_elapsed == 44
        end

    end # end of GA testset

end # end of Johnson's algorithm testset
