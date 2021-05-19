"""
    blosc_session(f)

Executes f between `blosc_init()` and `blosc_destroy()`. Sutable for blosc1 api calls
"""
function blosc_session(f)
    Lib.blosc_init()
    res = f()
    Lib.blosc_destroy()
    return res
end