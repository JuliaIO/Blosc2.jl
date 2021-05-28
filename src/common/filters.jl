struct FilterDef
    name ::Symbol
    id ::UInt8
    description ::String
end

struct Filter
    name ::Symbol
    id ::UInt8
    meta ::UInt8
end

max_filters_count() = Lib.BLOSC2_MAX_FILTERS

struct FilterPipeline
    filters ::NTuple{max_filters_count(), Filter}
    function FilterPipeline(filters::Vector)
        full = fill(make_filter(:nofilter), max_filters_count())
        copyto!(full, filters)
        return new((full...,))
    end
end

"""
    filter_pipeline(args...)

Make filter pipeline. Each argument can be filter name (`Symbol`) or pair name=>meta ('Pair{Symbol, Integer}').
Each argument represents a filter in a chain of filters that are sequentially applied during compression
Maximum number of filters is `max_filters_count()`

# Examples

```
filter_pipeline(:trunc_prec=>23, :shuffle)
```
"""
filter_pipeline(args...) = FilterPipeline([filter_element.(args)...,])


filter_element(name::Symbol) = make_filter(name)
filter_element(name_meta::Pair{Symbol, <:Integer}) = make_filter(name_meta[1], name_meta[2])

add_available_filter(name::Symbol, id::Integer, description::AbstractString = "") =
         _available_filters[name] = FilterDef(name, id, description)

function fill_buildin_filters()
    add_available_filter(:nofilter, Lib.BLOSC_NOFILTER, "No filter.")
    add_available_filter(:shuffle, Lib.BLOSC_SHUFFLE, "Byte-wise shuffle.")
    add_available_filter(:bitshuffle, Lib.BLOSC_BITSHUFFLE, "Bit-wise shuffle.")
    add_available_filter(:delta, Lib.BLOSC_DELTA, "Delta filter.")
    add_available_filter(:trunc_prec, Lib.BLOSC_TRUNC_PREC, "Truncate precision filter.")
end

"""
    has_filter(name::Symbol)

Check if filter with name `name` is exists
"""
has_filter(name::Symbol) = haskey(_available_filters, name)

"""
    make_filter(name::Symbol, [meta::UInt8 = 0])

Make filter
"""
function make_filter(name::Symbol, meta::Integer = UInt8(0))
    def = _available_filters[name]
    return Filter(def.name, def.id, meta)
end

"""
    available_filter_names()

Get vector with names of available filters
"""
available_filter_names() = collect(keys(_available_filters))

"""
    filter_description(name::Symbol)

Get desctription of filter `name`
"""
filter_description(name::Symbol) = _available_filters[name].description