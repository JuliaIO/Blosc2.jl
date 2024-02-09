using Documenter
using Blosc2

DocMeta.setdocmeta!(Blosc2, :DocTestSetup, :(using Blosc2); recursive=true)

makedocs(
    modules = [Blosc2],
    authors="JuliaIO Contributors",
    sitename = "Blosc2.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mkitti.github.io/Blosc2.jl",
        edit_link="main",
        assets=String[],
    ),
    pages = Any[
        "Introduction" => "index.md",
        "API" => [
            "Main API" => "api.md",
            "Low-level API" => "lib.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/waralex/Blosc2.jl.git",
    target = "build",
    devbranch="main",
)
