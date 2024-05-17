var documenterSearchIndex = {"docs":
[{"location":"#Operations-Research-Models","page":"-","title":"Operations Research Models","text":"","category":"section"},{"location":"","page":"-","title":"-","text":"The OperationsResearchModels package includes basic Operations Research subjects such as Transportation Problem, Assignment Problem, Minimum Spanning Tree, Shortest Path, Maximum Flow,  and p-medians method for selecting location of facilities. ","category":"page"},{"location":"","page":"-","title":"-","text":"Package content is incrementaly updated.","category":"page"},{"location":"","page":"-","title":"-","text":"Please refer the Algorithms section for the detailed documentation. ","category":"page"},{"location":"algorithms/#Algorithms","page":"Algorithms","title":"Algorithms","text":"","category":"section"},{"location":"algorithms/#Assignment-Problem","page":"Algorithms","title":"Assignment Problem","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(a::AssignmentProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{AssignmentProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(a)\n\nArguments\n\na::AssignmentProblem: The problem in type of AssignmentProblem\n\nOutput\n\nAssignmentResult: The custom data type that holds problem, solution, and optimum cost. \n\nDescription\n\nSolves an assignment problem given by an object of in type AssignmentProblem.\n\nExample\n\njulia> mat = [\n                   4 8 1;\n                   3 1 9;\n                   1 6 7;\n               ];\n\njulia> problem = AssignmentProblem(mat);\n\njulia> result = solve(problem);\n\njulia> result.solution\n\n3×3 Matrix{Float64}:\n 0.0  0.0  1.0\n 0.0  1.0  0.0\n 1.0  0.0  0.0\n\njulia> result.cost\n\n3.0\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#Transportation-Problem","page":"Algorithms","title":"Transportation Problem","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(t::TransportationProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{TransportationProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(t)\n\nArguments\n\na::TransportationProblem: The problem in type of TransportationProblem\n\nOutput\n\nTransportationResult: The custom data type that holds problem, solution, and optimum cost. \n\nDescription\n\nSolves a transportation problem given by an object of in type TransportationProblem.\n\nExample\n\njulia> t = TransportationProblem(\n                   [   1 1 1 1; \n                       2 2 2 2; \n                       3 3 3 3], \n                   [100, 100, 100, 100], # Demands \n                   [100, 100, 100])      # Supplies \nTransportation Problem:\nCosts: [1 1 1 1; 2 2 2 2; 3 3 3 3]\nDemand: [100, 100, 100, 100]\nSupply: [100, 100, 100]\n\njulia> isbalanced(t)\nfalse\n\njulia> result = solve(t)\nTransportation Results:\nMain problem:\nTransportation Problem:\nCosts: [1 1 1 1; 2 2 2 2; 3 3 3 3]\nDemand: [100, 100, 100, 100]\nSupply: [100, 100, 100]\n\nBalanced problem:\nTransportation Problem:\nCosts: [1 1 1 1; 2 2 2 2; 3 3 3 3; 0 0 0 0]\nDemand: [100, 100, 100, 100]\nSupply: [100, 100, 100, 100]\n\nCost:\n600.0\nSolution:\n[-0.0 -0.0 -0.0 100.0; 100.0 -0.0 -0.0 -0.0; -0.0 -0.0 100.0 -0.0; -0.0 100.0 -0.0 -0.0]\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#Shortest-Path","page":"Algorithms","title":"Shortest Path","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(t::ShortestPathProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{ShortestPathProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem)\n\nDescription\n\nSolves a shortest path problem given by an object of in type ShortestPathProblem.\n\nArguments\n\nproblem::ShortestPathProblem: The problem in type of ShortestPathProblem\n\nOutput\n\nShortestPathResult: The custom data type that holds path and cost.\n\nExample\n\njulia> conns = [\n                   Connection(1, 2, 3),\n                   Connection(1, 3, 2),\n                   Connection(1, 4, 4),\n                   Connection(2, 5, 3),\n                   Connection(3, 5, 1),\n                   Connection(3, 6, 1),\n                   Connection(4, 6, 2),\n                   Connection(5, 7, 6),\n                   Connection(6, 7, 5),\n               ];\n\njulia> solve(ShortestPathProblem(conns));\n\njulia> result.path\n3-element Vector{Connection}:\n Connection(1, 3, 2, \"x13\")\n Connection(3, 6, 1, \"x36\")\n Connection(6, 7, 5, \"x67\")\n\njulia> result.cost\n8.0\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#Maximum-Flow","page":"Algorithms","title":"Maximum Flow","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(t::MaximumFlowProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{MaximumFlowProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem)\n\nArguments\n\nproblem::MaximumFlowProblem: The problem in type of MaximumFlowProblem\n\nOutput\n\nMaximumFlowResult: The custom data type that holds path and flow.\n\nExample\n\njulia> conns = [\n                   Connection(1, 2, 3),\n                   Connection(1, 3, 2),\n                   Connection(1, 4, 4),\n                   Connection(2, 5, 3),\n                   Connection(3, 5, 1),\n                   Connection(3, 6, 1),\n                   Connection(4, 6, 2),\n                   Connection(5, 7, 6),\n                   Connection(6, 7, 5),\n               ];\njulia> problem = MaximumFlowProblem(conns)\njulia> result = solve(problem);\n\njulia> result.path\n9-element Vector{Connection}:\n Connection(1, 2, 3.0, \"x12\")\n Connection(1, 3, 2.0, \"x13\")\n Connection(1, 4, 2.0, \"x14\")\n Connection(2, 5, 3.0, \"x25\")\n Connection(3, 5, 1.0, \"x35\")\n Connection(3, 6, 1.0, \"x36\")\n Connection(4, 6, 2.0, \"x46\")\n Connection(5, 7, 4.0, \"x57\")\n Connection(6, 7, 3.0, \"x67\")\n\njulia> result.flow\n7.0\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#Minimum-Spanning-Tree","page":"Algorithms","title":"Minimum Spanning Tree","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(p::MstProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{MstProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem::MstProblem)\n\nArguments\n\nproblem::MstProblem: The problem in type of MstProblem\n\nDescription\n\nObtains the minimum spanning tree. \n\nOutput\n\n::MstResult: A MstResult object that holds the results. \n\nExamples\n\njulia> conns = Connection[\n                       Connection(1, 2, 10),\n                       Connection(2, 3, 10),\n                       Connection(3, 4, 10),\n                       Connection(1, 4, 10)\n                   ]\n\n4-element Vector{Connection}:\n Connection(1, 2, 10, \"x12\")\n Connection(2, 3, 10, \"x23\")\n Connection(3, 4, 10, \"x34\")\n Connection(1, 4, 10, \"x14\")\n\n julia> result = solve(MstProblem(conns))\n MstResult(Connection[Connection(3, 4, 10, \"x34\"), Connection(1, 4, 10, \"x14\"), Connection(2, 3, 10, \"x23\")], 30.0)\n \n julia> result.distance\n 30.0\n \n julia> result.connections\n 3-element Vector{Connection}:\n  Connection(3, 4, 10, \"x34\")\n  Connection(1, 4, 10, \"x14\")\n  Connection(2, 3, 10, \"x23\")\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#pmedian","page":"Algorithms","title":"pmedian","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.pmedian","category":"page"},{"location":"algorithms/#OperationsResearchModels.PMedian.pmedian","page":"Algorithms","title":"OperationsResearchModels.PMedian.pmedian","text":"pmedian(data, ncenters)\n\nArguments\n\ndata::Matrix: Coordinates of locations \nncenters::Int: Number of centers \n\nDescription\n\nThe function calculates Euclidean distances between all possible rows of the matrix data.  ncenters locations are then selected that minimizes the total distances to the nearest rows. \n\nOutput\n\nPMedianResult: PMedianResult object. \n\nExample\n\njulia> data1 = rand(10, 2);\n\njulia> data2 = rand(10, 2) .+ 50;\n\njulia> data3 = rand(10, 2) .+ 100;\n\njulia> data = vcat(data1, data2, data3);\n\njulia> result = pmedian(data, 3);\n\njulia> result.centers\n3-element Vector{Int64}:\n  1\n 16\n 21\n\n julia> result.objective\n 11.531012240599605\n\n\n\n\n\n","category":"function"},{"location":"algorithms/#pmedian-with-distances","page":"Algorithms","title":"pmedian with distances","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.pmedian_with_distances","category":"page"},{"location":"algorithms/#OperationsResearchModels.PMedian.pmedian_with_distances","page":"Algorithms","title":"OperationsResearchModels.PMedian.pmedian_with_distances","text":"pmedian_with_distances(distancematrix, ncenters)\n\nArguments\n\ndistancematrix::Matrix: n x n matrix of distances\nncenters::Int: Number of centers \n\nDescription\n\nncenters locations are selected that minimizes the total distances to the nearest rows. \n\nOutput\n\nPMedianResult: PMedianResult object. \n\n\n\n\n\n","category":"function"},{"location":"algorithms/#CPM-(Critical-Path-Method)","page":"Algorithms","title":"CPM (Critical Path Method)","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(problem::CpmProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{CpmProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem)\n\nArguments\n\nproblem::CpmProblem: The problem in type of CpmProblem.\n\nOutput\n\n::CpmResult: The object holds the results \n\nDescription\n\nCalculates CPM (Critical Path Method) and reports the critical path for a given set of activities. \n\nExample\n\njulia> A = CpmActivity(\"A\", 2);\njulia> B = CpmActivity(\"B\", 3);\njulia> C = CpmActivity(\"C\", 2, [A]);\njulia> D = CpmActivity(\"D\", 3, [B]);\njulia> E = CpmActivity(\"E\", 2, [B]);\njulia> F = CpmActivity(\"F\", 3, [C, D]);\njulia> G = CpmActivity(\"G\", 7, [E]);\njulia> H = CpmActivity(\"H\", 5, [E]);\njulia> I = CpmActivity(\"I\", 6, [G, F]);\njulia> J = CpmActivity(\"J\", 2, [C, D]);\n\njulia> activities = [A, B, C, D, E, F, G, H, I, J];\n\njulia> problem = CpmProblem(activities);\n\njulia> result = solve(problem);\n\njulia> result.pathstr\n4-element Vector{String}:\n \"B\"\n \"E\"\n \"G\"\n \"I\"\n\n julia> result.path == [B, E, G, I]\ntrue\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#CPM-Activity","page":"Algorithms","title":"CPM Activity","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.CpmActivity","category":"page"},{"location":"algorithms/#OperationsResearchModels.CPM.CpmActivity","page":"Algorithms","title":"OperationsResearchModels.CPM.CpmActivity","text":"CpmActivity(name::String, time::Float64, dependencies)\n\nDescription\n\nThe object that represents an activity in CPM (Critical Path Method).\n\nArguments\n\nname::String: The name of the activity.\ntime::Float64: The time of the activity.\ndependencies: The dependencies of the activity in type of Vector{CpmActivity}.\n\nExample\n\njulia> A = CpmActivity(\"A\", 2, []);\n\njulia> B = CpmActivity(\"B\", 3, []);\n\njulia> C = CpmActivity(\"C\", 2, [A, B]);\n\n\n\n\n\n\n","category":"type"},{"location":"algorithms/#PERT-(Project-Evalutation-and-Review-Technique)","page":"Algorithms","title":"PERT (Project Evalutation and Review Technique)","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(problem::PertProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{PertProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem::PertProblem)::PertResult\n\nArguments\n\nproblem::PertProblem: The problem in type of PertProblem.\n\nExample\n\njulia> A = PertActivity(\"A\", 1, 2, 3)\nPertActivity(\"A\", 1.0, 2.0, 3.0, PertActivity[])\n\njulia> B = PertActivity(\"B\", 3, 3, 3)\nPertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[])\n\njulia> C = PertActivity(\"C\", 5, 5, 5, [A, B])\nPertActivity(\"C\", 5.0, 5.0, 5.0, PertActivity[PertActivity(\"A\", 1.0, 2.0, 3.0, PertActivity[]), PertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[])])\n\njulia> activities = [A, B, C]\n3-element Vector{PertActivity}:\n PertActivity(\"A\", 1.0, 2.0, 3.0, PertActivity[])\n PertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[])\n PertActivity(\"C\", 5.0, 5.0, 5.0, PertActivity[PertActivity(\"A\", 1.0, 2.0, 3.0, PertActivity[]), PertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[])])\n\njulia> problem = PertProblem(activities);\n\njulia> result = pert(activities)\nPertResult(PertActivity[PertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[]), PertActivity(\"C\", 5.0, 5.0, 5.0, PertActivity[PertActivity(\"A\", 1.0, 2.0, 3.0, PertActivity[]), PertActivity(\"B\", 3.0, 3.0, 3.0, PertActivity[])])], 8.0, 0.0)\n\njulia> result.mean\n8.0\n\njulia> result.stddev\n0.0\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#PERT-Activity","page":"Algorithms","title":"PERT Activity","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.PertActivity","category":"page"},{"location":"algorithms/#OperationsResearchModels.CPM.PertActivity","page":"Algorithms","title":"OperationsResearchModels.CPM.PertActivity","text":"PertActivity(name::String, o::Float64, m::Float64, p::Float64)::PertActivity\n\nDescription\n\nThe object that represents an activity in PERT (Program Evaluation and Review Technique).\n\nArguments\n\nname::String: The name of the activity.\no::Float64: The optimistic time of the activity.\nm::Float64: The most likely time of the activity.\np::Float64: The pessimistic time of the activity.\ndependencies: The dependencies of the activity in type of Vector{PertActivity}.\n\nExample\n\njulia> A = PertActivity(\"A\", 1, 2, 3);\njulia> B = PertActivity(\"B\", 3, 3, 4);\njulia> C = PertActivity(\"C\", 5, 6, 7, [A, B]);\n\n\n\n\n\n","category":"type"},{"location":"algorithms/#Knapsack","page":"Algorithms","title":"Knapsack","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.solve(p::KnapsackProblem)","category":"page"},{"location":"algorithms/#OperationsResearchModels.solve-Tuple{KnapsackProblem}","page":"Algorithms","title":"OperationsResearchModels.solve","text":"solve(problem::KnapsackProblem)::KnapsackResult\n\nDescription\n\nSolves the knapsack problem.\n\nArguments\n\nproblem::KnapsackProblem: The problem in type of KnapsackProblem.\n\nOutput\n\nKnapsackResult: The custom data type that holds selected items, model, and objective value.\n\nExample\n\njulia> values = [10, 20, 30, 40, 50];\njulia> weights = [1, 2, 3, 4, 5];\njulia> capacity = 10;\njulia> solve(KnapsackProblem(values, weights, capacity));\n\n\n\n\n\n","category":"method"},{"location":"algorithms/#Johnson's-Rule","page":"Algorithms","title":"Johnson's Rule","text":"","category":"section"},{"location":"algorithms/","page":"Algorithms","title":"Algorithms","text":"OperationsResearchModels.johnsons","category":"page"},{"location":"algorithms/#OperationsResearchModels.Johnsons.johnsons","page":"Algorithms","title":"OperationsResearchModels.Johnsons.johnsons","text":"johnsons(times::Matrix)\n\nGiven a matrix of times, returns a JohnsonResult with the permutation of the jobs\n\nArguments\n\ntimes::Matrix: a matrix of times\n\nReturns\n\nJohnsonResult: a custom data type that holds the permutation of the jobs\n\nExample\n\ntimes = Float64[\n    3.1 2.8;\n    4.0 7.0;\n    8.0 3.0;\n    5.0 8.0;\n    6.0 4.0;\n    8.0 5.0;\n    7.0 4.0\n]\n\nresult = johnsons(times)\n\nprintln(result.permutation)\n\n\n\n\n\n","category":"function"}]
}
