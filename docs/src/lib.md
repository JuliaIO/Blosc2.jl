# Low level interface api

Direct low-level interfaces to the c library placed in submodule `Lib`

## Blosc1 API

This is the classic API from Blosc1 with 32-bit limited containers.
Corresponding c-blosc2 [documentation](https://c-blosc2.readthedocs.io/en/latest/reference/blosc1.html)

### Main API

```@docs
Lib.blosc_init
Lib.blosc_destroy
Lib.blosc_compress
Lib.blosc_decompress
Lib.blosc_getitem
Lib.blosc_get_nthreads
Lib.blosc_set_nthreads
Lib.blosc_get_compressor
Lib.blosc_set_compressor
Lib.blosc_set_delta
Lib.blosc_set_blocksize
Lib.blosc_free_resources
```

### Compressed buffer information

```@docs
Lib.blosc_cbuffer_sizes
Lib.blosc_cbuffer_metainfo
Lib.blosc_cbuffer_versions
Lib.blosc_cbuffer_complib
```

### Utility functions

```@docs
Lib.blosc_compcode_to_compname
Lib.blosc_compname_to_compcode
Lib.blosc_list_compressors
Lib.blosc_get_version_string
Lib.blosc_get_complib_info
```

## Context

In Blosc 2 there is a special blosc2_context struct that is created from compression and decompression parameters. This allows the compression and decompression to happen in multithreaded scenarios, without the need for using the global lock.
Corresponding c-blosc2 [documentation](https://c-blosc2.readthedocs.io/en/latest/reference/context.html)

```@docs
Lib.blosc2_cparams
Lib.blosc2_dparams
Lib.blosc2_context
Lib.blosc2_create_cctx
Lib.blosc2_create_dctx
Lib.blosc2_free_ctx
Lib.blosc2_compress_ctx
Lib.blosc2_decompress_ctx
Lib.blosc2_getitem_ctx
Lib.blosc2_set_maskout
Lib.blosc2_ctx_get_cparams
Lib.blosc2_ctx_get_dparams
```

## Super-chunk

This API describes the new Blosc 2 container, the super-chunk (or schunk for short).
Corresponding c-blosc2 [documentation](https://c-blosc2.readthedocs.io/en/latest/reference/schunk.html)


```@docs
Lib.blosc2_cparams
Lib.blosc2_schunk
Lib.blosc2_schunk_new
Lib.blosc2_schunk_free
Lib.blosc2_schunk_append_buffer
Lib.blosc2_schunk_decompress_chunk
Lib.blosc2_schunk_get_chunk
Lib.blosc2_schunk_append_chunk
Lib.blosc2_schunk_insert_chunk
Lib.blosc2_schunk_update_chunk
Lib.blosc2_schunk_delete_chunk
Lib.blosc2_schunk_reorder_offsets
Lib.blosc2_schunk_get_cparams
Lib.blosc2_schunk_get_dparams
```

## Metalayers

Metalayers are meta-information that can be attached to super-chunks. They can also be serialized to disk.
Corresponding c-blosc2 [documentation](https://c-blosc2.readthedocs.io/en/latest/reference/metalayers.html)

```@docs
Lib.blosc2_meta_exists
Lib.blosc2_meta_add
Lib.blosc2_meta_update
Lib.blosc2_meta_get
Lib.blosc2_vlmeta_exists
Lib.blosc2_vlmeta_add
Lib.blosc2_vlmeta_update
Lib.blosc2_vlmeta_get
```