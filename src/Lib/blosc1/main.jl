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
"""
    blosc_cbuffer_sizes(cbuffer)::NamedTuple{(:nbytes, :cbytes, blocksize), Tuple{Int, Int, Int}}


Get information about a compressed buffer, namely the number of uncompressed bytes (`nbytes`) and compressed (`cbytes`).

It also returns the `blocksize` (which is used internally for doing the compression by blocks).

You only need to pass the first BLOSC_EXTENDED_HEADER_LENGTH bytes of a compressed buffer for this call to work.

This function should always succeed.

C signature `void blosc_cbuffer_sizes(const void *cbuffer, size_t *nbytes, size_t *cbytes, size_t *blocksize)`
"""
function blosc_cbuffer_sizes(cbuffer)::NamedTuple{(:nbytes, :cbytes, :blocksize), Tuple{Int, Int, Int}}

    nbytes = Ref{Csize_t}()
    cbytes = Ref{Csize_t}()
    blocksize = Ref{Csize_t}()
    @ccall lib.blosc_cbuffer_sizes(cbuffer::Ptr{Cvoid}, nbytes::Ptr{Csize_t}, cbytes::Ptr{Csize_t}, blocksize::Ptr{Csize_t})::Cvoid
    return (
        nbytes = nbytes[],
        cbytes = cbytes[],
        blocksize = blocksize[]
    )
end


"""
    blosc_cbuffer_metainfo(cbuffer)::NamedTuple{(:typesize, :flags), Tuple{Int, Int}}

Get information about a compressed buffer, namely the type size (`typesize`), as well as some internal `flags`.

You can use the `BLOSC_DOSHUFFLE`, `BLOSC_DOBITSHUFFLE`, `BLOSC_DODELTA` and `BLOSC_MEMCPYED` symbols for extracting the interesting bits (e.g. `flags & BLOSC_DOSHUFFLE` says whether the buffer is byte-shuffled or not).

This function should always succeed.

C signature `void blosc_cbuffer_metainfo(const void *cbuffer, size_t *typesize, int *flags)`

# `flags` bits:

- bit 0: whether the shuffle filter has been applied or not

- bit 1: whether the internal buffer is a pure memcpy or not

- bit 2: whether the bitshuffle filter has been applied or not

- bit 3: whether the delta coding filter has been applied or not

"""
function blosc_cbuffer_metainfo(cbuffer)::NamedTuple{(:typesize, :flags), Tuple{Int, Int}}
    typesize = Ref{Csize_t}()
    flags = Ref{Cint}()
    @ccall lib.blosc_cbuffer_metainfo(cbuffer::Ptr{Cvoid}, typesize::Ptr{Csize_t}, flags::Ptr{Cint})::Cvoid
    return (
        typesize = typesize[],
        flags = flags[]
    )
end

"""
    blosc_cbuffer_versions(cbuffer)::NamedTuple{(:version, :versionlz), Tuple{Int, Int}}


Get information about a compressed buffer, namely the internal Blosc format version (`version`) and the format for the internal Lempel-Ziv compressor used (`versionlz`).

This function should always succeed.

C signature `void blosc_cbuffer_versions(const void *cbuffer, int *version, int *versionlz)`
"""
function blosc_cbuffer_versions(cbuffer)::NamedTuple{(:version, :versionlz), Tuple{Int, Int}}
    version = Ref{Cint}()
    versionlz = Ref{Cint}()
    @ccall lib.blosc_cbuffer_versions(cbuffer::Ptr{Cvoid}, version::Ptr{Cint}, versionlz::Ptr{Cint})::Cvoid
    return (
        version = version[],
        versionlz = versionlz[]
    )
end

"""
    blosc_cbuffer_complib(cbuffer)

Get the compressor library/format used in a compressed buffer.

This function should always succeed.
"""
function blosc_cbuffer_complib(cbuffer)
    unsafe_string(
        @ccall lib.blosc_cbuffer_complib(cbuffer::Ptr{Cvoid})::Cstring
    )
end

"""
    blosc_compcode_to_compname(compcode)

Get the compressor name associated with the compressor code.

C signature `int blosc_compcode_to_compname(int compcode, const char **compname)`
"""
function blosc_compcode_to_compname(compcode)
    compname = Ref{Cstring}()
    r = @ccall lib.blosc_compcode_to_compname(compcode::Cint, compname::Ref{Cstring})::Cint
    (r == -1 || compname[] == C_NULL) && error("compressor code $compcode is not recognized, or there is not support for it in this build")
    return unsafe_string(compname[])
end


"""
    blosc_compname_to_compcode(compname)

Get the compressor code associated with the compressor name.

# Returns
The compressor code. If the compressor name is not recognized, or there is not support for it in this build, -1 is returned instead.
"""
function blosc_compname_to_compcode(compname)
    @ccall lib.blosc_compname_to_compcode(compname::Cstring)::Cint
end

"""
    blosc_list_compressors()

Get a list of compressors supported in the current build.
"""
function blosc_list_compressors()
    split(
        unsafe_string(
            @ccall lib.blosc_list_compressors()::Cstring
        ), ","
    )
end

"""
    blosc_get_version_string()

Get the version of Blosc in string format.
"""
function blosc_get_version_string()
    unsafe_string(
        @ccall lib.blosc_get_version_string()::Cstring
    )
end

"""
    blosc_get_complib_info(compname)::NamedTuple{(:code, :complib, :version), Tuple{Int, String, String}}

Get info from compression libraries included in the current build.

# Returns

NamedTuple with following fields:

- `code` for the compression library (>=0), if it is not supported, then -1
- `complib` – The string where the compression library name, if available, else empty string

- `version` – The string where the compression library version, if available, else empty string

C signature `int blosc_get_complib_info(const char *compname, char **complib, char **version)`
"""
function blosc_get_complib_info(compname)::NamedTuple{(:code, :complib, :version), Tuple{Int, String, String}}
    complib = Ref{Cstring}()
    version = Ref{Cstring}()
    r = @ccall lib.blosc_get_complib_info(compname::Cstring, complib::Ref{Cstring}, version::Ref{Cstring})::Cint
    println(r)
    r == -1 && return (code = -1, complib = "", version = "")

    return (
        code = r,
        complib = unsafe_string(complib[]),
        version = unsafe_string(version[])
    )
end