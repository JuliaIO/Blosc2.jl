"""
    Storage

This struct is meant for holding storage parameters for a for a blosc2 container, allowing to specify,
for example, how to interpret the contents included in the schunk.
"""
struct Storage
    contiguous ::Bool
    urlpath ::Union{String, Nothing}
    cparams ::Union{CompressionParams, Nothing}
    dparams ::Union{DecompressionParams, Nothing}
end


 """
    Storage(;
        contiguous = false, urlpath::Union{AbstractString, Nothing} = nothing,
        cparams::Union{CompressionParams, Nothing} = nothing ,
        dparams::Union{DecompressionParams, Nothing} = nothing)

Create `Storage` struct

# Arguments

    - `contiguous` - Whether the chunks are contiguous or sparse.

    - `urlpath` - The path for persistent storage. If `nothing`, that means in-memory.

    - `cparams` - The compression params when creating a schunk.
    If `nothing`, sensible defaults are used depending on the context.

    - `dparams` - The compression params when creating a schunk.
    If `nothing`, sensible defaults are used depending on the context.
"""
function Storage(;
    contiguous = false, urlpath::Union{AbstractString, Nothing} = nothing,
    cparams::Union{CompressionParams, Nothing} = nothing ,
    dparams::Union{DecompressionParams, Nothing} = nothing)
    Storage(contiguous, urlpath, cparams, dparams)
end

function with_preserved_blosc2_storage(f, s::Storage)
    r_cparams = isnothing(s.cparams) ? nothing : Ref(make_cparams(s.cparams))
    r_dparams = isnothing(s.dparams) ? nothing : Ref(make_dparams(s.dparams))
    GC.@preserve s r_cparams r_dparams begin
        bstorage = Lib.blosc2_storage(
            s.contiguous,
            isnothing(s.urlpath) ? C_NULL : Base.unsafe_convert(Cstring, s.urlpath),
            isnothing(r_cparams) ? C_NULL : Base.unsafe_convert(Ptr{Lib.blosc2_cparams}, r_cparams),
            isnothing(r_dparams) ? C_NULL : Base.unsafe_convert(Ptr{Lib.blosc2_dparams}, r_dparams),
            C_NULL
        )
        f(bstorage)
    end
end
