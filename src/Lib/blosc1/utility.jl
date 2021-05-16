"""
    blosc_compname_to_compcode(compname)

Get the compressor code associated with the compressor name.

# Returns
The compressor code. If the compressor name is not recognized, or there is not support for it in this build, -1 is returned instead.
"""
function blosc_compname_to_compcode(compname)
    @ccall lib.blosc_compname_to_compcode(compname::Cstring)::Cint
end

"""
    blosc_list_compressors()

Get a list of compressors supported in the current build.
"""
function blosc_list_compressors()
    split(
        unsafe_string(
            @ccall lib.blosc_list_compressors()::Cstring
        ), ","
    )
end

"""
    blosc_get_version_string()

Get the version of Blosc in string format.
"""
function blosc_get_version_string()
    unsafe_string(
        @ccall lib.blosc_get_version_string()::Cstring
    )
end

"""
    blosc_get_complib_info(compname)::NamedTuple{(:code, :complib, :version), Tuple{Int, String, String}}

Get info from compression libraries included in the current build.

# Returns

NamedTuple with following fields:

- `code` for the compression library (>=0), if it is not supported, then -1
- `complib` – The string where the compression library name, if available, else empty string

- `version` – The string where the compression library version, if available, else empty string

C signature `int blosc_get_complib_info(const char *compname, char **complib, char **version)`
"""
function blosc_get_complib_info(compname)::NamedTuple{(:code, :complib, :version), Tuple{Int, String, String}}
    complib = Ref{Cstring}()
    version = Ref{Cstring}()
    r = @ccall lib.blosc_get_complib_info(compname::Cstring, complib::Ref{Cstring}, version::Ref{Cstring})::Cint
    println(r)
    r == -1 && return (code = -1, complib = "", version = "")

    return (
        code = r,
        complib = unsafe_string(complib[]),
        version = unsafe_string(version[])
    )
end