"""
    Lib

Low-level blosc api - wrappers under corresponding c functions
"""
module Lib
    using Blosc2_jll
    const lib = blosc
    include("defines.jl")
    include("blosc1/blosc1.jl")
end