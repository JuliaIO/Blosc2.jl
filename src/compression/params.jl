abstract type Params end;

"""
    CompressionParams

Compression params

    CompressionParams(;
        compressor ::Symbol = default_compressor_name()
        level ::UInt8 = 5
        typesize ::Int32 = 8
        nthreads ::Int16 = 1
        blocksize ::Int32 = 0
        splitmode ::Bool = false
        filter_pipeline ::FilterPipeline = filter_pipeline(:shuffle)
    )

Create compression parameters

# Arguments

- `compressor::Symbol` - The name of compressor to use
- `level` - The compression level from 0 (no compression) to 9 (maximum compression)
- `typesize` - The size of type being compressed
- `nthreads` - The number of threads to use internally
- `blocksize` - The requested size of the compressed blocks (0 means auto)
- `splitmode` - Whether the blocks should be split or not.
- `filter_pipeline` - Filters pipeline
"""
struct CompressionParams <: Params
    compressor ::Compressor
    level ::UInt8
    typesize ::Int32
    nthreads ::Int16
    blocksize ::Int32
    splitmode ::Bool
    filter_pipeline ::FilterPipeline
    function CompressionParams(;
        compressor ::Symbol = default_compressor_name(),
        level = 5,
        typesize = 8,
        nthreads = 1,
        blocksize = 0,
        splitmode = false,
        filter_pipeline = filter_pipeline(:shuffle)
    )
        !(level in 0:9) && throw(ArgumentError("level must be in 0:9 range"))
        return new(
            compressor_by_name(compressor),
            level,
            typesize,
            nthreads,
            blocksize,
            splitmode,
            filter_pipeline
            )
    end
end

"""
    CompressionParams(::Type{T}; kwargs...)

Create `CompressionParams` for compressing vectors with element type `T`.
This is equivalent to `CompressionParams(;typesize = sizeof(T), kwargs...)`
"""
function CompressionParams(::Type{T}; kwargs...) where {T}
    return CompressionParams(;
        typesize = sizeof(T),
        kwargs...
    )
end


function make_cparams(p::CompressionParams)
    return Lib.blosc2_cparams(
        compcode = p.compressor.code,
        clevel = p.level,
        typesize = p.typesize,
        nthreads = p.nthreads,
        blocksize = p.blocksize,
        splitmode = p.splitmode ? 1 : 0,
        filters = getproperty.(p.filter_pipeline.filters, :id),
        filters_meta = getproperty.(p.filter_pipeline.filters, :meta)
    )
end

"""
    DecompressionParams

Decompression params

    DecomplessionParams(;nthreads = 1)

Create decompression parameters
"""
struct DecompressionParams <: Params
    nthreads ::Cint
    function DecompressionParams(;nthreads = 1)
        new(nthreads)
    end
end

function make_dparams(p::DecompressionParams)
    return Lib.blosc2_dparams(
        nthreads = p.nthreads
    )
end