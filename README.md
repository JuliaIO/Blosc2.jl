# Blosc2.jl - blosc2 (https://github.com/Blosc/c-blosc2) wrapper for Julia

## Installation

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/waralex/Block2_jll.git"))
Pkg.add(PackageSpec(url="https://github.com/waralex/Blosc2.jl.git"))
```
Installation under windows is not yet possible because of this problem: https://github.com/Blosc/c-blosc2/issues/302

## Status

The project is in an early stage of development.

Currently, low-level wrappers are implemented (In the Blosc2.Lib submodule) corresponding to the following pages from the documentation for the original api:

* Blosc1 API https://c-blosc2.readthedocs.io/en/latest/reference/blosc1.html
* Context¶ https://c-blosc2.readthedocs.io/en/latest/reference/context.html (except of `blosc2_ctx_get_cparams` and `blosc2_ctx_get_dparams`)

The development plans are to first implement a fully low-level API in the `Lib` submodule and use it to develop a higher-level API for convenient use in Julia