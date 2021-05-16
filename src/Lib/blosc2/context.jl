"""
    blosc2_context

Context opaque object
"""
mutable struct blosc2_context
end


const FiltersTuple = NTuple{BLOSC2_MAX_FILTERS, UInt8}

"""
    blosc2_cparams

The parameters for creating a context for compression purposes.

In parenthesis it is shown the default value used internally when a 0
(zero) in the fields of the struct is passed to a function.

preffiler must match blosc2_prefilter_fn defenition:
typedef int (*blosc2_prefilter_fn)(blosc2_prefilter_params* params);
"""
struct blosc2_cparams

  compcode::UInt8 #!< The compressor codec.
  compcode_meta::UInt8 #!< The metadata for the compressor codec.
  clevel::UInt8 #!< The compression level (5).
  use_dict::Cint #!< Use dicts or not when compressing (only for ZSTD).
  typesize ::Int32 #!< The type size (8).
  nthreads ::Int16 #!< The number of threads to use internally (1).
  blocksize ::Int32 #!< The requested size of the compressed blocks (0; meaning automatic).
  splitmode ::Int32 #!< Whether the blocks should be split or not.
  schunk ::Ref{Cvoid} #!< The associated schunk, if any (NULL).
  filters ::FiltersTuple #!< The (sequence of) filters.
  filters_meta ::FiltersTuple #!< The metadata for filters.
  preffiler ::Ptr{Cvoid} #!< The prefilter function.
  preparams ::Ptr{Cvoid} #!< The prefilter parameters. (blosc2_prefilter_params)
  udbtune ::Ptr{Cvoid}#!< The user-defined BTune parameters. (blosc2_btune)

  function blosc2_cparams(;compcode = BLOSC_BLOSCLZ,
      compcode_meta = 0,
      clevel =5,
      use_dict =0,
      typesize = 8,
      nthreads = 1,
      blocksize =0,
      splitmode = BLOSC_FORWARD_COMPAT_SPLIT,
      schunk = C_NULL,
      filters = FiltersTuple([0, 0, 0, 0, 0, UInt8(BLOSC_SHUFFLE)]),
      filters_meta = FiltersTuple([0, 0, 0, 0, 0, 0])
    )
        new(
            UInt8(compcode),
            compcode_meta,
            clevel,
            use_dict,
            typesize,
            nthreads,
            blocksize,
            UInt8(splitmode),
            schunk,
            filters,
            filters_meta,
            C_NULL,
            C_NULL,
            C_NULL
        )
  end
end

"""
    blosc2_dparams

The parameters for creating a context for decompression purposes.
In parenthesis it is shown the default value used internally when a 0
(zero) in the fields of the struct is passed to a function.
"""
struct blosc2_dparams
  nthreads ::Cint #!< The number of threads to use internally (1).
  schunk ::Ptr{Cvoid} #!< The associated schunk, if any (NULL).
  postfilter ::Ptr{Cvoid} #!< The postfilter function.
  postparams ::Ptr{Cvoid} #!< The postfilter parameters.
  function blosc2_dparams(;
    nthreads = 1,
    schunk = C_NULL
  )
    new(nthreads, schunk, C_NULL, C_NULL)
  end
end

"""
    blosc2_create_cctx(cparams::blosc2_cparams = blosc2_cparams())

Create a context for *_ctx() compression functions.

# Returns

A pointer to the new context. NULL is returned if this fails.
"""
function blosc2_create_cctx(cparams::blosc2_cparams = blosc2_cparams())
    return @ccall lib.blosc2_create_cctx(cparams::blosc2_cparams)::Ptr{blosc2_context}
end

"""
    blosc2_create_dctx(dparams::blosc2_dparams = blosc2_dparams())


Create a context for *_ctx() decompression functions.

# Returns

A pointer to the new context. NULL is returned if this fails.
"""
function blosc2_create_dctx(dparams::blosc2_dparams = blosc2_dparams())
    return @ccall lib.blosc2_create_dctx(dparams::blosc2_dparams)::Ptr{blosc2_context}
end

"""
    blosc2_free_ctx(context::Ptr{blosc2_context})

Free the resources associated with a context.
"""
function blosc2_free_ctx(context::Ptr{blosc2_context})
    @ccall lib.blosc2_free_ctx(context::Ptr{blosc2_context})::Cvoid
end

"""
    blosc2_compress_ctx(ctx::Ptr{blosc2_context}, src, srcsize, dest, destsize)

Context interface to Blosc compression.

This does not require a call to blosc_init and can be called from multithreaded applications without the global lock being used, so allowing Blosc be executed simultaneously in those scenarios.

# Parameters

- `context` – A blosc2_context struct with the different compression params.

- `src` – The buffer containing the data to be compressed.

- `srcsize` – The number of bytes to be compressed from the src buffer.

- `dest` – The buffer where the compressed data will be put.

- `destsize` – The size in bytes of the dest buffer.

Returns
The number of bytes compressed. If src buffer cannot be compressed into destsize, the return value is zero and you should discard the contents of the dest buffer. A negative return value means that an internal error happened. It could happen that context is not meant for compression (which is stated in stderr). Otherwise, please report it back together with the buffer data causing this and compression settings.

"""

function blosc2_compress_ctx(ctx::Ptr{blosc2_context}, src, srcsize, dest, destsize)
    @ccall lib.blosc2_compress_ctx(
            ctx::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32,  dest::Ptr{Cvoid}, destsize::Int32
        )::Cint
end

"""
    blosc2_decompress_ctx(ctx::Ptr{blosc2_context}, src, srcsize, dest, destsize)s

Context interface counterpart for blosc_getitem.

It uses many of the same parameters as blosc_getitem() function with a few additions.

# Returns
The number of bytes copied to dest or a negative value if some error happens.

"""
function blosc2_decompress_ctx(ctx::Ptr{blosc2_context}, src, srcsize, dest, destsize)
    @ccall lib.blosc2_decompress_ctx(
            ctx::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32,  dest::Ptr{Cvoid}, destsize::Int32
        )::Cint
end

function blosc2_getitem_ctx(ctx::Ptr{blosc2_context}, src, srcsize, start, nitems, dest, destsize)
    @ccall lib.blosc2_getitem_ctx(
            ctx::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32,  start::Cint, nitems::Cint, dest::Ptr{Cvoid}, destsize::Int32
        )::Cint
end


"""
    blosc2_set_maskout(ctx::Ptr{blosc2_context}, maskout, nblocks)

Set a maskout so as to avoid decompressing specified blocks.

# Remark

The maskout is valid for contexts only meant for decompressing a chunk via `blosc2_decompress_ctx`.
Once a call to `blosc2_decompress_ctx` is done, this mask is reset so that next call to `blosc2_decompress_ctx` will decompress the whole chunk.

# Parameters

- `ctx` – The decompression context to update.

- `maskout` – The boolean mask for the blocks where decompression is to be avoided.

- `nblocks` – The number of blocks in maskout above.

Returns
If success, a 0 values is returned. An error is signaled with a negative int.

"""
function blosc2_set_maskout(ctx::Ptr{blosc2_context}, maskout::DenseArray{Bool}, nblocks)
    @ccall lib.blosc2_set_maskout(ctx::Ptr{blosc2_context}, maskout::Ptr{Bool}, nblocks::Cint)::Cint
end
#=
int blosc2_set_maskout(blosc2_context *ctx, bool *maskout, int nblocks)
Set a maskout so as to avoid decompressing specified blocks.

Remark
The maskout is valid for contexts only meant for decompressing a chunk via blosc2_decompress_ctx. Once a call to blosc2_decompress_ctx is done, this mask is reset so that next call to blosc2_decompress_ctx will decompress the whole chunk.

Parameters
ctx – The decompression context to update.

maskout – The boolean mask for the blocks where decompression is to be avoided.

nblocks – The number of blocks in maskout above.

Returns
If success, a 0 values is returned. An error is signaled with a negative int.
=#
#=
"""
    blosc2_ctx_get_cparams(ctx::Ptr{blosc2_context})

Create a cparams associated to a context.

# Returns

`blosc2_cparams` if succeeds. Else `nothing`
"""
function blosc2_ctx_get_cparams(ctx::Ptr{blosc2_context})
    cparams = Ref{blosc2_cparams}()

    r = @ccall lib.blosc2_ctx_get_cparams(ctx::Ptr{blosc2_context}, cparams::Ptr{blosc2_cparams})::Cint

    (r < 0 || cparams[] == C_NULL) && return nothing
    return cparams[]
end
"""
    blosc2_ctx_get_dparams(ctx::Ptr{blosc2_context})

Create a dparams associated to a context.

# Returns

`blosc2_cdarams` if succeeds. Else `nothing`
"""
function blosc2_ctx_get_dparams(ctx::Ptr{blosc2_context})
    dparams = Ref{blosc2_dparams}()

    r = @ccall lib.blosc2_ctx_get_dparams(ctx::Ptr{blosc2_context}, dparams::Ptr{blosc2_dparams})::Cint

    (r < 0 || cparams[] == C_NULL) && return nothing
    return dparams[]
end=#