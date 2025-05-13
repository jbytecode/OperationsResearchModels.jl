# Algorithms

## Assignment Problem
```@docs
OperationsResearchModels.solve(a::AssignmentProblem)
```

```@docs
OperationsResearchModels.AssignmentProblem
```

```@docs
OperationsResearchModels.AssignmentResult
```

## Transportation Problem

```@docs
OperationsResearchModels.solve(t::TransportationProblem)
```

```@docs
OperationsResearchModels.TransportationProblem
```

```@docs
OperationsResearchModels.TransportationResult
```

### Initial basic solutions for a transportation problem 

#### North-west Corner Method 

```@docs
OperationsResearchModels.northwestcorner
```

#### The Least Cost Method 

```@docs
OperationsResearchModels.leastcost
```


## Shortest Path
```@docs
OperationsResearchModels.solve(t::ShortestPathProblem)
```

## Maximum Flow
```@docs
OperationsResearchModels.solve(t::MaximumFlowProblem)
```

## Minimum Spanning Tree
```@docs
OperationsResearchModels.solve(p::MstProblem)
```

## pmedian
```@docs
OperationsResearchModels.pmedian
```

## pmedian with distances
```@docs 
OperationsResearchModels.pmedian_with_distances
```

## CPM (Critical Path Method)
```@docs
OperationsResearchModels.solve(problem::CpmProblem)
```

### CPM Activity
```@docs
OperationsResearchModels.CpmActivity
```


## PERT (Project Evaluation and Review Technique)
```@docs
OperationsResearchModels.solve(problem::PertProblem)
```

### PERT Activity
```@docs
OperationsResearchModels.PertActivity
```

## Knapsack 
```@docs
OperationsResearchModels.solve(p::KnapsackProblem)
```

## Johnson's Rule
```@docs
OperationsResearchModels.johnsons
```

### Genetic Algorithm for the problems that cannot be solved with using Johnson's Rule
```@docs
OperationsResearchModels.johnsons_ga
```

### Makespan
```@docs
OperationsResearchModels.makespan
```


## Traveling Salesman
```@docs
OperationsResearchModels.travelingsalesman
```

## Simplex
```@docs 
OperationsResearchModels.createsimplexproblem
```

### Gauss Jordan steps for matrix inversion
```@docs
OperationsResearchModels.gaussjordan
```

