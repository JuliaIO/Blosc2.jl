"""
    Lib

Low-level blosc api - wrappers under corresponding c functions
"""
module Lib
    using Blosc2_jll
    const lib = libblosc2
    include("defines.jl")
    include("blosc1/blosc1.jl")
    include("blosc2/blosc2.jl")
end