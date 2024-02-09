const blosc_init = blosc2_init
const blosc_destroy = blosc2_destroy
const blosc_free_resources = blosc2_free_resources
const blosc_get_nthreads = blosc2_get_nthreads
const blosc_set_nthreads = blosc2_set_nthreads
const blosc_compcode_to_compname = blosc2_compcode_to_compname
const blosc_compname_to_compcode = blosc2_compname_to_compcode
const blosc_list_compressors = blosc2_list_compressors
const blosc_get_version_string = blosc2_get_version_string
const blosc_get_complib_info = blosc2_get_complib_info
const blosc_cbuffer_versions = blosc2_cbuffer_versions
const blosc_cbuffer_complib = blosc2_cbuffer_complib
const BLOSC_MAX_OVERHEAD = BLOSC2_MAX_OVERHEAD

function blosc2_cparams_defaults(
    compcode = BLOSC_BLOSCLZ,
    compcode_meta = 0x0,
    clevel = 0x5,
    use_dict = Cint(0),
    typesize = Int32(8),
    nthreads = Int16(1),
    blocksize = Int32(0),
    splitmode = BLOSC_FORWARD_COMPAT_SPLIT,
    schunk = C_NULL,
    filters = (0x0, 0x0, 0x0, 0x0, 0x0, BLOSC_SHUFFLE),
    filters_meta = (0x0, 0x0, 0x0, 0x0, 0x0, 0x0),
    prefilter = C_NULL,
    preparams = C_NULL,
    tuner_params = C_NULL,
    tuner_id = Cint(0),
    instr_codec = false,
    codec_params = C_NULL,
    filter_params = (C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)
)
    return blosc2_cparams(
        compcode,
        compcode_meta,
        clevel,
        use_dict,
        typesize,
        nthreads,
        blocksize,
        splitmode,
        schunk,
        filters,
        filters_meta,
        prefilter,
        preparams,
        tuner_params,
        tuner_id,
        instr_codec,
        codec_params,
        filter_params
    )
end

function blosc2_cparams(
        compcode,
        compcode_meta,
        clevel,
        use_dict,
        typesize,
        nthreads,
        blocksize,
        splitmode,
        schunk,
        filters,
        filters_meta,
        prefilter,
        preparams,
        tuner_params
)
    return blosc2_cparams_defaults(
        compcode,
        compcode_meta,
        clevel,
        use_dict,
        typesize,
        nthreads,
        blocksize,
        splitmode,
        schunk,
        filters,
        filters_meta,
        prefilter,
        preparams,
        tuner_params
    )

end



function blosc2_dparams_defaults(
    nthreads = Int16(1),
    schunk = C_NULL,
    postfilter = C_NULL,
    postparams = C_NULL
)
    return blosc2_dparams(
        nthreads,
        schunk,
        postfilter,
        postparams
    )
end
