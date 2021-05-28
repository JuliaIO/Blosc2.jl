"""
    max_compression_overhead()

The maximum overhead during compression in bytes.
"""

max_compression_overhead() = Lib.BLOSC_MAX_OVERHEAD

"""
    max_compressed_size(src)

The maximum size after compression in bytes.
"""
max_compressed_size(src) = sizeof(src) + max_compression_overhead()

"""
    max_compress_buffer(src)

Creates a buffer that is guaranteed to contain compressed data
"""
make_compress_buffer(src) = Vector{UInt8}(undef, max_compressed_size(src))

"""
    unsafe_compress!([ctx = CompressionContext(T; kwargs...)], dest::Ptr{T}, dest_size, src::Ptr{T}, src_size; kwargs...)

Compress `src_size` bytes from `src` buffer, into `dest` buffer (with `dest_size` bytes size) using context `ctx` with no checks, return size of the data written to dest

The `unsafe` prefix on this function indicates that no validation is performed on the pointers dest and src to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_compress!(ctx::CompressionContext, dest::Ptr{UInt8}, dest_size, src::Ptr{T}, src_size) where {T}
    return Lib.blosc2_compress_ctx(ctx.context, src, src_size, dest, dest_size)
end

unsafe_compress!(dest::Ptr{UInt8}, dest_size, src::Ptr{T}, src_size; kwargs...) where {T} =
    unsafe_compress!(CompressionContext(T; kwargs...), dest, dest_size, src, src_size)



"""
    compress!([ctx = CompressionContext(T; kwargs...)],
         dest::Vector{UInt8}, src::Vector{T},
         [dest_offset = 1], [src_range = 1:length(src)]
        ; kwargs...
        )

Compress elements from  `src_range` of `src` into `dest` buffer starting from `dest_offset` (1-indexed) using context `ctx`
Return size of the data written to dest
"""
function compress!(ctx::CompressionContext, dest::Vector{UInt8}, src::Vector{T}, dest_offset = 1,  src_range::UnitRange{<:Integer} = 1:length(src)) where {T}
    @boundscheck begin
        checkbounds(dest, dest_offset)
        checkbounds(src, src_range)
    end
    dest_size = length(dest) - dest_offset + 1
    src_size = length(src_range) * sizeof(T)
    result = GC.@preserve dest src begin
        unsafe_compress!(ctx, pointer(dest, dest_offset), dest_size, pointer(src, first(src_range)), src_size)
    end
    result < 0 && error("Compression error. Error code: $result")
    return result
end

compress!(dest::Vector{UInt8}, src::Vector{T}, dest_offset = 1,  src_range::UnitRange{<:Integer} = 1:length(src); kwargs...) where {T} =
    compress!(CompressionContext(T; kwargs...), dest, src, dest_offset, src_range)


"""
    compress([ctx = CompressionContext(T; kwargs...)], src::Array{T}, [src_range = 1:length(src)]; kwargs...)::Vector{UInt8}

Return `Vector{UInt8}` consisting of `src_range` of `src` in compressed form using context `ctx`
"""
function compress(ctx::CompressionContext, src::Array{T}, src_range::UnitRange{<:Integer} = 1:length(src)) where {T}
    buffer = make_compress_buffer(src)
    sz = compress!(ctx, buffer, src, 1, src_range)
    resize!(buffer, sz)
    return buffer
end
compress(src::Array{T}, src_range::UnitRange{<:Integer} = 1:length(src); kwargs...) where {T} = compress(CompressionContext(T; kwargs...), src, src_range)

