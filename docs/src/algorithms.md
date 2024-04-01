# Algorithms

## Assignment Problem
```@docs
OperationsResearchModels.solve(a::AssignmentProblem)
```

## Transportation Problem
```@docs
OperationsResearchModels.solve(t::TransportationProblem)
```

## Shortest Path and Maximum Flow 
    
    solve(c::Vector{Connection}; problem::Union{::ShortestPathProblem, ::MaximumFlowProblem} = ShortestPathProblem)

### Arguments 
- `c::Vector{Connection}`: Vector of connections 
- `problem`: Type of problem. Either `ShortestPathProblem` or `MaximumFlowProblem`

### Example 

```julia 
julia> conns = [
                   Connection(1, 2, 3),
                   Connection(1, 3, 2),
                   Connection(1, 4, 4),
                   Connection(2, 5, 3),
                   Connection(3, 5, 1),
                   Connection(3, 6, 1),
                   Connection(4, 6, 2),
                   Connection(5, 7, 6),
                   Connection(6, 7, 5),
               ];

julia> solve(conns, problem = ShortestPathProblem);

julia> result.path
3-element Vector{Connection}:
 Connection(1, 3, 2, "x13")
 Connection(3, 6, 1, "x36")
 Connection(6, 7, 5, "x67")

julia> result.cost
8.0

julia> result = solve(conns, problem = MaximumFlowProblem);

julia> result.path
9-element Vector{Connection}:
 Connection(1, 2, 3.0, "x12")
 Connection(1, 3, 2.0, "x13")
 Connection(1, 4, 2.0, "x14")
 Connection(2, 5, 3.0, "x25")
 Connection(3, 5, 1.0, "x35")
 Connection(3, 6, 1.0, "x36")
 Connection(4, 6, 2.0, "x46")
 Connection(5, 7, 4.0, "x57")
 Connection(6, 7, 3.0, "x67")

julia> result.flow
7.0
```


## pmedian
```@docs
OperationsResearchModels.pmedian
```

```@docs 
OperationsResearchModels.pmedian_with_distances
```

## Minimum Spanning Tree
```@docs
OperationsResearchModels.mst
```

## CPM (Critical Path Method)
```@docs
OperationsResearchModels.cpm
```

## PERT (Project Evalutation and Review Technique)
```@docs
OperationsResearchModels.pert
```