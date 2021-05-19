"""
    CompressionParams

Compression params

TODO filters support
"""
struct CompressionParams
    compressor ::Compressor
    level ::UInt8
    typesize ::Int32
    nthreads ::Int32
    blocksize ::Int32
    splitmode ::Bool
    """
        CompressionParams(;
                compressor ::Compressor = default_compressor()
                level ::UInt8 = 5
                typesize ::Int32 = 8
                nthreads ::Int32 = 1
                blocksize ::Int32 = 0
            )

    Create compression parameters

    # Arguments

    - `compressor` - The compressor to use
    - `level` - The compression level from 0 (no compression) to 9 (maximum compression)
    - `typesize` - The size of type being compressed
    - `nthreads` - The number of threads to use internally
    - `blocksize` - The requested size of the compressed blocks (0 means auto)
    - `splitmode` - Whether the blocks should be split or not.

    """
    function CompressionParams(;
        compressor ::Compressor = default_compressor(),
        level = 5,
        typesize = 8,
        nthreads = 1,
        blocksize = 0,
        splitmode = false
    )
        !(level in 0:9) && throw(ArgumentError("level must be in 0:9 range"))
        return new(
            compressor,
            level,
            typesize,
            nthreads,
            blocksize,
            splitmode
            )
    end
end

"""
    CompressionParams([cname = default_compressor_name()], ::Type{T}; kwargs...)

    Create compression parameters for compression array of type `T` with compressor name `cname`
"""
function CompressionParams(cname::Symbol, ::Type{T}; kwargs...) where {T}
    !isbitstype(T) && throw(ArgumentError("Only bits types can be compressed directly"))
    return CompressionParams(;
        compressor = compressor(cname),
        typesize = sizeof(T),
        kwargs...
    )
end
CompressionParams(::Type{T}; kwargs...) where {T} = CompressionParams(default_compressor_name(), T; kwargs...)


function make_cparams(p::CompressionParams)
    return Lib.blosc2_cparams(
        compcode = p.compressor.code,
        clevel = p.level,
        typesize = p.typesize,
        nthreads = p.nthreads,
        blocksize = p.blocksize,
        splitmode = p.splitmode ? 1 : 0
    )
end