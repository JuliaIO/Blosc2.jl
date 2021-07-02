mutable struct Chunk{T, MaxSize, TypeSize}
    csize ::Int64
    nsize ::Int64
    buff ::Vector{UInt8}
end