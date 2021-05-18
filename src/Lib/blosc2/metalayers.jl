"""
    blosc2_meta_exists(schunk::Ptr{blosc2_schunk}, name)

Find whether the schunk has a metalayer or not.

# Arguments

- `schunk` – The super-chunk from which the metalayer will be checked.

- `name` – The name of the metalayer to be checked.

# Returns

If successful, return the index of the metalayer. Else, return a negative value.
"""
function blosc2_meta_exists(schunk::Ptr{blosc2_schunk}, name)
    @ccall lib.blosc2_meta_exists(schunk::Ptr{blosc2_schunk}, name::Cstring)::Cint
end

"""
    blosc2_meta_add(schunk::Ptr{blosc2_schunk}, name, content, content_len)

Add content into a new metalayer.

# Arguments

- `schunk` – The super-chunk to which the metalayer should be added.

- `name` – The name of the metalayer.

- `content` – The content of the metalayer.

- `content_len` – The length of the content.

# Returns

If successful, the index of the new metalayer. Else, return a negative value.
"""
function blosc2_meta_add(schunk::Ptr{blosc2_schunk}, name, content, content_len)
    @ccall lib.blosc2_meta_add(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::UInt32)::Cint
end

"""
    blosc2_meta_update(schunk::Ptr{blosc2_schunk}, name, content, content_len)

Update the content of an existing metalayer.

# Arguments

- `schunk` – The frame containing the metalayer.

- `name` – The name of the metalayer to be updated.

- `content` – The new content of the metalayer.

- `content_len` – The length of the content.

# Returns

If successful, the index of the metalayer. Else, return a negative value.

# Note

Contrarily to `blosc2_meta_add` the updates to metalayers are automatically serialized into a possible attached frame.
"""
function blosc2_meta_update(schunk::Ptr{blosc2_schunk}, name, content, content_len)
    @ccall lib.blosc2_meta_update(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::UInt32)::Cint
end

"""
    blosc2_meta_get(schunk::Ptr{blosc2_schunk}, name)

Get the content out of a  metalayer.

# Arguments

- `schunk` – The frame containing the metalayer.

- `name` – The name of the metalayer to be updated.

- `content` – The new content of the metalayer.

- `content_len` – The length of the content.

# Returns

If successful, the content of the metalayer. Else, return `nothing`.
"""
function blosc2_meta_get(schunk::Ptr{blosc2_schunk}, name)
   content_ptr = Ref{Ptr{UInt8}}()
   content_len = Ref{UInt32}()
   r = @ccall lib.blosc2_meta_get(schunk::Ptr{blosc2_schunk}, name::Cstring, content_ptr::Ptr{Ptr{UInt8}}, content_len::Ref{UInt32})::Cint
   r < 0 && return nothing
   return unsafe_wrap(Array, content_ptr[], content_len[], own = true)
end
"""
    blosc2_vmeta_exists(schunk::Ptr{blosc2_schunk}, name)


Find whether the schunk has a variable-length metalayer or not.

# Arguments

- `schunk` – The super-chunk from which the metalayer will be checked.

- `name` – The name of the metalayer to be checked.

# Returns

If successful, return the index of the metalayer. Else, return a negative value.
"""
function blosc2_vlmeta_exists(schunk::Ptr{blosc2_schunk}, name)
    @ccall lib.blosc2_vlmeta_exists(schunk::Ptr{blosc2_schunk}, name::Cstring)::Cint
end

"""
    blosc2_vmeta_add(schunk::Ptr{blosc2_schunk}, name, content, content_len, cparams::blosc2_cparams)

Add content into a new variable-length metalayer.

# Arguments

- `schunk` – The super-chunk to which the metalayer should be added.

- `name` – The name of the metalayer.

- `content` – The content of the metalayer.

- `content_len` – The length of the content.

- `cparams` – The parameters for compressing the variable-length metalayer content.

# Returns

If successful, the index of the new metalayer. Else, return a negative value.
"""
function blosc2_vlmeta_add(schunk::Ptr{blosc2_schunk}, name, content, content_len, cparams::blosc2_cparams = blosc2_cparams())
    cparams_ref = Ref(cparams)
    @ccall lib.blosc2_vlmeta_add(
        schunk::Ptr{blosc2_schunk},
        name::Cstring,
        content::Ptr{UInt8},
        content_len::UInt32,
        cparams_ref::Ptr{blosc2_cparams}
    )::Cint
end

"""
    blosc2_vlmeta_update(schunk::Ptr{blosc2_schunk}, name, content, content_len)

Update the content of an existing variable-length metalayer.

# Arguments

- `schunk` – The frame containing the metalayer.

- `name` – The name of the metalayer to be updated.

- `content` – The new content of the metalayer.

- `content_len` – The length of the content.

- `cparams` – The parameters for compressing the variable-length metalayer content.

# Returns

If successful, the index of the metalayer. Else, return a negative value.

# Note

Contrarily to `blosc2_meta_add` the updates to metalayers are automatically serialized into a possible attached frame.
"""
function blosc2_vlmeta_update(schunk::Ptr{blosc2_schunk}, name, content, content_len, cparams::blosc2_cparams = blosc2_cparams())
    cparams_ref = Ref(cparams)
    @ccall lib.blosc2_vlmeta_update(
        schunk::Ptr{blosc2_schunk},
        name::Cstring,
        content::Ptr{UInt8},
        content_len::UInt32,
        cparams_ref::Ptr{blosc2_cparams}
    )::Cint
end

"""
    blosc2_vlmeta_get(schunk::Ptr{blosc2_schunk}, name)

Get the content out of a variable-length metalayer.

# Arguments

- `schunk` – The frame containing the metalayer.

- `name` – The name of the metalayer to be updated.

- `content` – The new content of the metalayer.

- `content_len` – The length of the content.

# Returns

If successful, the content of the metalayer. Else, return `nothing`.
"""
function blosc2_vlmeta_get(schunk::Ptr{blosc2_schunk}, name)
   content_ptr = Ref{Ptr{UInt8}}()
   content_len = Ref{UInt32}()
   r = @ccall lib.blosc2_vlmeta_get(schunk::Ptr{blosc2_schunk}, name::Cstring, content_ptr::Ptr{Ptr{UInt8}}, content_len::Ref{UInt32})::Cint
   r < 0 && return nothing
   return unsafe_wrap(Array, content_ptr[], content_len[], own = true)
end
#=
int blosc2_vlmeta_exists(blosc2_schunk *schunk, const char *name)
Find whether the schunk has a variable-length metalayer or not.

Parameters
schunk – The super-chunk from which the variable-length metalayer will be checked.

name – The name of the variable-length metalayer to be checked.

Returns
If successful, return the index of the variable-length metalayer. Else, return a negative value.

int blosc2_vlmeta_add(blosc2_schunk *schunk, const char *name, uint8_t *content, uint32_t content_len, blosc2_cparams *cparams)
Add content into a new variable-length metalayer.

Parameters
schunk – The super-chunk to which the variable-length metalayer should be added.

name – The name of the variable-length metalayer.

content – The content to be added.

content_len – The length of the content.

cparams – The parameters for compressing the variable-length metalayer content. If NULL, the BLOSC2_CPARAMS_DEFAULTS will be used.

Returns
If successful, the index of the new variable-length metalayer. Else, return a negative value.

int blosc2_vlmeta_update(blosc2_schunk *schunk, const char *name, uint8_t *content, uint32_t content_len, blosc2_cparams *cparams)
Update the content of an existing variable-length metalayer.

Parameters
schunk – The super-chunk containing the variable-length metalayer.

name – The name of the variable-length metalayer to be updated.

content – The new content of the variable-length metalayer.

content_len – The length of the content.

cparams – The parameters for compressing the variable-length metalayer content. If NULL, the BLOSC2_CPARAMS_DEFAULTS will be used.

Returns
If successful, the index of the variable-length metalayer. Else, return a negative value.

int blosc2_vlmeta_get(blosc2_schunk *schunk, const char *name, uint8_t **content, uint32_t *content_len)
Get the content out of a variable-length metalayer.

Parameters
schunk – The super-chunk containing the variable-length metalayer.

name – The name of the variable-length metalayer.

content – The pointer where the content will be put.

content_len – The pointer where the length of the content will be put.

Returns
If successful, the index of the new variable-length metalayer. Else, return a negative value.



=#