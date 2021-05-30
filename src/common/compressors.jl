"""
    Compressor

Representation of compressor supprted by blosc
"""
struct Compressor
    name ::Symbol
    libname ::String
    code ::Int8
    version ::String
end


function fill_available_compressors!(dict::Dict{Symbol, Compressor})
    names = split(
        unsafe_string(
            Lib.blosc_list_compressors()
        ), ","
    )
    for n in names
        complib = Ref{Cstring}()
        version = Ref{Cstring}()
        code = Lib.blosc_get_complib_info(n, complib, version)
        code < 0 && continue
        dict[Symbol(n)] = Compressor(Symbol(n), unsafe_string(complib[]), code, unsafe_string(version[]))
    end
end

function compname_by_code(code)
    compname = Ref{Cstring}()
    r = Lib.blosc_compcode_to_compname(code, compname)
    (r == -1 || compname[] == C_NULL) && error("compressor code $compcode is not recognized, or there is not support for it in this build")
    return unsafe_string(compname[])
end

function _get_default_compressor_name()
    name = compname_by_code(0)
    return Symbol(name)
end

"""
    available_compressors()::Dict{Symbol, Compressor}

Get dictionary of available compressors
"""
available_compressors()::Dict{Symbol, Compressor} = _available_compressors

"""
    available_compressors_names()::Vector{Symbol}

Get vector of available compressors names
"""
available_compressors_names() = collect(keys(_available_compressors))

"""
    has_compressor(name::Symbol)

Check if compressor `name` available
"""
has_compressor(name::Symbol) = haskey(_available_compressors, name)

"""
    compressor(name::Symbol)

Get compressor by name
"""
function compressor_by_name(name::Symbol)
    !has_compressor(name) && throw(KeyError(name))
    _available_compressors[name]
end

"""
    default_compressor_name()

Name of default compressor
"""
default_compressor_name() = _default_compressor_name

"""
    default_compressor()

Default compressor
"""
default_compressor() = _available_compressors[_default_compressor_name]