"""
    Lib

Low-level blosc api - wrappers under corresponding c functions
"""
module Lib
    using Blosc2_jll
    include("generated.jl")
    include("helpers.jl")
end