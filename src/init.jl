const _available_compressors = Dict{Symbol,Compressor}()
const _available_filters = Dict{Symbol, FilterDef}()

function __init__()
    fill_available_compressors!(_available_compressors)
    global _default_compressor_name = _get_default_compressor_name()

    fill_buildin_filters()
end