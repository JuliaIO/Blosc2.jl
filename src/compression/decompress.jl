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
    decompress!([ctx = DecompressionContext(;kwargs...)], dest::Vector{T}, src::Vector{UInt8}, dest_offset = 1, src_offset = 1; kwargs...)

Decompress data from buffer `src` at offset `src_offset` (1-indexed) into vector `dest` at offset `dest_offset` (1-indexed).
Return count of the elements written to `dest`
"""
function decompress!(ctx::DecompressionContext, dest::Vector{T},  src::Vector{UInt8}, dest_offset = 1, src_offset = 1) where {T}
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

decompress!(dest::Vector{T}, src::Vector{UInt8}, dest_offset = 1, src_offset = 1;kwargs...) where {T} =
        decompress!(DecompressionContext(;kwargs...), dest, src, dest_offset, src_offset)

"""
    decompress([ctx = DecompressionContext(kwargs...)], ::Type{T}, src::Array{UInt8}, [src_offset = 1]; kwargs...)::Vector{T}

Return `Vector{T}` consisting of decompression data from `src` starting at `src_offset` using context `ctx`
"""
function decompress(ctx::DecompressionContext, ::Type{T}, src::Array{UInt8}, src_offset = 1) where {T}
    result = Vector{T}(undef, uncompressed_length(T, src))
    @inbounds r = decompress!(ctx, result, src, 1, src_offset)
    r < 0 && error("Decompression error. Error code: $r")
    return result
end
decompress(::Type{T}, src::Array{UInt8}, src_offset = 1; kwargs...) where {T} = decompress(DecompressionContext(;kwargs...), T, src, src_offset)





"""
    decompress_items!(ctx::DecompressionContext, dest::Vector{T},  src::Vector{UInt8}, range::UnitRange{<:Integer}, dest_offset, src_offset)

Decompress items in `range` from buffer `src` at offset `src_offset` (1-indexed) into vector `dest` at offset `dest_offset` (1-indexed).
Return count of the elements written to `dest`
"""
function decompress_items!(ctx::DecompressionContext, dest::Vector{T},
            src::Vector{UInt8}, range::UnitRange{<:Integer}, dest_offset = 1, src_offset = 1) where {T}

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

decompress_items!(dest::Vector{T}, src::Vector{UInt8}, range::UnitRange{<:Integer}, dest_offset = 1, src_offset = 1; kwargs...) where {T} =
            decompress_items!(DecompressionContext(;kwargs...), dest, src, range, dest_offset, src_offset)