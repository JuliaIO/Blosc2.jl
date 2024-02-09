module Blosc2
include("lib/lib.jl")
include("common/common.jl")
include("compression/compression.jl")
include("superchunks/superchunks.jl")
include("init.jl")
export Compressor, available_compressors, available_compressors_names, has_compressor, max_compression_overhead
export compressor_by_name, default_compressor_name, default_compressor
export CompressionParams, DecompressionParams, Context, CompressionContext, DecompressionContext
export compress!, compress, unsafe_compress!, decompress!, decompress, unsafe_decompress!, decompress_items!
export sizes, uncompressed_sizeof, uncompressed_length, compressed_sizeof, max_compressed_size, make_compress_buffer
export filter_pipeline, has_filter, available_filter_names, filter_description, max_filters_count
export Storage, SChunk
export clevel, typesize, chunksize, blocksize, nchunks, nbytes, cbytes
export unsafe_append_buffer!, unsafe_decompress_chunk, unsafe_append_chunk!, unsafe_update_chunk!, unsafe_insert_chunk!, unsafe_get_chunk
export delete_chunk!
end # module
