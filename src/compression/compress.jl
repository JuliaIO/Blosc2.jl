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
    compress!(ctx::CompressionContext, dest::Vector{UInt8}, src::Array)

Compress `src` vector into dest buffer, return size of the data written to dest
"""
function compress!(ctx::CompressionContext, dest::Vector{UInt8}, src::Array{T}) where {T}
    !isbitstype(T) && error("Only Bits Types can be compressed")
    result = Lib.blosc2_compress_ctx(ctx.context, src, sizeof(src), dest, sizeof(dest))
    result < 0 && error("Compression error. Error code: $result")
    return result
end

"""
    decompress!(ctx::DecompressionContext, dest::Array{T}, src::Vector{UInt8}

Decompress `src` vector into dest buffer, return count of the elements written to dest
"""
function decompress!(ctx::DecompressionContext, dest::Array{T}, src::Vector{UInt8}) where {T}
    !isbitstype(T) && error("Only Bits Types can be decompressed")
    result = Lib.blosc2_decompress_ctx(ctx.context, src, sizeof(src), dest, sizeof(dest))
    result < 0 && error("Decompression error. Error code: $result")
    return result / sizeof(T)
end