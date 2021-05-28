using Documenter
using Blosc2

makedocs(
    sitename = "Blosc2.jl",
    format = Documenter.HTML(),
    modules = [Blosc2],
    pages = Any[
        "Introduction" => "index.md",
        "API" => [
            "Main API" => "api.md"
            "Low Level API" => "lib.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/waralex/Blosc2.jl.git",
    target = "build"
)
