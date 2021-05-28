# Blosc2.jl

Julia interface for the [Blosc2 Library](https://github.com/Blosc/c-blosc2)


## Installation

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/waralex/Blosc2.jl.git"))
```

## Status

The project is in  development.

Currently, low-level interfaces to the c library are implemented. Compression/decompression functions are also implemented.
In the near future, I plan to work with super-chunks, meta layers, as well as more detailed documentation, examples, etc.