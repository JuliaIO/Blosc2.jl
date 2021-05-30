"""
    SChunk

This struct is the standard container for Blosc 2 compressed data.
"""
mutable struct SChunk
    ptr ::Ptr{Lib.blosc2_schunk}
    function SChunk(schunk::Ptr{Lib.blosc2_schunk})
        result = new(schunk)
        finalizer(result) do sc
            Lib.blosc2_schunk_free(sc.ptr)
        end
    end
end

"""
    clevel(s::SChunk)

Compression level of schunk
"""
clevel(s::SChunk) = unsafe_load(s.ptr.clevel)
"""
    typesize(s::SChunk)

Type Size  of schunk
"""
typesize(s::SChunk) = unsafe_load(s.ptr.typesize)
"""
    chunksize(s::SChunk)

Size of chunkes of super-chunk
"""
chunksize(s::SChunk) = unsafe_load(s.ptr.chunksize)
"""
    blocksize(s::SChunk)

Block Size of schunk
"""
blocksize(s::SChunk) = unsafe_load(s.ptr.blocksize)
"""
    nchunks(s::SChunk)

Number of chunks in super-chunk.
"""
nchunks(s::SChunk) = unsafe_load(s.ptr.nchunks)
"""
    nbytes(s::SChunk)

Uncompressed size of all data in super-chunk
"""
nbytes(s::SChunk) = unsafe_load(s.ptr.nbytes)
"""
    cbytes(s::SChunk)

Compressed size of all data in super-chunk
"""
cbytes(s::SChunk) = unsafe_load(s.schunk.cbytes)

"""
    length(s::SChunk)

Number of chunks in super-chunk.
"""
Base.length(s::SChunk) = nchunks(s)

function checkchunksbounds(s::SChunk, bounds)
    checkbounds(Bool, 1:length(s), bounds) || throw(BoundsError(s, bounds))
    nothing
end

"""
    SChunk([storage::Storage])

Create a new super-chunk.

In case that storage.urlpath is not `nothing`, the data is stored on-disk.
if the data file(s) exists the file will be overwritten
"""
function SChunk(storage::Storage = Storage())
    return with_preserved_blosc2_storage(storage) do bstorage
        SChunk(Lib.blosc2_schunk_new(Ref(bstorage)))
    end
end

"""
    Base.copy(schunk::SChunk, [storage::Storage])

Create a copy of super-chunk with new storage settings
"""
function Base.copy(schunk::SChunk, storage::Storage = Storage())
    return with_preserved_blosc2_storage(storage) do bstorage
        SChunk(Lib.blosc2_schunk_copy(schunk.ptr, Ref(bstorage)))
    end
end

