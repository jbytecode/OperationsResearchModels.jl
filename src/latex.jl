module Latex

export latex

import ..Transportation: TransportationProblem, TransportationResult
import ..Simplex: SimplexProblem
import ..Utility: numround

function makeformatterstring(n::Int)::String
    return "{|" * (["c" for i = 1:n] |> x -> join(x, "|")) * "|}"
end

function latex(io::IO, t::TransportationProblem)::Nothing
    n, p = size(t.costs)

    formatter = makeformatterstring(2 + p)

    println(io, "\\begin{table}[H]")
    println(io, "\\begin{tabular}$(formatter)")
    println(io, "\\hline")

    # Header
    print(io, "     & ")
    for column = 1:p
        print(io, string("\$D_", column, "\$"))
        if column < p
            print(io, " & ")
        end
    end
    println(io, " & Supply \\\\")
    println(io, "\\hline")

    # Costs 
    for row = 1:n
        print(io, string("\$S_", row, "\$ & "))
        for column = 1:p
            print(io, numround(t.costs[row, column]))
            if column < p
                print(io, " & ")
            end
        end
        print(io, " & ", numround(t.supply[row]))
        println(io, "\\\\")
    end
    println(io, "\\hline")

    # Demand line 
    print(io, "Demand & ")
    for column = 1:p
        print(io, numround(t.demand[column]))
        if column < p
            print(io, " & ")
        end
    end
    println(io, " & \\\\")
    println(io, "\\hline")
    println(io, "\\end{tabular}")
    println(io, "\\label{tbl:}")
    println(io, "\\caption{}")
    println(io, "\\end{table}")
end

function latex(io::IO, t::TransportationResult)::Nothing
    n, p = size(t.balancedProblem.costs)

    formatter = makeformatterstring(2 + p)

    println(io, "\\begin{table}[H]")
    println(io, "\\begin{tabular}$(formatter)")
    println(io, "\\hline")

    # Header
    print(io, "     & ")
    for column = 1:p
        print(io, string("\$D_", column, "\$"))
        if column < p
            print(io, " & ")
        end
    end
    println(io, " & Supply \\\\")
    println(io, "\\hline")

    # Costs 
    for row = 1:n
        print(io, string("\$S_", row, "\$ & "))
        for column = 1:p
            print(io, numround(t.balancedProblem.costs[row, column]))
            if (!iszero(t.solution[row, column]))
                print(io, " \\tiny{($(t.solution[row, column]))}")
            end
            if column < p
                print(io, " & ")
            end
        end
        print(io, " & ", numround(t.balancedProblem.supply[row]))
        println(io, "\\\\")
    end
    println(io, "\\hline")

    # Demand line 
    print(io, "Demand & ")
    for column = 1:p
        print(io, numround(t.balancedProblem.demand[column]))
        if column < p
            print(io, " & ")
        end
    end
    println(io, " & \\\\")
    println(io, "\\hline")
    println(io, "\\end{tabular}")
    println(io, "\\label{tbl:}")
    println(io, "\\caption{Total cost: $(t.cost)}")
    println(io, "\\end{table}")
end



# Latex table for Simplex 

function tableheader(s::SimplexProblem)
    return "  & " * join(s.varnames, " & ") * " & Solution \\\\"
end

function tablerows(s::SimplexProblem)
    trow =
        "z & " *
        join(-1.0 .* numround.(s.z), " & ") *
        " & " *
        string(numround(s.objective_value)) *
        "\\\\"
    trow *= "\n \\hline"
    n, _ = size(s.lhs)
    for i = 1:n
        c = s.lhs[i, :]
        vname = s.varnames[s.basicvariableindex[i]]
        trow *=
            "\n" *
            vname *
            " & " *
            join(numround.(c), " & ") *
            " & " *
            string(numround.(s.rhs[i])) *
            "\\\\"
        trow *= "\n \\hline"
    end
    return trow
end

function latex(s::SimplexProblem)
    formatter = makeformatterstring(length(s.varnames) + 2)
    header = tableheader(s)
    trows = tablerows(s)
    latex = """
   \\begin{table}[H]
   \\centering
   \\begin{tabular}{$formatter}
   \\hline
   $header
   \\hline
   $trows 
   \\end{tabular}
   \\label{}
   \\caption{}
   \\end{table}
   """
    return latex
end

end # end of module latex
