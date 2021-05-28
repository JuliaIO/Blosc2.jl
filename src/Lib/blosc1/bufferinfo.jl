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