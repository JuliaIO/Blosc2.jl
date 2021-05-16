#Blosc1 low-level main API https://c-blosc2.readthedocs.io/en/latest/reference/blosc1.html#main-api

"""
    blosc_init()

Initialize the Blosc library environment.

You must call this previous to any other Blosc call, unless you want Blosc to be used simultaneously in a multi-threaded environment, in which case you can use the blosc2_compress_ctx blosc2_decompress_ctx pair.
"""
blosc_init() = @ccall lib.blosc_init()::Cvoid
"""
    blosc_destroy()

Destroy the Blosc library environment.

You must call this after to you are done with all the Blosc calls, unless you have not used blosc_init() before.
"""
blosc_destroy() = @ccall lib.blosc_destroy()::Cvoid

"""
    blosc_compress(level, shuffle, itemsize, srcsize, src, dest, destsize)

Compress a block of data in the src buffer and returns the size of compressed block.

C signature: `int blosc_compress(int clevel, int doshuffle, size_t typesize, size_t nbytes, const void *src, void *dest, size_t destsize)``

# Arguments

- `clevel` - The desired compression level and must be a number
            between 0 (no compression) and 9 (maximum compression).

- `doshuffle` - Specifies whether the shuffle compression preconditioner
    should be applied or not. `BLOSC_NOFILTER` means not applying filters,
    `BLOSC_SHUFFLE` means applying shuffle at a byte level and
    `BLOSC_BITSHUFFLE` at a bit level (slower but *may* achieve better
    compression).

- `typesize` - Is the number of bytes for the atomic type in binary
    src` buffer.  This is mainly useful for the shuffle preconditioner.
    For implementation reasons, only a 1 < typesize < 256 will allow the
    shuffle filter to work.  When typesize is not in this range, shuffle
    will be silently disabled.

- `nbytes` - The number of bytes to compress in the `src` buffer.

- `src` -  The buffer containing the data to compress.
- `dest`  - The buffer where the compressed data will be put,
    must have at least the size of `destsize`.

- `destsize` -  The size of the dest buffer. Blosc
    guarantees that if you set `destsize` to, at least,
    `BLOSC_MAX_OVERHEAD`, the compression will always succeed.

# Returns

The number of bytes compressed. If src buffer cannot be compressed into destsize, the return value is zero and you should discard the contents of the dest buffer.
"""

function blosc_compress(clevel, shuffle, itemsize, srcsize, src, dest, destsize)
    @ccall lib.blosc_compress(
            clevel::Cint, shuffle::Cint, itemsize::Csize_t, srcsize::Csize_t, src::Ptr{Cvoid}, dest::Ptr{Cvoid}, destsize::Csize_t
        )::Cint
end

"""
    blosc_decompress(src, dest, destsize)

Decompress a block of compressed data in src, put the result in dest and returns the size of the decompressed block.

C signature: `int blosc_decompress(const void *src, void *dest, size_t destsize)`

# Arguments

- `src`  - The buffer to be decompressed.
- `dest` - The buffer where the decompressed data will be put.
- `destsize` = The size of the @p dest buffer

# Returns
The number of bytes decompressed. If an error occurs, e.g. the compressed data is corrupted or the output buffer is not large enough, then a negative value will be returned instead.

"""
function blosc_decompress(src, dest, destsize)
    @ccall lib.blosc_decompress(src::Ptr{Cvoid}, dest::Ptr{Cvoid}, destsize::Csize_t)::Cint
end

"""
    blosc_getitem(src, start, nitems, dest)

Get `nitems` (of `typesize` size) in `src` buffer starting in `start`.
The items are returned in `dest` buffer, which has to have enough
space for storing all items.

C signature: `int blosc_getitem(const void *src, int start, int nitems, void *dest)`

#Arguments

- `src` - The compressed buffer from data will be decompressed.
- `start` - The zero-indexed position of the first item (of `typesize` size) from where data will be retrieved.
- `nitems` - The number of items (of `typesize` size) that will be retrieved.
- `dest` -  The buffer where the decompressed data retrieved will be put.

# Returns
The number of bytes copied to @p dest or a negative value if some error happens.
"""
function blosc_getitem(src, start, nitems, dest)
    @ccall lib.blosc_getitem(src::Ptr{Cvoid}, start::Cint, nitems::Cint, dest::Ptr{Cvoid})::Cint
end

"""
    blosc_get_nthreads()

Returns the current number of threads that are used for compression/decompression.
"""
function blosc_get_nthreads()
    @ccall lib.blosc_get_nthreads()::Cint
end

"""
    blosc_set_nthreads(nthreads)

Initialize a pool of threads for compression/decompression.
If nthreads is 1, then the serial version is chosen and a possible previous existing pool is ended. If this is not called, nthreads is set to 1 internally.

# Returns

The previous number of threads.
"""
function blosc_set_nthreads(nthreads)
    @ccall lib.blosc_set_nthreads(nthreads::Cint)::Cint
end

"""
    blosc_get_compressor()

Get the current compressor that is used for compression.
"""
function blosc_get_compressor()
    unsafe_string(@ccall lib.blosc_get_compressor()::Cstring)
end

"""
    blosc_set_compressor(compname::AbstractString)

Select the compressor to be used.

The supported ones are “blosclz”, “lz4”, “lz4hc”, “zlib” and “ztsd”. If this function is not called, then “blosclz” will be used.

#Returns

The code for the compressor (>=0). In case the compressor is not recognized, or there is not support for it in this build, it returns a -1.
"""
function blosc_set_compressor(compname::AbstractString)
    @ccall lib.blosc_set_compressor(compname::Cstring)::Cint
end


"""
    blosc_set_delta(dodelta)

Select the delta coding filter to be used.

This call should always succeed.

#Arguments

- `dodelta` – A value >0 will activate the delta filter. If 0, it will be de-activated


"""
function blosc_set_delta(dodelta)
    @ccall lib.blosc_set_delta(dodelta::Cint)::Cvoid
end

"""
    blosc_set_blocksize(blocksize)


Force the use of a specific blocksize.

If 0, an automatic blocksize will be used (the default).

# Warning

The blocksize is a critical parameter with important restrictions in the allowed values, so use this with care.
"""
function blosc_set_blocksize(blocksize)
    @ccall lib.blosc_set_blocksize(blocksize::Csize_t)::Cvoid
end


"""
    blosc_free_resources()

Free possible memory temporaries and thread resources.

Use this when you are not going to use Blosc for a long while.

# Returns
A 0 if succeeds, in case of problems releasing the resources, it returns a negative number.

"""
function blosc_free_resources()
    @ccall lib.blosc_free_resources()::Cint
end