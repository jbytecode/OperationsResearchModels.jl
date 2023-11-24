@testset "Latex converter" begin

    @testset "Transportation Table to Latex" begin

        output = "\\begin{table}[H]\n\\begin{tabular}{|c|c|c|c|c|c|}\n\\hline\n     & \$D_1\$ & \$D_2\$ & \$D_3\$ & \$D_4\$ & Supply \\\\\n\\hline\n\$S_1\$ & 1.0 & 5.0 & 7.0 & 8.0 & 50.0\\\\\n\$S_2\$ & 2.0 & 6.0 & 4.0 & 9.0 & 100.0\\\\\n\$S_3\$ & 3.0 & 10.0 & 11.0 & 12.0 & 200.0\\\\\n\\hline\nDemand & 100.0 & 100.0 & 100.0 & 100.0 & \\\\\n\\hline\n\\end{tabular}\n\\label{tbl:}\n\\caption{}\n\\end{table}\n"

        t = TransportationProblem(
            [
                1 5 7 8
                2 6 4 9
                3 10 11 12
            ],
            [100, 100, 100, 100],
            [50, 100, 200],
        )


        buffer = IOBuffer()
        latex(buffer, t)

        @test String(take!(buffer)) == String(take!(IOBuffer(output)))
    end


    @testset "Transportation Result to Latex" begin

        output = "\\begin{table}[H]\n\\begin{tabular}{|c|c|c|c|c|c|}\n\\hline\n     & \$D_1\$ & \$D_2\$ & \$D_3\$ & \$D_4\$ & Supply \\\\\n\\hline\n\$S_1\$ & 1.0 & 5.0 \\tiny{(50.0)} & 7.0 & 8.0 & 50.0\\\\\n\$S_2\$ & 2.0 & 6.0 & 4.0 \\tiny{(100.0)} & 9.0 & 100.0\\\\\n\$S_3\$ & 3.0 \\tiny{(100.0)} & 10.0 \\tiny{(50.0)} & 11.0 & 12.0 \\tiny{(50.0)} & 200.0\\\\\n\$S_4\$ & 0.0 & 0.0 & 0.0 & 0.0 \\tiny{(50.0)} & 50.0\\\\\n\\hline\nDemand & 100.0 & 100.0 & 100.0 & 100.0 & \\\\\n\\hline\n\\end{tabular}\n\\label{tbl:}\n\\caption{Total cost: 2050.0}\n\\end{table}\n"

        t = TransportationProblem(
            [
                1 5 7 8
                2 6 4 9
                3 10 11 12
            ],
            [100, 100, 100, 100],
            [50, 100, 200],
        )


        result = solve(t)

        buffer = IOBuffer()

        latex(buffer, result)

        @test String(take!(buffer)) == String(take!(IOBuffer(output)))
    end


    @testset "Simplex Table to Latex" begin

        output = "\\begin{table}[H]\n\\centering\n\\begin{tabular}{{|c|c|c|c|c|c|c|c|}}\n\\hline\n  & x1 & x2 & x3 & x4 & x5 & x6 & Solution \\\\\n\\hline\nz & -0.0 & -0.0 & -66.667 & -1433.333 & -16.667 & -1483.333 & 183.333\\\\\n \\hline\nx2 & 0.0 & 1.0 & -0.667 & 0.667 & 0.333 & -0.333 & 0.333\\\\\n \\hline\nx1 & 1.0 & 0.0 & 0.333 & -0.333 & -0.667 & 0.667 & 1.333\\\\\n \\hline \n\\end{tabular}\n\\label{}\n\\caption{}\n\\end{table}\n"


        s = SimplexProblem()
        setobjectivecoefs(s, [100, 150])
        setlhs(s, Float64[1 2; 2 1])
        setrhs(s, Float64[2, 3])
        setopttype(s, Minimize)
        setdirections(s, [GE, GE])
        setautomaticvarnames(s)
        solve!(s)


        texstr = latex(s)

        @test texstr == String(take!(IOBuffer(output)))
    end

end
