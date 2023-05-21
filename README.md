[![Doc](https://img.shields.io/badge/docs-dev-blue.svg)](https://jbytecode.github.io/OperationsResearchModels.jl/dev/)

# OperationsResearchModels.jl

A package for Operations Research problems.




# The Content

## Linear Transportation Problem

Suppose the linear transportation problem is 


|        |  D1       |  D2      |  D3      |  D4       |  Supply  |
| :---:  | :-------: | :-----:  | :------: | :------:  |  :-----: |     
|  S1    |  1        |  5 (100) |  7       |  8        |  100     |
|  S2    |  2        |  6       |  4 (100) |  9        |  100     |
|  S3    |  3 (100)  |  10      |  11      |  12 (100) |  200     |
| Demand | 100       | 100      | 100      | 100       |          |

Here is the Julia solution:

```julia
t = TransportationProblem(
            [1 5 7 8;
             2 6 4 9;
             3 10 11 12;],
            [100, 100, 100, 100],
            [100, 100, 200])
        
result = solve(t)
```

## Linear Assignment Problem

```julia
mat = [
            4 8 1;
            3 1 9;
            1 6 7;
        ]
        # x13 = 1
        # x22 = 1
        # x31 = 1
        # cost = 3 

a = AssignmentProblem(mat)
result = solve(a)
```

## The Shortest-Path Problem

```julia 
conns = [
            Connection(1, 2, 3),
            Connection(1, 3, 2),
            Connection(1, 4, 4),
            Connection(2, 5, 3),
            Connection(3, 5, 1),
            Connection(3, 6, 1),
            Connection(4, 6, 2),
            Connection(5, 7, 6),
            Connection(6, 7, 5),
]
result = solve(conns, problem = ShortestPathProblem)
```

## The Maximum Flow Problem

```julia
conns = [
            Connection(1, 4, 10),
            Connection(1, 2, 20),
            Connection(1, 3, 30),
            Connection(2, 3, 30),
            Connection(4, 5, 20),
            Connection(3, 5, 20),
            Connection(2, 5, 30),
            Connection(3, 4, 10),
            Connection(4, 3, 5),
        ]

result = solve(conns, problem = MaximumFlowProblem)

```


## Zero-Sum Games 

```julia
mat = [
          -2 6 3;
           3 -4 7;
           -1 2 4;
    ]

result = game(mat)
```

## p-median for selecting location of facilities

## Minimum Spanning Tree 
