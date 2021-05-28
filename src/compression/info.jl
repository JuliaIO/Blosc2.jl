function unsafe_sizes(buff::Ptr{UInt8})
    r = Lib.blosc_cbuffer_sizes(buff)
    return (r.nbytes, r.cbytes)
end

"""
    sizes(buff::Vector{UInt8}, offset = 1)

Get information about a compressed buffer at offset `offset` (1-indexed), as Tuple with values:

- the number of uncompressed bytes

- the number of compressed bytes
"""
function sizes(buff::Vector{UInt8}, offset = 1)
    @boundscheck checkbounds(buff, offset)
    r = GC.@preserve buff Lib.blosc_cbuffer_sizes(pointer(buff, offset))
    return (r.nbytes, r.cbytes)
end


"""
    uncompressed_sizof(buff::Vector{UInt8}, offset = 1)

Uncompressed size of data in buffer `buff` in bytes`
"""
Base.@propagate_inbounds uncompressed_sizeof(buff::Vector{UInt8}, offset = 1) = sizes(buff)[1]

"""
    uncompressed_length(::Type{T}, buff::Vector{UInt8}, offset = 1)

Uncompressed length of `Vector{T}` then decompressed from buffer `buff`
"""
Base.@propagate_inbounds uncompressed_length(::Type{T},buff::Vector{UInt8}, offset = 1) where {T} = ceil(Int, sizes(buff)[1] / sizeof(T))

"""
    compressed_sizeof(buff::Vector{UInt8}, offset = 1)

Compressed size of data in buffer `buff` in bytes
"""
Base.@propagate_inbounds compressed_sizeof(buff::Vector{UInt8}, offset = 1) = sizes(buff)[2]