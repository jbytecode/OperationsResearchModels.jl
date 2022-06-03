module OpeRe

include("transportation.jl")

import .Transportation: TransportationProblem, TransportationResult, balance, isbalanced, solve

export TransportationProblem, TransportationResult, balance, isbalanced, solve 

end # end of module
