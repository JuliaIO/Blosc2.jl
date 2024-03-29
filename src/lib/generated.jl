using Blosc2_jll
export Blosc2_jll

using CEnum

const __time_t = Clong

struct timespec
    tv_sec::__time_t
    tv_nsec::Clong
end

function print_error(rc)
    @ccall libblosc2.print_error(rc::Cint)::Cstring
end

struct blosc2_stdio_file
    file::Ptr{Libc.FILE}
end

function blosc2_stdio_open(urlpath, mode, params)
    @ccall libblosc2.blosc2_stdio_open(urlpath::Cstring, mode::Cstring, params::Ptr{Cvoid})::Ptr{Cvoid}
end

function blosc2_stdio_close(stream)
    @ccall libblosc2.blosc2_stdio_close(stream::Ptr{Cvoid})::Cint
end

function blosc2_stdio_tell(stream)
    @ccall libblosc2.blosc2_stdio_tell(stream::Ptr{Cvoid})::Int64
end

function blosc2_stdio_seek(stream, offset, whence)
    @ccall libblosc2.blosc2_stdio_seek(stream::Ptr{Cvoid}, offset::Int64, whence::Cint)::Cint
end

function blosc2_stdio_write(ptr, size, nitems, stream)
    @ccall libblosc2.blosc2_stdio_write(ptr::Ptr{Cvoid}, size::Int64, nitems::Int64, stream::Ptr{Cvoid})::Int64
end

function blosc2_stdio_read(ptr, size, nitems, stream)
    @ccall libblosc2.blosc2_stdio_read(ptr::Ptr{Cvoid}, size::Int64, nitems::Int64, stream::Ptr{Cvoid})::Int64
end

function blosc2_stdio_truncate(stream, size)
    @ccall libblosc2.blosc2_stdio_truncate(stream::Ptr{Cvoid}, size::Int64)::Cint
end

@cenum var"##Ctag#248"::UInt32 begin
    BLOSC1_VERSION_FORMAT_PRE1 = 1
    BLOSC1_VERSION_FORMAT = 2
    BLOSC2_VERSION_FORMAT_ALPHA = 3
    BLOSC2_VERSION_FORMAT_BETA1 = 4
    BLOSC2_VERSION_FORMAT_STABLE = 5
    BLOSC2_VERSION_FORMAT = 5
end

@cenum var"##Ctag#249"::UInt32 begin
    BLOSC2_VERSION_FRAME_FORMAT_BETA2 = 1
    BLOSC2_VERSION_FRAME_FORMAT_RC1 = 2
    BLOSC2_VERSION_FRAME_FORMAT = 2
end

struct blosc2_instr
    cratio::Cfloat
    cspeed::Cfloat
    filter_speed::Cfloat
    flags::NTuple{4, UInt8}
end

@cenum var"##Ctag#251"::UInt32 begin
    BLOSC_MIN_HEADER_LENGTH = 16
    BLOSC_EXTENDED_HEADER_LENGTH = 32
    BLOSC2_MAX_OVERHEAD = 32
    BLOSC2_MAX_BUFFERSIZE = 2147483615
    BLOSC_MAX_TYPESIZE = 255
    BLOSC_MIN_BUFFERSIZE = 32
end

@cenum var"##Ctag#252"::UInt32 begin
    BLOSC2_DEFINED_TUNER_START = 0
    BLOSC2_DEFINED_TUNER_STOP = 31
    BLOSC2_GLOBAL_REGISTERED_TUNER_START = 32
    BLOSC2_GLOBAL_REGISTERED_TUNER_STOP = 159
    BLOSC2_GLOBAL_REGISTERED_TUNERS = 0
    BLOSC2_USER_REGISTERED_TUNER_START = 160
    BLOSC2_USER_REGISTERED_TUNER_STOP = 255
end

@cenum var"##Ctag#253"::UInt32 begin
    BLOSC_STUNE = 0
    BLOSC_LAST_TUNER = 1
    BLOSC_LAST_REGISTERED_TUNE = 31
end

@cenum var"##Ctag#254"::UInt32 begin
    BLOSC2_DEFINED_FILTERS_START = 0
    BLOSC2_DEFINED_FILTERS_STOP = 31
    BLOSC2_GLOBAL_REGISTERED_FILTERS_START = 32
    BLOSC2_GLOBAL_REGISTERED_FILTERS_STOP = 159
    BLOSC2_GLOBAL_REGISTERED_FILTERS = 5
    BLOSC2_USER_REGISTERED_FILTERS_START = 160
    BLOSC2_USER_REGISTERED_FILTERS_STOP = 255
    BLOSC2_MAX_FILTERS = 6
    BLOSC2_MAX_UDFILTERS = 16
end

@cenum var"##Ctag#255"::UInt32 begin
    BLOSC_NOSHUFFLE = 0
    BLOSC_NOFILTER = 0
    BLOSC_SHUFFLE = 1
    BLOSC_BITSHUFFLE = 2
    BLOSC_DELTA = 3
    BLOSC_TRUNC_PREC = 4
    BLOSC_LAST_FILTER = 5
    BLOSC_LAST_REGISTERED_FILTER = 36
end

@cenum var"##Ctag#256"::UInt32 begin
    BLOSC_DOSHUFFLE = 1
    BLOSC_MEMCPYED = 2
    BLOSC_DOBITSHUFFLE = 4
    BLOSC_DODELTA = 8
end

@cenum var"##Ctag#257"::UInt32 begin
    BLOSC2_USEDICT = 1
    BLOSC2_BIGENDIAN = 2
    BLOSC2_INSTR_CODEC = 128
end

@cenum var"##Ctag#258"::UInt32 begin
    BLOSC2_MAXDICTSIZE = 131072
    BLOSC2_MAXBLOCKSIZE = 536866816
end

@cenum var"##Ctag#259"::UInt32 begin
    BLOSC2_DEFINED_CODECS_START = 0
    BLOSC2_DEFINED_CODECS_STOP = 31
    BLOSC2_GLOBAL_REGISTERED_CODECS_START = 32
    BLOSC2_GLOBAL_REGISTERED_CODECS_STOP = 159
    BLOSC2_GLOBAL_REGISTERED_CODECS = 5
    BLOSC2_USER_REGISTERED_CODECS_START = 160
    BLOSC2_USER_REGISTERED_CODECS_STOP = 255
end

@cenum var"##Ctag#260"::UInt32 begin
    BLOSC_BLOSCLZ = 0
    BLOSC_LZ4 = 1
    BLOSC_LZ4HC = 2
    BLOSC_ZLIB = 4
    BLOSC_ZSTD = 5
    BLOSC_LAST_CODEC = 6
    BLOSC_LAST_REGISTERED_CODEC = 36
end

@cenum var"##Ctag#261"::UInt32 begin
    BLOSC_BLOSCLZ_LIB = 0
    BLOSC_LZ4_LIB = 1
    BLOSC_ZLIB_LIB = 3
    BLOSC_ZSTD_LIB = 4
    BLOSC_UDCODEC_LIB = 6
    BLOSC_SCHUNK_LIB = 7
end

@cenum var"##Ctag#262"::UInt32 begin
    BLOSC_BLOSCLZ_FORMAT = 0
    BLOSC_LZ4_FORMAT = 1
    BLOSC_LZ4HC_FORMAT = 1
    BLOSC_ZLIB_FORMAT = 3
    BLOSC_ZSTD_FORMAT = 4
    BLOSC_UDCODEC_FORMAT = 6
end

@cenum var"##Ctag#263"::UInt32 begin
    BLOSC_BLOSCLZ_VERSION_FORMAT = 1
    BLOSC_LZ4_VERSION_FORMAT = 1
    BLOSC_LZ4HC_VERSION_FORMAT = 1
    BLOSC_ZLIB_VERSION_FORMAT = 1
    BLOSC_ZSTD_VERSION_FORMAT = 1
    BLOSC_UDCODEC_VERSION_FORMAT = 1
end

@cenum var"##Ctag#264"::UInt32 begin
    BLOSC_ALWAYS_SPLIT = 1
    BLOSC_NEVER_SPLIT = 2
    BLOSC_AUTO_SPLIT = 3
    BLOSC_FORWARD_COMPAT_SPLIT = 4
end

@cenum var"##Ctag#265"::UInt32 begin
    BLOSC2_CHUNK_VERSION = 0
    BLOSC2_CHUNK_VERSIONLZ = 1
    BLOSC2_CHUNK_FLAGS = 2
    BLOSC2_CHUNK_TYPESIZE = 3
    BLOSC2_CHUNK_NBYTES = 4
    BLOSC2_CHUNK_BLOCKSIZE = 8
    BLOSC2_CHUNK_CBYTES = 12
    BLOSC2_CHUNK_FILTER_CODES = 16
    BLOSC2_CHUNK_FILTER_META = 24
    BLOSC2_CHUNK_BLOSC2_FLAGS = 31
end

@cenum var"##Ctag#266"::UInt32 begin
    BLOSC2_NO_SPECIAL = 0
    BLOSC2_SPECIAL_ZERO = 1
    BLOSC2_SPECIAL_NAN = 2
    BLOSC2_SPECIAL_VALUE = 3
    BLOSC2_SPECIAL_UNINIT = 4
    BLOSC2_SPECIAL_LASTID = 4
    BLOSC2_SPECIAL_MASK = 7
end

@cenum var"##Ctag#267"::Int32 begin
    BLOSC2_ERROR_SUCCESS = 0
    BLOSC2_ERROR_FAILURE = -1
    BLOSC2_ERROR_STREAM = -2
    BLOSC2_ERROR_DATA = -3
    BLOSC2_ERROR_MEMORY_ALLOC = -4
    BLOSC2_ERROR_READ_BUFFER = -5
    BLOSC2_ERROR_WRITE_BUFFER = -6
    BLOSC2_ERROR_CODEC_SUPPORT = -7
    BLOSC2_ERROR_CODEC_PARAM = -8
    BLOSC2_ERROR_CODEC_DICT = -9
    BLOSC2_ERROR_VERSION_SUPPORT = -10
    BLOSC2_ERROR_INVALID_HEADER = -11
    BLOSC2_ERROR_INVALID_PARAM = -12
    BLOSC2_ERROR_FILE_READ = -13
    BLOSC2_ERROR_FILE_WRITE = -14
    BLOSC2_ERROR_FILE_OPEN = -15
    BLOSC2_ERROR_NOT_FOUND = -16
    BLOSC2_ERROR_RUN_LENGTH = -17
    BLOSC2_ERROR_FILTER_PIPELINE = -18
    BLOSC2_ERROR_CHUNK_INSERT = -19
    BLOSC2_ERROR_CHUNK_APPEND = -20
    BLOSC2_ERROR_CHUNK_UPDATE = -21
    BLOSC2_ERROR_2GB_LIMIT = -22
    BLOSC2_ERROR_SCHUNK_COPY = -23
    BLOSC2_ERROR_FRAME_TYPE = -24
    BLOSC2_ERROR_FILE_TRUNCATE = -25
    BLOSC2_ERROR_THREAD_CREATE = -26
    BLOSC2_ERROR_POSTFILTER = -27
    BLOSC2_ERROR_FRAME_SPECIAL = -28
    BLOSC2_ERROR_SCHUNK_SPECIAL = -29
    BLOSC2_ERROR_PLUGIN_IO = -30
    BLOSC2_ERROR_FILE_REMOVE = -31
    BLOSC2_ERROR_NULL_POINTER = -32
    BLOSC2_ERROR_INVALID_INDEX = -33
    BLOSC2_ERROR_METALAYER_NOT_FOUND = -34
    BLOSC2_ERROR_MAX_BUFSIZE_EXCEEDED = -35
    BLOSC2_ERROR_TUNER = -36
end

function blosc2_init()
    @ccall libblosc2.blosc2_init()::Cvoid
end

function blosc2_destroy()
    @ccall libblosc2.blosc2_destroy()::Cvoid
end

function blosc1_compress(clevel, doshuffle, typesize, nbytes, src, dest, destsize)
    @ccall libblosc2.blosc1_compress(clevel::Cint, doshuffle::Cint, typesize::Csize_t, nbytes::Csize_t, src::Ptr{Cvoid}, dest::Ptr{Cvoid}, destsize::Csize_t)::Cint
end

function blosc1_decompress(src, dest, destsize)
    @ccall libblosc2.blosc1_decompress(src::Ptr{Cvoid}, dest::Ptr{Cvoid}, destsize::Csize_t)::Cint
end

function blosc1_getitem(src, start, nitems, dest)
    @ccall libblosc2.blosc1_getitem(src::Ptr{Cvoid}, start::Cint, nitems::Cint, dest::Ptr{Cvoid})::Cint
end

function blosc2_getitem(src, srcsize, start, nitems, dest, destsize)
    @ccall libblosc2.blosc2_getitem(src::Ptr{Cvoid}, srcsize::Int32, start::Cint, nitems::Cint, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

# typedef void ( * blosc_threads_callback ) ( void * callback_data , void ( * dojob ) ( void * ) , int numjobs , size_t jobdata_elsize , void * jobdata )
const blosc_threads_callback = Ptr{Cvoid}

function blosc2_set_threads_callback(callback, callback_data)
    @ccall libblosc2.blosc2_set_threads_callback(callback::blosc_threads_callback, callback_data::Ptr{Cvoid})::Cvoid
end

function blosc2_get_nthreads()
    @ccall libblosc2.blosc2_get_nthreads()::Int16
end

function blosc2_set_nthreads(nthreads)
    @ccall libblosc2.blosc2_set_nthreads(nthreads::Int16)::Int16
end

function blosc1_get_compressor()
    @ccall libblosc2.blosc1_get_compressor()::Cstring
end

function blosc1_set_compressor(compname)
    @ccall libblosc2.blosc1_set_compressor(compname::Cstring)::Cint
end

function blosc2_set_delta(dodelta)
    @ccall libblosc2.blosc2_set_delta(dodelta::Cint)::Cvoid
end

function blosc2_compcode_to_compname(compcode, compname)
    @ccall libblosc2.blosc2_compcode_to_compname(compcode::Cint, compname::Ptr{Cstring})::Cint
end

function blosc2_compname_to_compcode(compname)
    @ccall libblosc2.blosc2_compname_to_compcode(compname::Cstring)::Cint
end

function blosc2_list_compressors()
    @ccall libblosc2.blosc2_list_compressors()::Cstring
end

function blosc2_get_version_string()
    @ccall libblosc2.blosc2_get_version_string()::Cstring
end

function blosc2_get_complib_info(compname, complib, version)
    @ccall libblosc2.blosc2_get_complib_info(compname::Cstring, complib::Ptr{Cstring}, version::Ptr{Cstring})::Cint
end

function blosc2_free_resources()
    @ccall libblosc2.blosc2_free_resources()::Cint
end

function blosc1_cbuffer_sizes(cbuffer, nbytes, cbytes, blocksize)
    @ccall libblosc2.blosc1_cbuffer_sizes(cbuffer::Ptr{Cvoid}, nbytes::Ptr{Csize_t}, cbytes::Ptr{Csize_t}, blocksize::Ptr{Csize_t})::Cvoid
end

function blosc2_cbuffer_sizes(cbuffer, nbytes, cbytes, blocksize)
    @ccall libblosc2.blosc2_cbuffer_sizes(cbuffer::Ptr{Cvoid}, nbytes::Ptr{Int32}, cbytes::Ptr{Int32}, blocksize::Ptr{Int32})::Cint
end

function blosc1_cbuffer_validate(cbuffer, cbytes, nbytes)
    @ccall libblosc2.blosc1_cbuffer_validate(cbuffer::Ptr{Cvoid}, cbytes::Csize_t, nbytes::Ptr{Csize_t})::Cint
end

function blosc1_cbuffer_metainfo(cbuffer, typesize, flags)
    @ccall libblosc2.blosc1_cbuffer_metainfo(cbuffer::Ptr{Cvoid}, typesize::Ptr{Csize_t}, flags::Ptr{Cint})::Cvoid
end

function blosc2_cbuffer_versions(cbuffer, version, versionlz)
    @ccall libblosc2.blosc2_cbuffer_versions(cbuffer::Ptr{Cvoid}, version::Ptr{Cint}, versionlz::Ptr{Cint})::Cvoid
end

function blosc2_cbuffer_complib(cbuffer)
    @ccall libblosc2.blosc2_cbuffer_complib(cbuffer::Ptr{Cvoid})::Cstring
end

@cenum var"##Ctag#268"::UInt32 begin
    BLOSC2_IO_FILESYSTEM = 0
    BLOSC_IO_LAST_BLOSC_DEFINED = 1
    BLOSC_IO_LAST_REGISTERED = 32
end

@cenum var"##Ctag#269"::UInt32 begin
    BLOSC2_IO_BLOSC_DEFINED = 32
    BLOSC2_IO_REGISTERED = 160
    BLOSC2_IO_USER_DEFINED = 256
end

# typedef void * ( * blosc2_open_cb ) ( const char * urlpath , const char * mode , void * params )
const blosc2_open_cb = Ptr{Cvoid}

# typedef int ( * blosc2_close_cb ) ( void * stream )
const blosc2_close_cb = Ptr{Cvoid}

# typedef int64_t ( * blosc2_tell_cb ) ( void * stream )
const blosc2_tell_cb = Ptr{Cvoid}

# typedef int ( * blosc2_seek_cb ) ( void * stream , int64_t offset , int whence )
const blosc2_seek_cb = Ptr{Cvoid}

# typedef int64_t ( * blosc2_write_cb ) ( const void * ptr , int64_t size , int64_t nitems , void * stream )
const blosc2_write_cb = Ptr{Cvoid}

# typedef int64_t ( * blosc2_read_cb ) ( void * ptr , int64_t size , int64_t nitems , void * stream )
const blosc2_read_cb = Ptr{Cvoid}

# typedef int ( * blosc2_truncate_cb ) ( void * stream , int64_t size )
const blosc2_truncate_cb = Ptr{Cvoid}

struct blosc2_io_cb
    id::UInt8
    name::Cstring
    open::blosc2_open_cb
    close::blosc2_close_cb
    tell::blosc2_tell_cb
    seek::blosc2_seek_cb
    write::blosc2_write_cb
    read::blosc2_read_cb
    truncate::blosc2_truncate_cb
end

struct blosc2_io
    id::UInt8
    name::Cstring
    params::Ptr{Cvoid}
end

function blosc2_register_io_cb(io)
    @ccall libblosc2.blosc2_register_io_cb(io::Ptr{blosc2_io_cb})::Cint
end

function blosc2_get_io_cb(id)
    @ccall libblosc2.blosc2_get_io_cb(id::UInt8)::Ptr{blosc2_io_cb}
end

mutable struct blosc2_context_s end

const blosc2_context = blosc2_context_s

struct blosc2_tuner
    init::Ptr{Cvoid}
    next_blocksize::Ptr{Cvoid}
    next_cparams::Ptr{Cvoid}
    update::Ptr{Cvoid}
    free::Ptr{Cvoid}
    id::Cint
    name::Cstring
end

function blosc2_register_tuner(tuner)
    @ccall libblosc2.blosc2_register_tuner(tuner::Ptr{blosc2_tuner})::Cint
end

struct blosc2_prefilter_params
    user_data::Ptr{Cvoid}
    input::Ptr{UInt8}
    output::Ptr{UInt8}
    output_size::Int32
    output_typesize::Int32
    output_offset::Int32
    nchunk::Int64
    nblock::Int32
    tid::Int32
    ttmp::Ptr{UInt8}
    ttmp_nbytes::Csize_t
    ctx::Ptr{blosc2_context}
end

struct blosc2_postfilter_params
    user_data::Ptr{Cvoid}
    input::Ptr{UInt8}
    output::Ptr{UInt8}
    size::Int32
    typesize::Int32
    offset::Int32
    nchunk::Int64
    nblock::Int32
    tid::Int32
    ttmp::Ptr{UInt8}
    ttmp_nbytes::Csize_t
    ctx::Ptr{blosc2_context}
end

# typedef int ( * blosc2_prefilter_fn ) ( blosc2_prefilter_params * params )
const blosc2_prefilter_fn = Ptr{Cvoid}

# typedef int ( * blosc2_postfilter_fn ) ( blosc2_postfilter_params * params )
const blosc2_postfilter_fn = Ptr{Cvoid}

struct blosc2_cparams
    compcode::UInt8
    compcode_meta::UInt8
    clevel::UInt8
    use_dict::Cint
    typesize::Int32
    nthreads::Int16
    blocksize::Int32
    splitmode::Int32
    schunk::Ptr{Cvoid}
    filters::NTuple{6, UInt8}
    filters_meta::NTuple{6, UInt8}
    prefilter::blosc2_prefilter_fn
    preparams::Ptr{blosc2_prefilter_params}
    tuner_params::Ptr{Cvoid}
    tuner_id::Cint
    instr_codec::Bool
    codec_params::Ptr{Cvoid}
    filter_params::NTuple{6, Ptr{Cvoid}}
end
function Base.getproperty(x::Ptr{blosc2_cparams}, f::Symbol)
    f === :compcode && return Ptr{UInt8}(x + 0)
    f === :compcode_meta && return Ptr{UInt8}(x + 1)
    f === :clevel && return Ptr{UInt8}(x + 2)
    f === :use_dict && return Ptr{Cint}(x + 4)
    f === :typesize && return Ptr{Int32}(x + 8)
    f === :nthreads && return Ptr{Int16}(x + 12)
    f === :blocksize && return Ptr{Int32}(x + 16)
    f === :splitmode && return Ptr{Int32}(x + 20)
    f === :schunk && return Ptr{Ptr{Cvoid}}(x + 24)
    f === :filters && return Ptr{NTuple{6, UInt8}}(x + 32)
    f === :filters_meta && return Ptr{NTuple{6, UInt8}}(x + 38)
    f === :prefilter && return Ptr{blosc2_prefilter_fn}(x + 48)
    f === :preparams && return Ptr{Ptr{blosc2_prefilter_params}}(x + 56)
    f === :tuner_params && return Ptr{Ptr{Cvoid}}(x + 64)
    f === :tuner_id && return Ptr{Cint}(x + 72)
    f === :instr_codec && return Ptr{Bool}(x + 76)
    f === :codec_params && return Ptr{Ptr{Cvoid}}(x + 80)
    f === :filter_params && return Ptr{NTuple{6, Ptr{Cvoid}}}(x + 88)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{blosc2_cparams}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


struct blosc2_dparams
    nthreads::Int16
    schunk::Ptr{Cvoid}
    postfilter::blosc2_postfilter_fn
    postparams::Ptr{blosc2_postfilter_params}
end
function Base.getproperty(x::Ptr{blosc2_dparams}, f::Symbol)
    f === :nthreads && return Ptr{Int16}(x + 0)
    f === :schunk && return Ptr{Ptr{Cvoid}}(x + 8)
    f === :postfilter && return Ptr{blosc2_postfilter_fn}(x + 16)
    f === :postparams && return Ptr{Ptr{blosc2_postfilter_params}}(x + 24)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{blosc2_dparams}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


function blosc2_create_cctx(cparams)
    @ccall libblosc2.blosc2_create_cctx(cparams::blosc2_cparams)::Ptr{blosc2_context}
end

function blosc2_create_dctx(dparams)
    @ccall libblosc2.blosc2_create_dctx(dparams::blosc2_dparams)::Ptr{blosc2_context}
end

function blosc2_free_ctx(context)
    @ccall libblosc2.blosc2_free_ctx(context::Ptr{blosc2_context})::Cvoid
end

function blosc2_ctx_get_cparams(ctx, cparams)
    @ccall libblosc2.blosc2_ctx_get_cparams(ctx::Ptr{blosc2_context}, cparams::Ptr{blosc2_cparams})::Cint
end

function blosc2_ctx_get_dparams(ctx, dparams)
    @ccall libblosc2.blosc2_ctx_get_dparams(ctx::Ptr{blosc2_context}, dparams::Ptr{blosc2_dparams})::Cint
end

function blosc2_set_maskout(ctx, maskout, nblocks)
    @ccall libblosc2.blosc2_set_maskout(ctx::Ptr{blosc2_context}, maskout::Ptr{Bool}, nblocks::Cint)::Cint
end

function blosc2_compress(clevel, doshuffle, typesize, src, srcsize, dest, destsize)
    @ccall libblosc2.blosc2_compress(clevel::Cint, doshuffle::Cint, typesize::Int32, src::Ptr{Cvoid}, srcsize::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_decompress(src, srcsize, dest, destsize)
    @ccall libblosc2.blosc2_decompress(src::Ptr{Cvoid}, srcsize::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_compress_ctx(context, src, srcsize, dest, destsize)
    @ccall libblosc2.blosc2_compress_ctx(context::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_decompress_ctx(context, src, srcsize, dest, destsize)
    @ccall libblosc2.blosc2_decompress_ctx(context::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_chunk_zeros(cparams, nbytes, dest, destsize)
    @ccall libblosc2.blosc2_chunk_zeros(cparams::blosc2_cparams, nbytes::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_chunk_nans(cparams, nbytes, dest, destsize)
    @ccall libblosc2.blosc2_chunk_nans(cparams::blosc2_cparams, nbytes::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_chunk_repeatval(cparams, nbytes, dest, destsize, repeatval)
    @ccall libblosc2.blosc2_chunk_repeatval(cparams::blosc2_cparams, nbytes::Int32, dest::Ptr{Cvoid}, destsize::Int32, repeatval::Ptr{Cvoid})::Cint
end

function blosc2_chunk_uninit(cparams, nbytes, dest, destsize)
    @ccall libblosc2.blosc2_chunk_uninit(cparams::blosc2_cparams, nbytes::Int32, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

function blosc2_getitem_ctx(context, src, srcsize, start, nitems, dest, destsize)
    @ccall libblosc2.blosc2_getitem_ctx(context::Ptr{blosc2_context}, src::Ptr{Cvoid}, srcsize::Int32, start::Cint, nitems::Cint, dest::Ptr{Cvoid}, destsize::Int32)::Cint
end

struct blosc2_storage
    contiguous::Bool
    urlpath::Cstring
    cparams::Ptr{blosc2_cparams}
    dparams::Ptr{blosc2_dparams}
    io::Ptr{blosc2_io}
end
function Base.getproperty(x::Ptr{blosc2_storage}, f::Symbol)
    f === :contiguous && return Ptr{Bool}(x + 0)
    f === :urlpath && return Ptr{Cstring}(x + 8)
    f === :cparams && return Ptr{Ptr{blosc2_cparams}}(x + 16)
    f === :dparams && return Ptr{Ptr{blosc2_dparams}}(x + 24)
    f === :io && return Ptr{Ptr{blosc2_io}}(x + 32)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{blosc2_storage}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


mutable struct blosc2_frame_s end

const blosc2_frame = blosc2_frame_s

struct blosc2_metalayer
    name::Cstring
    content::Ptr{UInt8}
    content_len::Int32
end
function Base.getproperty(x::Ptr{blosc2_metalayer}, f::Symbol)
    f === :name && return Ptr{Cstring}(x + 0)
    f === :content && return Ptr{Ptr{UInt8}}(x + 8)
    f === :content_len && return Ptr{Int32}(x + 16)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{blosc2_metalayer}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


struct blosc2_schunk
    version::UInt8
    compcode::UInt8
    compcode_meta::UInt8
    clevel::UInt8
    splitmode::UInt8
    typesize::Int32
    blocksize::Int32
    chunksize::Int32
    filters::NTuple{6, UInt8}
    filters_meta::NTuple{6, UInt8}
    nchunks::Int64
    current_nchunk::Int64
    nbytes::Int64
    cbytes::Int64
    data::Ptr{Ptr{UInt8}}
    data_len::Csize_t
    storage::Ptr{blosc2_storage}
    frame::Ptr{blosc2_frame}
    cctx::Ptr{blosc2_context}
    dctx::Ptr{blosc2_context}
    metalayers::NTuple{16, Ptr{blosc2_metalayer}}
    nmetalayers::UInt16
    vlmetalayers::NTuple{8192, Ptr{blosc2_metalayer}}
    nvlmetalayers::Int16
    tuner_params::Ptr{Cvoid}
    tuner_id::Cint
    ndim::Int8
    blockshape::Ptr{Int64}
end
function Base.getproperty(x::Ptr{blosc2_schunk}, f::Symbol)
    f === :version && return Ptr{UInt8}(x + 0)
    f === :compcode && return Ptr{UInt8}(x + 1)
    f === :compcode_meta && return Ptr{UInt8}(x + 2)
    f === :clevel && return Ptr{UInt8}(x + 3)
    f === :splitmode && return Ptr{UInt8}(x + 4)
    f === :typesize && return Ptr{Int32}(x + 8)
    f === :blocksize && return Ptr{Int32}(x + 12)
    f === :chunksize && return Ptr{Int32}(x + 16)
    f === :filters && return Ptr{NTuple{6, UInt8}}(x + 20)
    f === :filters_meta && return Ptr{NTuple{6, UInt8}}(x + 26)
    f === :nchunks && return Ptr{Int64}(x + 32)
    f === :current_nchunk && return Ptr{Int64}(x + 40)
    f === :nbytes && return Ptr{Int64}(x + 48)
    f === :cbytes && return Ptr{Int64}(x + 56)
    f === :data && return Ptr{Ptr{Ptr{UInt8}}}(x + 64)
    f === :data_len && return Ptr{Csize_t}(x + 72)
    f === :storage && return Ptr{Ptr{blosc2_storage}}(x + 80)
    f === :frame && return Ptr{Ptr{blosc2_frame}}(x + 88)
    f === :cctx && return Ptr{Ptr{blosc2_context}}(x + 96)
    f === :dctx && return Ptr{Ptr{blosc2_context}}(x + 104)
    f === :metalayers && return Ptr{NTuple{16, Ptr{blosc2_metalayer}}}(x + 112)
    f === :nmetalayers && return Ptr{UInt16}(x + 240)
    f === :vlmetalayers && return Ptr{NTuple{8192, Ptr{blosc2_metalayer}}}(x + 248)
    f === :nvlmetalayers && return Ptr{Int16}(x + 65784)
    f === :tuner_params && return Ptr{Ptr{Cvoid}}(x + 65792)
    f === :tuner_id && return Ptr{Cint}(x + 65800)
    f === :ndim && return Ptr{Int8}(x + 65804)
    f === :blockshape && return Ptr{Ptr{Int64}}(x + 65808)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{blosc2_schunk}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


function blosc2_schunk_new(storage)
    @ccall libblosc2.blosc2_schunk_new(storage::Ptr{blosc2_storage})::Ptr{blosc2_schunk}
end

function blosc2_schunk_copy(schunk, storage)
    @ccall libblosc2.blosc2_schunk_copy(schunk::Ptr{blosc2_schunk}, storage::Ptr{blosc2_storage})::Ptr{blosc2_schunk}
end

function blosc2_schunk_from_buffer(cframe, len, copy)
    @ccall libblosc2.blosc2_schunk_from_buffer(cframe::Ptr{UInt8}, len::Int64, copy::Bool)::Ptr{blosc2_schunk}
end

function blosc2_schunk_avoid_cframe_free(schunk, avoid_cframe_free)
    @ccall libblosc2.blosc2_schunk_avoid_cframe_free(schunk::Ptr{blosc2_schunk}, avoid_cframe_free::Bool)::Cvoid
end

function blosc2_schunk_open(urlpath)
    @ccall libblosc2.blosc2_schunk_open(urlpath::Cstring)::Ptr{blosc2_schunk}
end

function blosc2_schunk_open_offset(urlpath, offset)
    @ccall libblosc2.blosc2_schunk_open_offset(urlpath::Cstring, offset::Int64)::Ptr{blosc2_schunk}
end

function blosc2_schunk_open_udio(urlpath, udio)
    @ccall libblosc2.blosc2_schunk_open_udio(urlpath::Cstring, udio::Ptr{blosc2_io})::Ptr{blosc2_schunk}
end

function blosc2_schunk_to_buffer(schunk, cframe, needs_free)
    @ccall libblosc2.blosc2_schunk_to_buffer(schunk::Ptr{blosc2_schunk}, cframe::Ptr{Ptr{UInt8}}, needs_free::Ptr{Bool})::Int64
end

function blosc2_schunk_to_file(schunk, urlpath)
    @ccall libblosc2.blosc2_schunk_to_file(schunk::Ptr{blosc2_schunk}, urlpath::Cstring)::Int64
end

function blosc2_schunk_append_file(schunk, urlpath)
    @ccall libblosc2.blosc2_schunk_append_file(schunk::Ptr{blosc2_schunk}, urlpath::Cstring)::Int64
end

function blosc2_schunk_free(schunk)
    @ccall libblosc2.blosc2_schunk_free(schunk::Ptr{blosc2_schunk})::Cint
end

function blosc2_schunk_append_chunk(schunk, chunk, copy)
    @ccall libblosc2.blosc2_schunk_append_chunk(schunk::Ptr{blosc2_schunk}, chunk::Ptr{UInt8}, copy::Bool)::Int64
end

function blosc2_schunk_update_chunk(schunk, nchunk, chunk, copy)
    @ccall libblosc2.blosc2_schunk_update_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64, chunk::Ptr{UInt8}, copy::Bool)::Int64
end

function blosc2_schunk_insert_chunk(schunk, nchunk, chunk, copy)
    @ccall libblosc2.blosc2_schunk_insert_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64, chunk::Ptr{UInt8}, copy::Bool)::Int64
end

function blosc2_schunk_delete_chunk(schunk, nchunk)
    @ccall libblosc2.blosc2_schunk_delete_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64)::Int64
end

function blosc2_schunk_append_buffer(schunk, src, nbytes)
    @ccall libblosc2.blosc2_schunk_append_buffer(schunk::Ptr{blosc2_schunk}, src::Ptr{Cvoid}, nbytes::Int32)::Int64
end

function blosc2_schunk_decompress_chunk(schunk, nchunk, dest, nbytes)
    @ccall libblosc2.blosc2_schunk_decompress_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64, dest::Ptr{Cvoid}, nbytes::Int32)::Cint
end

function blosc2_schunk_get_chunk(schunk, nchunk, chunk, needs_free)
    @ccall libblosc2.blosc2_schunk_get_chunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64, chunk::Ptr{Ptr{UInt8}}, needs_free::Ptr{Bool})::Cint
end

function blosc2_schunk_get_lazychunk(schunk, nchunk, chunk, needs_free)
    @ccall libblosc2.blosc2_schunk_get_lazychunk(schunk::Ptr{blosc2_schunk}, nchunk::Int64, chunk::Ptr{Ptr{UInt8}}, needs_free::Ptr{Bool})::Cint
end

function blosc2_schunk_get_slice_buffer(schunk, start, stop, buffer)
    @ccall libblosc2.blosc2_schunk_get_slice_buffer(schunk::Ptr{blosc2_schunk}, start::Int64, stop::Int64, buffer::Ptr{Cvoid})::Cint
end

function blosc2_schunk_set_slice_buffer(schunk, start, stop, buffer)
    @ccall libblosc2.blosc2_schunk_set_slice_buffer(schunk::Ptr{blosc2_schunk}, start::Int64, stop::Int64, buffer::Ptr{Cvoid})::Cint
end

function blosc2_schunk_get_cparams(schunk, cparams)
    @ccall libblosc2.blosc2_schunk_get_cparams(schunk::Ptr{blosc2_schunk}, cparams::Ptr{Ptr{blosc2_cparams}})::Cint
end

function blosc2_schunk_get_dparams(schunk, dparams)
    @ccall libblosc2.blosc2_schunk_get_dparams(schunk::Ptr{blosc2_schunk}, dparams::Ptr{Ptr{blosc2_dparams}})::Cint
end

function blosc2_schunk_reorder_offsets(schunk, offsets_order)
    @ccall libblosc2.blosc2_schunk_reorder_offsets(schunk::Ptr{blosc2_schunk}, offsets_order::Ptr{Int64})::Cint
end

function blosc2_schunk_frame_len(schunk)
    @ccall libblosc2.blosc2_schunk_frame_len(schunk::Ptr{blosc2_schunk})::Int64
end

function blosc2_schunk_fill_special(schunk, nitems, special_value, chunksize)
    @ccall libblosc2.blosc2_schunk_fill_special(schunk::Ptr{blosc2_schunk}, nitems::Int64, special_value::Cint, chunksize::Int32)::Int64
end

function blosc2_meta_exists(schunk, name)
    @ccall libblosc2.blosc2_meta_exists(schunk::Ptr{blosc2_schunk}, name::Cstring)::Cint
end

function blosc2_meta_add(schunk, name, content, content_len)
    @ccall libblosc2.blosc2_meta_add(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::Int32)::Cint
end

function blosc2_meta_update(schunk, name, content, content_len)
    @ccall libblosc2.blosc2_meta_update(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::Int32)::Cint
end

function blosc2_meta_get(schunk, name, content, content_len)
    @ccall libblosc2.blosc2_meta_get(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{Ptr{UInt8}}, content_len::Ptr{Int32})::Cint
end

function blosc2_vlmeta_exists(schunk, name)
    @ccall libblosc2.blosc2_vlmeta_exists(schunk::Ptr{blosc2_schunk}, name::Cstring)::Cint
end

function blosc2_vlmeta_add(schunk, name, content, content_len, cparams)
    @ccall libblosc2.blosc2_vlmeta_add(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::Int32, cparams::Ptr{blosc2_cparams})::Cint
end

function blosc2_vlmeta_update(schunk, name, content, content_len, cparams)
    @ccall libblosc2.blosc2_vlmeta_update(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{UInt8}, content_len::Int32, cparams::Ptr{blosc2_cparams})::Cint
end

function blosc2_vlmeta_get(schunk, name, content, content_len)
    @ccall libblosc2.blosc2_vlmeta_get(schunk::Ptr{blosc2_schunk}, name::Cstring, content::Ptr{Ptr{UInt8}}, content_len::Ptr{Int32})::Cint
end

function blosc2_vlmeta_delete(schunk, name)
    @ccall libblosc2.blosc2_vlmeta_delete(schunk::Ptr{blosc2_schunk}, name::Cstring)::Cint
end

function blosc2_vlmeta_get_names(schunk, names)
    @ccall libblosc2.blosc2_vlmeta_get_names(schunk::Ptr{blosc2_schunk}, names::Ptr{Cstring})::Cint
end

const blosc_timestamp_t = timespec

function blosc_set_timestamp(timestamp)
    @ccall libblosc2.blosc_set_timestamp(timestamp::Ptr{blosc_timestamp_t})::Cvoid
end

function blosc_elapsed_nsecs(start_time, end_time)
    @ccall libblosc2.blosc_elapsed_nsecs(start_time::blosc_timestamp_t, end_time::blosc_timestamp_t)::Cdouble
end

function blosc_elapsed_secs(start_time, end_time)
    @ccall libblosc2.blosc_elapsed_secs(start_time::blosc_timestamp_t, end_time::blosc_timestamp_t)::Cdouble
end

function blosc1_get_blocksize()
    @ccall libblosc2.blosc1_get_blocksize()::Cint
end

function blosc1_set_blocksize(blocksize)
    @ccall libblosc2.blosc1_set_blocksize(blocksize::Csize_t)::Cvoid
end

function blosc1_set_splitmode(splitmode)
    @ccall libblosc2.blosc1_set_splitmode(splitmode::Cint)::Cvoid
end

function blosc2_frame_get_offsets(schunk)
    @ccall libblosc2.blosc2_frame_get_offsets(schunk::Ptr{blosc2_schunk})::Ptr{Int64}
end

# typedef int ( * blosc2_codec_encoder_cb ) ( const uint8_t * input , int32_t input_len , uint8_t * output , int32_t output_len , uint8_t meta , blosc2_cparams * cparams , const void * chunk )
const blosc2_codec_encoder_cb = Ptr{Cvoid}

# typedef int ( * blosc2_codec_decoder_cb ) ( const uint8_t * input , int32_t input_len , uint8_t * output , int32_t output_len , uint8_t meta , blosc2_dparams * dparams , const void * chunk )
const blosc2_codec_decoder_cb = Ptr{Cvoid}

struct blosc2_codec
    compcode::UInt8
    compname::Cstring
    complib::UInt8
    version::UInt8
    encoder::blosc2_codec_encoder_cb
    decoder::blosc2_codec_decoder_cb
end

function blosc2_register_codec(codec)
    @ccall libblosc2.blosc2_register_codec(codec::Ptr{blosc2_codec})::Cint
end

# typedef int ( * blosc2_filter_forward_cb ) ( const uint8_t * , uint8_t * , int32_t , uint8_t , blosc2_cparams * , uint8_t )
const blosc2_filter_forward_cb = Ptr{Cvoid}

# typedef int ( * blosc2_filter_backward_cb ) ( const uint8_t * , uint8_t * , int32_t , uint8_t , blosc2_dparams * , uint8_t )
const blosc2_filter_backward_cb = Ptr{Cvoid}

struct blosc2_filter
    id::UInt8
    name::Cstring
    version::UInt8
    forward::blosc2_filter_forward_cb
    backward::blosc2_filter_backward_cb
end

function blosc2_register_filter(filter)
    @ccall libblosc2.blosc2_register_filter(filter::Ptr{blosc2_filter})::Cint
end

function blosc2_remove_dir(path)
    @ccall libblosc2.blosc2_remove_dir(path::Cstring)::Cint
end

function blosc2_remove_urlpath(path)
    @ccall libblosc2.blosc2_remove_urlpath(path::Cstring)::Cint
end

function blosc2_rename_urlpath(old_urlpath, new_path)
    @ccall libblosc2.blosc2_rename_urlpath(old_urlpath::Cstring, new_path::Cstring)::Cint
end

function blosc2_unidim_to_multidim(ndim, shape, i, index)
    @ccall libblosc2.blosc2_unidim_to_multidim(ndim::UInt8, shape::Ptr{Int64}, i::Int64, index::Ptr{Int64})::Cvoid
end

function blosc2_multidim_to_unidim(index, ndim, strides, i)
    @ccall libblosc2.blosc2_multidim_to_unidim(index::Ptr{Int64}, ndim::Int8, strides::Ptr{Int64}, i::Ptr{Int64})::Cvoid
end

function blosc2_get_slice_nchunks(schunk, start, stop, chunks_idx)
    @ccall libblosc2.blosc2_get_slice_nchunks(schunk::Ptr{blosc2_schunk}, start::Ptr{Int64}, stop::Ptr{Int64}, chunks_idx::Ptr{Ptr{Int64}})::Cint
end

function swap_store(dest, pa, size)
    @ccall libblosc2.swap_store(dest::Ptr{Cvoid}, pa::Ptr{Cvoid}, size::Cint)::Cvoid
end

# Skipping MacroDefinition: BLOSC_NO_EXPORT __attribute__ ( ( visibility ( "hidden" ) ) )

# Skipping MacroDefinition: BLOSC_UNUSED_VAR __attribute__ ( ( unused ) )

const BLOSC2_VERSION_MAJOR = 2

const BLOSC2_VERSION_MINOR = 13

const BLOSC2_VERSION_RELEASE = 1

const BLOSC2_VERSION_STRING = "2.13.1"

const BLOSC2_VERSION_DATE = "\$Date:: 2023-01-25 #\$"

const BLOSC2_MAX_DIM = 8

const BLOSC_BLOSCLZ_COMPNAME = "blosclz"

const BLOSC_LZ4_COMPNAME = "lz4"

const BLOSC_LZ4HC_COMPNAME = "lz4hc"

const BLOSC_ZLIB_COMPNAME = "zlib"

const BLOSC_ZSTD_COMPNAME = "zstd"

const BLOSC_BLOSCLZ_LIBNAME = "BloscLZ"

const BLOSC_LZ4_LIBNAME = "LZ4"

const BLOSC_ZLIB_LIBNAME = "Zlib"

const BLOSC_ZSTD_LIBNAME = "Zstd"

# Skipping MacroDefinition: BLOSC_ATTRIBUTE_UNUSED __attribute__ ( ( unused ) )

const BLOSC2_MAX_METALAYERS = 16

const BLOSC2_METALAYER_NAME_MAXLEN = 31

const BLOSC2_MAX_VLMETALAYERS = 8 * 1024

const BLOSC2_VLMETALAYERS_NAME_MAXLEN = BLOSC2_METALAYER_NAME_MAXLEN

