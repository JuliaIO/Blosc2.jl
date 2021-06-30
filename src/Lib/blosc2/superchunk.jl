
struct blosc2_metalayer_unsafe
  name::Cstring #!< The metalayer identifier for Blosc client (e.g. Caterva).
  content::Ptr{UInt8} #!< The serialized (msgpack preferably) content of the metalayer.
  content_len::Int32 #!< The length in bytes of the content.
end

"""
    blosc2_storage

This struct is meant for holding storage parameters for a for a blosc2 container,
allowing to specify, for example, how to interpret the contents included in the schunk.
"""
struct blosc2_storage

    contiguous ::Bool #!< Whether the chunks are contiguous or sparse.
    urlpath ::Cstring #!< The path for persistent storage. If NULL, that means in-memory.
    cparams ::Ptr{blosc2_cparams} #!< The compression params when creating a schunk. If NULL, sensible defaults are used depending on the context.
    dparams ::Ptr{blosc2_dparams} #!< The decompression params when creating a schunk. If NULL, sensible defaults are used depending on the context.
    io::Ptr{blosc2_io} #!< Input/output backend.

    blosc2_storage(;
        contiguous = false,
        urlpath = C_NULL,
        cparams = C_NULL,
        dparams = C_NULL,
        io = C_NULL
    ) = new(contiguous, urlpath, cparams, dparams, io)
end

"""
    blosc2_schunk

This struct is the standard container for Blosc 2 compressed data.

This is essentially a container for Blosc 1 chunks of compressed data, and it allows to overcome the 32-bit limitation in Blosc 1.
Optionally, a blosc2_frame can be attached so as to store the compressed chunks contiguously.
"""
struct blosc2_schunk
    version ::UInt8
    compcode ::UInt8 #!< The default compressor. Each chunk can override this.
    compcode_meta ::UInt8 #!< The default compressor metadata. Each chunk can override this.
    clevel ::UInt8 #!< The compression level and other compress params.
    typesize ::Int32 #!< The type size.
    blocksize ::Int32 #!< The requested size of the compressed blocks (0; meaning automatic).
    chunksize ::Int32 #!< Size of each chunk. 0 if not a fixed chunksize.
    filters ::FiltersTuple #!< The (sequence of) filters.  8-bit per filter.
    filters_meta ::FiltersTuple #!< Metadata for filters. 8-bit per meta-slot.
    nchunks::Int32 #!< Number of chunks in super-chunk.
    nbytes ::Int64 #!< The data size + metadata size + header size (uncompressed).
    cbytes ::Int64 #!< The data size + metadata size + header size (compressed).
    data ::Ptr{Ptr{UInt8}} #! Pointer to chunk data pointers buffer.
    data_len ::Csize_t #!< Length of the chunk data pointers buffer.
    storage ::Ptr{blosc2_storage} #!< Pointer to storage info.
    frame ::Ptr{Cvoid} #!< Pointer to frame used as store for chunks.
    cctx ::Ptr{blosc2_context} #!< Context for compression
    dctx ::Ptr{blosc2_context} #!< Context for decompression.
    metalayers ::NTuple{BLOSC2_MAX_METALAYERS, blosc2_metalayer_unsafe} #!< The array of metalayers.
    nmetalayers ::Int16 #!< The number of metalayers in the super-chunk
    vlmetalayers ::NTuple{BLOSC2_MAX_VLMETALAYERS, blosc2_metalayer_unsafe} #<! The array of variable-length metalayers.
    nvlmetalayers ::Int16 #!< The number of variable-length metalayers.
    udbtune ::Ptr{Cvoid}
end

"""
    blosc2_schunk_new(storage::blosc2_storage)::Ptr{blosc2_storage}

Create a new super-chunk.

# Remark

In case that `storage.urlpath` is not NULL, the data is stored on-disk. If the data file(s) exist, they are overwritten.

# Parameters

-  `storage` – The storage properties.

"""
function blosc2_schunk_new(storage::blosc2_storage = blosc2_storage())
    rstorage = Ref(storage)
    @ccall lib.blosc2_schunk_new(rstorage::Ptr{blosc2_storage})::Ptr{blosc2_schunk}
end

"""
    blosc2_schunk_free(schunk::blosc2_schunk)

Release resources from a super-chunk.

# Remark
All the memory resources attached to the super-frame are freed. If the super-chunk is on-disk, the data continues there for a later re-opening.

# Returns
0 if success
"""
function blosc2_schunk_free(schunk::Ptr{blosc2_schunk})
    @ccall lib.blosc2_schunk_free(schunk::Ptr{blosc2_schunk})::Cint
end

"""
    blosc2_schunk_append_buffer(schunk::Ptr{blosc2_schunk}, src, nbytes)


Append a src data buffer to a super-chunk.

# Parameters

- `schunk` – The super-chunk where data will be appended.

- `src` – The buffer of data to compress.

- `nbytes` – The size of the src buffer.

# Returns

The number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function blosc2_schunk_append_buffer(schunk::Ptr{blosc2_schunk}, src, nbytes)
    @ccall lib.blosc2_schunk_append_buffer(schunk::Ptr{blosc2_schunk}, src::Ptr{Cvoid}, nbytes::Int32)::Cint
end


"""
    blosc2_schunk_decompress_chunk(schunk::Ptr{blosc2_schunk}, nchunk, dest, nbytes)

Decompress and return the `nchunk` chunk of a super-chunk.

If the chunk is uncompressed successfully, it is put in the `dest`

# Arguments


- `schunk` – The super-chunk from where the chunk will be decompressed.

- `nchunk` – The chunk to be decompressed (0 indexed).

- `dest` – The buffer where the decompressed data will be put.

- `nbytes` – The size of the dest.

# Returns

The size of the decompressed chunk or 0 if it is non-initialized. If some problem is detected, a negative code is returned instead.
"""
function blosc2_schunk_decompress_chunk(schunk::Ptr{blosc2_schunk}, nchunk, dest, nbytes)
    @ccall lib.blosc2_schunk_decompress_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Cint, dest::Ptr{Cvoid}, nbytes::Int32)::Cint
end

"""
    blosc2_schunk_get_chunk(schunk::Ptr{blosc2_schunk}, nchunk)::Vector{UInt8}

Return a compressed chunk that is part of a super-chunk in the chunk parameter.

# Arguments

- `schunk` – The super-chunk from where to extract a chunk.

- `nchunk` – The chunk to be extracted (0 indexed).

C signature `int blosc2_schunk_get_chunk(blosc2_schunk *schunk, int nchunk, uint8_t **chunk, bool *needs_free)`
"""
function blosc2_schunk_get_chunk(schunk::Ptr{blosc2_schunk}, nchunk)::Vector{UInt8}
   chunk_ptr = Ref{Ptr{UInt8}}()
   needs_free = Ref{Bool}()
   r = @ccall lib.blosc2_schunk_get_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Cint, chunk_ptr::Ptr{Ptr{UInt8}}, needs_free::Ptr{Bool})::Cint
   r < 0 && error("blosc2_schunk_get_chunk error")
   r == 0 && return Vector{UInt8}(undef, 0)
   return unsafe_wrap(Array, chunk_ptr[], r, own = needs_free[])
end


"""
    blosc2_schunk_append_chunk(schunk::Ptr{blosc2_schunk}, chunk, copy)

Append an existing chunk o a super-chunk.

# Arguments

- `schunk` – The super-chunk where the chunk will be appended.

- `chunk` – The chunk to append. An internal copy is made, so chunk can be reused or freed if desired.

- `copy` – Whether the chunk should be copied internally or can be used as-is.

#Returns

The number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function blosc2_schunk_append_chunk(schunk::Ptr{blosc2_schunk}, chunk, copy)
    @ccall lib.blosc2_schunk_append_chunk(schunk::Ptr{blosc2_schunk}, chunk::Ptr{UInt8}, copy::Bool)::Cint
end

"""
    blosc2_schunk_insert_chunk(schunk::Ptr{blosc2_schunk}, nchunk, chunk, copy)

Insert a chunk at a specific position in a super-chunk.

# Arguments

- `schunk` – The super-chunk where the chunk will be appended.

- `nchunk` – The position where the chunk will be inserted.(zero indexed)

- `chunk` – The chunk to insert. If an internal copy is made, the chunk can be reused or freed if desired.

- `copy` – Whether the chunk should be copied internally or can be used as-is.

# Returns

The number of chunks in super-chunk. If some problem is detected, this number will be negative.

"""
function blosc2_schunk_insert_chunk(schunk::Ptr{blosc2_schunk}, nchunk, chunk, copy)
    @ccall lib.blosc2_schunk_insert_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Cint, chunk::Ptr{UInt8}, copy::Bool)::Cint
end

"""
    blosc2_schunk_update_chunk(schunk::ptr{blosc2_schunk}, nchunk, chunk, copy)

Update a chunk at a specific position in a super-chunk.

# Arguments

- `schunk` – The super-chunk where the chunk will be updated.

- `nchunk` – The position where the chunk will be updated.(zero indexed)

- `chunk` – The new chunk. If an internal copy is made, the chunk can be reused or freed if desired.

- `copy` – Whether the chunk should be copied internally or can be used as-is.

# Returns

The number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function blosc2_schunk_update_chunk(schunk::Ptr{blosc2_schunk}, nchunk, chunk::Vector{UInt8}, copy)
    @ccall lib.blosc2_schunk_update_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Cint, chunk::Ptr{UInt8}, copy::Bool)::Cint
end

"""
    blosc2_schunk_delete_chunk(schunk::ptr{blosc2_schunk}, nchunk)

Delete a chunk at a specific position in a super-chunk.

Parameters
- `schunk` – The super-chunk where the chunk will be deleted.

- `nchunk` – The position where the chunk will be deleted. (zero indexed)

# Returns

The number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function blosc2_schunk_delete_chunk(schunk::Ptr{blosc2_schunk}, nchunk)
    @ccall lib.blosc2_schunk_delete_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Cint)::Cint
end

"""
    blosc2_schunk_reorder_offsets(schunk::Ptr{blosc2_schunk}, offsets_order::Vector{Cint})

Reorder the chunk offsets of an existing super-chunk.

# Arguments

- `schunk` – The super-chunk whose chunk offsets are to be reordered.

- `offsets_order` – The new order of the chunk offsets (zero ordered)

# Returns

0 if suceeds. Else a negative code is returned.
"""
function blosc2_schunk_reorder_offsets(schunk::Ptr{blosc2_schunk}, offsets_order::Vector{Cint}})
    @ccall lib.blosc2_schunk_reorder_offsets(schunk::Ptr{blosc2_schunk}, offsets_order::Ptr{Cint})::Cint
end

"""
    blosc2_schunk_get_cparams(schunk::Ptr{blosc2_schunk})

Return the cparams associated to a super-chunk.
"""
function blosc2_schunk_get_cparams(schunk::Ptr{blosc2_schunk})
   params_ptr = Ref{Ptr{blosc2_cparams}}()
   r = @ccall lib.blosc2_schunk_get_cparams(schunk::Ptr{blosc2_schunk}, params_ptr::Ptr{Ptr{blosc2_cparams}})::Cint
   r < 0 && error("blosc2_schunk_get_cparams error")
   return unsafe_wrap(Array, params_ptr[], 1, own = true)[1]
end

"""
    blosc2_schunk_get_dparams(schunk::Ptr{blosc2_schunk})

Return the dparams associated to a super-chunk.
"""
function blosc2_schunk_get_dparams(schunk::Ptr{blosc2_schunk})
   params_ptr = Ref{Ptr{blosc2_dparams}}()
   r = @ccall lib.blosc2_schunk_get_dparams(schunk::Ptr{blosc2_schunk}, params_ptr::Ptr{Ptr{blosc2_dparams}})::Cint
   r < 0 && error("blosc2_schunk_get_dparams error")
   return unsafe_wrap(Array, params_ptr[], 1, own = true)[1]
end