"""
    unsafe_append_buffer!(schunk::SChunk, src::Ptr{T}, src_size)

Compress `src_size` bytes from `src` buffer, and append it to super-chubk

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `src`
to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.

Return the number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function unsafe_append_buffer!(schunk::SChunk, src::Ptr{T}, src_size) where {T}
    return Lib.blosc2_schunk_append_buffer(schunk.ptr, src, src_size)
end

"""
    unsafe_decompress_chunk(schunk::SChunk, nchunk, dest::Ptr{T}, dest_size)

Decompress the `nchunk` (1-indexed) chunk from super-chunk into `dest`

Return count of the elements written to dest

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `src`
to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_decompress_chunk(schunk::SChunk, nchunk, dest::Ptr{T}, dest_size) where {T}
    @boundscheck checkchunksbounds(schunk, nchunk)
    res = Lib.blosc2_schunk_decompress_chunk(schunk.ptr, nchunk - 1, dest, dest_size)
    return res >= 0 ?
    ceil(Int64, res / sizeof(T)) :
    res
end

"""
    unsafe_append_chunk!(schunk::SChunk, chunk::Ptr{UInt8}; copy::Bool = true)

Append an existing `chunk` o a super-chunk.
`copy` specified whether the chunk should be copied internally or can be used as-is.
Return the number of chunks in super-chunk. If some problem is detected, this number will be negative.

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `chunk`
to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_append_chunk!(schunk::SChunk, chunk::Ptr{UInt8}; copy::Bool = true)
    return Lib.blosc2_schunk_append_chunk(schunk.ptr, chunk, copy)
end

"""
    unsafe_update_chunk!(schunk::SChunk, nchunk, chunk::Ptr{UInt8}; copy::Bool = true)

Update a `chunk` at a `nchunk` position (1-indexed) in a super-chunk.
`copy` specified whether the chunk should be copied internally or can be used as-is.
Return the number of chunks in super-chunk. If some problem is detected, this number will be negative.

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `chunk`
to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_update_chunk!(schunk::SChunk, nchunk, chunk::Ptr{UInt8}; copy::Bool = true)
    @boundscheck checkchunksbounds(schunk, nchunk)
    return Lib.blosc2_schunk_update_chunk(schunk.ptr, nchunk - 1, chunk, copy)
end

"""
    unsafe_insert_chunk!(schunk::SChunk, nchunk, chunk::Ptr{UInt8}; copy::Bool = true)

Insert a `chunk` at a `nchunk` position (1-indexed) in a super-chunk.
`copy` specified whether the chunk should be copied internally or can be used as-is.
Return the number of chunks in super-chunk. If some problem is detected, this number will be negative.

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `chunk`
to ensure that they are valid. Incorrect usage may corrupt or segfault your program, in the same manner as C.
"""
function unsafe_insert_chunk!(schunk::SChunk, nchunk, chunk::Ptr{UInt8}; copy::Bool = true)
    @boundscheck checkchunksbounds(schunk, nchunk)
    return Lib.blosc2_schunk_insert_chunk(schunk.ptr, nchunk - 1, chunk, copy)
end

"""
    unsafe_get_chunk(schunk::SChunk, nchunk)

Return a compressed chunk that is part of a super-chunk as `Vector{UInt8}`

The unsafe prefix on this function indicates that using the result of this function
after the schunk argument to this function is no longer accessible to the program may cause undefined behavior,
including program corruption or segfaults, at any later time.
"""
function unsafe_get_chunk(schunk::SChunk, nchunk)
    @boundscheck checkchunksbounds(schunk, nchunk)
    result = Ref{Ptr{UInt8}}()
    needs_free = Ref{Bool}()
    size = Lib.blosc2_schunk_get_chunk(schunk.ptr, nchunk - 1, result, needs_free)
    size < 0 && error("decompression error")
    return unsafe_wrap(Array, result[], size, own = needs_free[])
end