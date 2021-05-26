"""
    Context{T <: Params}
    CompressionContext = Context{CompressionParams}
    DecompressionContext = Context{DecompressionParams}

# Constructors

## Context(params::T) where {T <: Params}

Create context.
- If `params` is `CompressionParams` then this is `CompressionContext`
- If `params` is `DecompressionParams` then this is `DecompressionContext`


## CompressionContext(params = CompressionParams())

Create compression context

## DecompressionContext(params = DecompressionParams())

Create decompression context
"""
mutable struct Context{T <: Params}
    params ::T
    context ::Ptr{Lib.blosc2_context}
    function Context(params::T) where {T <: Params}
        result = new{T}(params, _create_context(params))
        finalizer(result) do c
            Lib.blosc2_free_ctx(c.context)
        end
    end
    Context{T}(params::T = T()) where {T <: Params} = Context(params)
end

const CompressionContext = Context{CompressionParams}
const DecompressionContext = Context{DecompressionParams}

_create_context(params::CompressionParams) = Lib.blosc2_create_cctx(make_cparams(params))
_create_context(params::DecompressionParams) = Lib.blosc2_create_dctx(make_dparams(params))