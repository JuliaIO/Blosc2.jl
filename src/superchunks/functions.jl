"""
    delete_chunk!(schunk::SChunk, nchunk)

Delete a chunk at a `nchunk` position (1-indexed) from a super-chunk.

Return the number of chunks in super-chunk. If some problem is detected, this number will be negative.
"""
function delete_chunk!(schunk::SChunk, nchunk)
    @boundscheck checkchunksbounds(schunk, nchunk)
    return Lib.blosc2_schunk_delete_chunk(schunk.ptr, nchunk - 1)
end