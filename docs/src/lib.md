# Low-Level API

See https://www.blosc.org/c-blosc2/reference/index.html for details on the low-level API.

```@autodocs
Modules = [Blosc2, Blosc2.Lib]
Filter = t -> !(t in (Blosc2.Compressor, Blosc2.Context, Blosc2.CompressionParams, Blosc2.DecompressionParams))
```
