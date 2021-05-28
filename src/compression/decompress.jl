"""
    decompress!([ctx = DecompressionContext(;kwargs...)], dest::Array{T}, src::Vector{UInt8}; kwargs...)

Decompress `src` vector into `dest` buffer using context `ctx`.
There should be enough space in the `dest` to accommodate the decompressed array.
Return count of the elements written to dest
"""
function decompress!(ctx::DecompressionContext, dest::Array{T}, src::Vector{UInt8}) where {T}
    !isbitstype(T) && throw(ArgumentError("Only Bits Types can be decompressed"))
    @boundscheck checkbounds(dest, 1:uncompressed_length(T, src))
    result = Lib.blosc2_decompress_ctx(ctx.context, src, sizeof(src), dest, sizeof(dest))
    result < 0 && error("Decompression error. Error code: $result")
    return ceil(Int64, result / sizeof(T))
end

decompress!(dest::Array{T}, src::Vector{UInt8}; kwargs...) where {T} =
    decompress!(DecompressionContext(DecompressionParams(;kwargs...)), dest, src)

"""
    decompress([ctx = DecompressionContext(kwargs...)], ::Type{T}, src::Array{UInt8}; kwargs...)::Vector{T}

Return `Vector{T}` consisting of decompression data from `src` using context `ctx`
"""
function decompress(ctx::DecompressionContext, ::Type{T}, src::Array{UInt8}) where {T}
    result = Vector{T}(undef, uncompressed_length(T, src))
    @inbounds r = decompress!(ctx, result, src)
    r < 0 && error("Decompression error. Error code: $r")
    return result
end
decompress(::Type{T}, src::Array{UInt8}; kwargs...) where {T} = decompress(DecompressionContext(;kwargs...), T, src)


"""
    unsafe_decompress!([ctx = DecompressionContext(;kwargs...)], dest::Ptr{T}, dest_size, src::Ptr{UInt8}, src_size; kwargs...)

Decompress data from `src` buffer, into `dest` buffer using context `ctx` with no checks, return count of elements written to dest or negative value if an error.
`dest_size` and `src_size` are the byte sizes of buffers `dest` and `src` respectively

Return count of the elements written to dest

The `unsafe` prefix on this function indicates that no validation is performed on the pointers dest and src to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_decompress!(ctx::DecompressionContext, dest::Ptr{T}, dest_size, src::Ptr{UInt8}, src_size) where {T}
    res = Lib.blosc2_decompress_ctx(ctx.context, src, src_size, dest, dest_size)
    return res >= 0 ?
    ceil(Int64, res / sizeof(T)) :
    res
end

unsafe_decompress!(dest::Ptr{T}, dest_size, src::Ptr{UInt8}, src_size; kwargs...) where {T} =
    unsafe_decompress!(DecompressionContext(;kwargs...), dest, dest_size, src, src_size)


"""
    decompress!([ctx = DecompressionContext(;kwargs...)], dest::Vector{T}, dest_offset, src::Vector{UInt8}, src_offset; kwargs...)

Decompress data from buffer `src` at offset `src_offset` (1-indexed) into vector `dest` at offset `dest_offset` (1-indexed).
Return count of the elements written to `dest`
"""
function decompress!(ctx::DecompressionContext, dest::Vector{T}, dest_offset, src::Vector{UInt8}, src_offset) where {T}
    @boundscheck begin
        ulen = uncompressed_length(T, src, src_offset)
        checkbounds(dest, dest_offset:dest_offset + ulen - 1)
    end
    src_size = length(src) - src_offset + 1
    dest_size = (length(dest) - dest_offset + 1) * sizeof(T)
    result = GC.@preserve dest src begin
        unsafe_decompress!(ctx, pointer(dest, dest_offset), dest_size, pointer(src, src_offset), src_size)
    end
    result < 0 && error("Decompression error. Error code: $result")
    return  result
end

decompress!(dest::Vector{T}, dest_offset, src::Vector{UInt8}, src_offset;kwargs...) where {T} =
        decompress!(DecompressionContext(;kwargs...), dest, dest_offset, src, src_offset)

"""
    decompress_items!(ctx::DecompressionContext, dest::Vector{T}, dest_offset,  src::Vector{UInt8}, src_offset, range::UnitRange{<:Integer})

Decompress items in `range` from buffer `src` at offset `src_offset` (1-indexed) into vector `dest` at offset `dest_offset` (1-indexed).
Return count of the elements written to `dest`
"""
function decompress_items!(ctx::DecompressionContext, dest::Vector{T}, dest_offset,
            src::Vector{UInt8}, src_offset, range::UnitRange{<:Integer}) where {T}

    @boundscheck begin
        checkbounds(src, src_offset)
        checkbounds(dest, dest_offset:dest_offset + length(range) - 1)
    end
    src_size = length(src) - src_offset + 1
    dest_size = (length(dest) - dest_offset + 1) * sizeof(T)

    result = GC.@preserve dest src begin
        Lib.blosc2_getitem_ctx(ctx.context,
            pointer(src, src_offset), src_size,
            first(range) - 1, length(range),
            pointer(dest, dest_offset), dest_size
        )
    end
    result < 0 && error("Decompression error. Error code: $result")
    return ceil(Int, result / sizeof(T))
end

decompress_items!(dest::Vector{T}, dest_offset, src::Vector{UInt8}, src_offset, range::UnitRange{<:Integer}; kwargs...) where {T} =
            decompress_items!(DecompressionContext(;kwargs...), dest, dest_offset, src, src_offset, range)