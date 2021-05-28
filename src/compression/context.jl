"""
    Context{T <: Params}
    CompressionContext = Context{CompressionParams}
    DecompressionContext = Context{DecompressionParams}

# Constructors

    Context{T}(params::T) where {T <: Params}

Create context.
- If `params` is `CompressionParams` then this is `CompressionContext`
- If `params` is `DecompressionParams` then this is `DecompressionContext`


    CompressionContext(;kwargs...)

Create compression context `kwargs` passed to CompressionParams constructor

    DecompressionContext(;kwargs...)

Create decompression context `kwargs` passed od DecompressionParams consturctor
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
    Context{T}(params::T) where {T <: Params} = Context(params)
    Context{T}(;kwargs...) where {T <: Params} = Context(T(;kwargs...))
end

const CompressionContext = Context{CompressionParams}
const DecompressionContext = Context{DecompressionParams}

"""
    CompressionContext(::Type{T}; kwargs...)

Create `CompressionContext` for compressing vectors with element type `T`.
This is equivalent to `CompressionContext(CompressionParams(T; kwargs...))``
"""
CompressionContext(::Type{T}; kwargs...) where {T} = CompressionContext(CompressionParams(T; kwargs...))

_create_context(params::CompressionParams) = Lib.blosc2_create_cctx(make_cparams(params))
_create_context(params::DecompressionParams) = Lib.blosc2_create_dctx(make_dparams(params))