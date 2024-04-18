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

```julia
julia> distance_matrix = Float64[
            0 8 7 9 3;
            8 0 2 6 1;
            7 2 0 4 5;
            9 6 4 0 10;
            3 1 5 10 0]

julia> number_of_depots = 3;

julia> result = pmedian_with_distances(distance_matrix, number_of_depots);

ulia> result.objective
3.0

julia> result.y
5-element Vector{Float64}:
  1.0
  1.0
 -0.0
  1.0
 -0.0

julia> result.centers
3-element Vector{Int64}:
 1
 2
 4
```

## Minimum Spanning Tree 

```julia
julia> conns = Connection[
                       Connection(1, 2, 10),
                       Connection(2, 3, 10),
                       Connection(3, 4, 10),
                       Connection(1, 4, 10)
                   ]
4-element Vector{Connection}:
 Connection(1, 2, 10, "x12")
 Connection(2, 3, 10, "x23")
 Connection(3, 4, 10, "x34")
 Connection(1, 4, 10, "x14")

julia> result = mst(conns)
MstResult(Connection[Connection(3, 4, 10, "x34"), Connection(1, 4, 10, "x14"), Connection(2, 3, 10, "x23")], 30.0)

julia> result.distance
30.0

julia> result.connections
3-element Vector{Connection}:
 Connection(3, 4, 10, "x34")
 Connection(1, 4, 10, "x14")
 Connection(2, 3, 10, "x23")

```

## CPM (Critical Path Method)

## PERT (Project Evaluation and Review Technique)

```julia
A = PertActivity("A", 1, 2, 3)
B = PertActivity("B", 3, 3, 3)
# C dependens on A and B
# with optimistic, mostlikely, and pessimistics
# times of 5, 5, and 5, respectively
C = PertActivity("C", 5, 5, 5, [A, B])

activities = [A, B, C]
```

```julia
julia> result = pert(activities)
PertResult(PertActivity[PertActivity("B", 3.0, 3.0, 3.0, PertActivity[]), PertActivity("C", 5.0, 5.0, 5.0, PertActivity[PertActivity("A", 1.0, 2.0, 3.0, PertActivity[]), PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])])], 8.0, 0.0)
```


```julia
julia> result.mean
8.0

julia> result.stddev
0.0

julia> result.path
2-element Vector{PertActivity}:
 PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])
 PertActivity("C", 5.0, 5.0, 5.0, PertActivity[PertActivity("A", 1.0, 2.0, 3.0, PertActivity[]), PertActivity("B", 3.0, 3.0, 3.0, PertActivity[])])

```

## Simplex with iterations 

Suppose the problem is 

$$
\begin{aligned}
\max z = & 2x_1 + 3x_2 \\
\text{Subject to:} & \\
& x_1 + 2x_2 \le 100 \\
& 2x_1 + x_2 \le 150 \\
& x_1, x_2 \ge 0 
\end{aligned}
$$

```julia
using OperationsResearchModels.Simplex

problem = createsimplexproblem(
    Float64[2, 3],
    Float64[1 2; 2 1],
    Float64[100, 150],
    [LE, LE],
    Maximize
);

println(problem)
```


```
Maximize -> 2.0x1 + 3.0x2
S.t:
1.0x1 + 2.0x2 LE 100.0
2.0x1 + 1.0x2 LE 150.0
All variables are non-negative
```

```julia
julia> simplexpretty(problem)

[ Info: The problem:
Maximize -> 2.0x1 + 3.0x2
S.t:
1.0x1 + 2.0x2 LE 100.0
2.0x1 + 1.0x2 LE 150.0
All variables are non-negative

[ Info: The standard form:
Maximize -> 2.0x1 + 3.0x2 + 0.0x3 + 0.0x4
S.t:
x3: 1.0x1 + 2.0x2 + 1.0x3 + 0.0x4 EQ 100.0
x4: 2.0x1 + 1.0x2 + 0.0x3 + 1.0x4 EQ 150.0
Slack: [3, 4]
Basic Variables: [3, 4]
All variables are non-negative

[ Info: M Method corrections:
Maximize -> 2.0x1 + 3.0x2 + 0.0x3 + 0.0x4
S.t:
x3: 1.0x1 + 2.0x2 + 1.0x3 + 0.0x4 EQ 100.0
x4: 2.0x1 + 1.0x2 + 0.0x3 + 1.0x4 EQ 150.0
Slack: [3, 4]
Basic Variables: [3, 4]
All variables are non-negative

[ Info: Iteration 1
Maximize -> 0.5x1 + 0.0x2 + -1.5x3 + 0.0x4
S.t:
x2: 0.5x1 + 1.0x2 + 0.5x3 + 0.0x4 EQ 50.0
x4: 1.5x1 + 0.0x2 + -0.5x3 + 1.0x4 EQ 100.0
Slack: [3, 4]
Basic Variables: [2, 4]
All variables are non-negative

[ Info: Iteration 2
Maximize -> 0.0x1 + 0.0x2 + -1.3333333333333333x3 + -0.3333333333333333x4
S.t:
x2: 0.0x1 + 1.0x2 + 0.6666666666666666x3 + -0.3333333333333333x4 EQ 16.666666666666664
x1: 1.0x1 + 0.0x2 + -0.3333333333333333x3 + 0.6666666666666666x4 EQ 66.66666666666667
Slack: [3, 4]
Basic Variables: [2, 1]
All variables are non-negative

[ Info: Iteration 3
Maximize -> 0.0x1 + 0.0x2 + -1.3333333333333333x3 + -0.3333333333333333x4
S.t:
x2: 0.0x1 + 1.0x2 + 0.6666666666666666x3 + -0.3333333333333333x4 EQ 16.666666666666664
x1: 1.0x1 + 0.0x2 + -0.3333333333333333x3 + 0.6666666666666666x4 EQ 66.66666666666667
Slack: [3, 4]
Basic Variables: [2, 1]
All variables are non-negative
Status: CONVERGED!

[ Info: The problem is converged
[ Info: Here is the result
[ Info: x2 = 16.666666666666664
[ Info: x1 = 66.66666666666667
[ Info: Objective value: 183.33333333333334

```
