using Documenter, OperationsResearchModels
using Ipopt

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        collapselevel = 2,
        # assets = ["assets/favicon.ico", "assets/extra_styles.css"],
    ),
    sitename = "OperationsResearchModels.jl",
    authors = "Mehmet Hakan Satman",
    pages = [
        "Knapsack" => "knapsack.md",
        "Assignment" => "assignment.md",
        "Transportation" => "transportation.md",
        "Network" => "network.md",
        "Project Analysis" => "project.md",
        "Location Selection" => "locationselection.md",
        "Traveling Salesman" => "travelingsalesman.md",
        "Scheduling" => "scheduling.md",
        "The Simplex Method" => "simplex.md",
        "Zero-sum Games" => "game.md",
        "Portfolio Optimization" => "portfolio.md",
        ],
)


deploydocs(repo = "github.com/jbytecode/OperationsResearchModels.jl")
