module Blosc2
include("Lib/lib.jl")
include("common/common.jl")
include("compression/compression.jl")
include("init.jl")
export CompressionParams, DecompressionParams, Context, CompressionContext, DecompressionContext
export compress!, compress, unsafe_compress!, decompress!, decompress, unsafe_decompress!, decompress_items!
export sizes, uncompressed_sizeof, uncompressed_length, compressed_sizeof, max_compressed_size, make_compress_buffer
export filter_pipeline, has_filter, available_filter_names, filter_description, max_filters_count
end # module
