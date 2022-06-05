module Assignment

struct AssignmentProblem{T <: Real}
    costs  :: Array{T, 2}
end

struct AssignmentResult 
    problem :: AssignmentProblem
    solution :: Matrix
end 

function solve(a::AssignmentProblem)
end 


end # end of module 