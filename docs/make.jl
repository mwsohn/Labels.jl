push!(LOAD_PATH,"../src/")

using Labels2

using Documenter

makedocs(
    sitename = "Labels2.jl",
    modules  = [Labels2],
    pages    = [
        "Home" => "index.md"
    ]
)

deploydocs(;
    repo = "github.com/mwsohn/Labels2.jl"
)
