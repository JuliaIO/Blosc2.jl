# Blosc2.jl Main API

## Compressors

```@docs
Compressor
available_compressors
available_compressors_names
has_compressor
compressor_by_name
default_compressor
default_compressor_name
```

## Filters

```@docs
has_filter
available_filter_names
filter_description
filter_pipeline
```

## Utilites

```@docs
sizes
uncompressed_sizeof
uncompressed_length
compressed_sizeof
```

## API for compression/decompression


```@docs
CompressionParams
DecompressionParams
Context
CompressionContext
DecompressionContext
max_compression_overhead
max_compressed_size
make_compress_buffer
unsafe_compress!
compress!
compress
unsafe_decompress!
decompress!
decompress
decompress_items!
```