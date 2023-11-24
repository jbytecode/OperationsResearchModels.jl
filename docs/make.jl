using Documenter, OperationsResearchModels

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        collapselevel = 2,
        # assets = ["assets/favicon.ico", "assets/extra_styles.css"],
    ),
    sitename = "OperationsResearchModels.jl",
    authors = "Mehmet Hakan Satman",
    pages = ["Algorithms" => "algorithms.md"],
)


deploydocs(repo = "github.com/jbytecode/OperationsResearchModels.jl")
