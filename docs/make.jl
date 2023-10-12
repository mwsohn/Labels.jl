push!(LOAD_PATH,"../src/")

using Labels

using Documenter

makedocs(
    sitename = "Labels.jl",
    modules  = [Labels],
    pages    = [
        "Home" => "index.md"
    ]
)

deploydocs(;
    repo = "github.com/mwsohn/Labels.jl"
)
