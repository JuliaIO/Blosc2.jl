module Blosc2
include("Lib/lib.jl")
include("common/common.jl")
include("compression/compression.jl")
export CompressionParams, DecompressionParams, Context, CompressionContext, DecompressionContext,
compress!, compress, unsafe_compress!, decompress!, decompress, unsafe_decompress!, decompress_items!,
sizes, uncompressed_sizeof, uncompressed_length, compressed_sizeof, max_compressed_size, make_compress_buffer
end # module
