# Constants corresponding to define in c code
const BLOSC_MIN_HEADER_LENGTH = 16 #!< Minimum header length (Blosc1)
const BLOSC_EXTENDED_HEADER_LENGTH = 32 #!< Extended header length (Blosc2, see README_HEADER)
const BLOSC_MAX_OVERHEAD = BLOSC_EXTENDED_HEADER_LENGTH #!< The maximum overhead during compression in bytes. This equals
                                                        #!< to @ref BLOSC_EXTENDED_HEADER_LENGTH now, but can be higher in future
                                                        #!< implementations.
const BLOSC_MAX_BUFFERSIZE = (typemax(Cint) - BLOSC_MAX_OVERHEAD) #!< Maximum source buffer size to be compressed
const BLOSC_MAX_TYPESIZE = 255 #!< Maximum typesize before considering source buffer as a stream of bytes.
                                #!< Cannot be larger than 255.
const BLOSC_MIN_BUFFERSIZE = 128 #!< Minimum buffer size to be compressed. Cannot be smaller than 66.

const BLOSC2_BDEFINED_FILTERS = 32 #!< Blosc-defined filters must be between 0 - 31.
const BLOSC2_REGISTERED_FILTERS = 160 # !< Blosc-registered filters must be between 32 - 159.
const BLOSC2_UDEFINED_FILTERS = 256 #!< User-defined filters must be between 128 - 255.
const BLOSC2_MAX_FILTERS = 6 #!< Maximum number of filters in the filter pipeline
const BLOSC2_MAX_UDFILTERS = 16 #!< Maximum number of filters that a user can register.

const BLOSC2_IO_FILESYSTEM = 0
const BLOSC_IO_LAST_BLOSC_DEFINED = 1
const BLOSC_IO_LAST_REGISTERED = 32

const BLOSC2_MAX_METALAYERS = 16
const BLOSC2_METALAYER_NAME_MAXLEN = 31

const BLOSC2_MAX_VLMETALAYERS = BLOSC2_MAX_METALAYERS
const BLOSC2_VLMETALAYERS_NAME_MAXLEN = BLOSC2_METALAYER_NAME_MAXLEN

"""
Codes for filters.
"""
const  BLOSC_NOFILTER = 0    #!< No filter.
const  BLOSC_SHUFFLE = 1     #!< Byte-wise shuffle.
const  BLOSC_BITSHUFFLE = 2  #!< Bit-wise shuffle.
const  BLOSC_DELTA = 3       #!< Delta filter.
const  BLOSC_TRUNC_PREC = 4  #!< Truncate precision filter.
const  BLOSC_LAST_FILTER = 5 #!< sentinel

"""
Codes for internal flags (see `blosc_cbuffer_metainfo`)
"""
const  BLOSC_DOSHUFFLE = 0x1     #!< byte-wise shuffle
const  BLOSC_MEMCPYED = 0x2      #!< plain copy
const  BLOSC_DOBITSHUFFLE = 0x4  #!< bit-wise shuffle
const  BLOSC_DODELTA = 0x8       #!< delta coding

"""
Codes for the different compressors shipped with Blosc
"""
const  BLOSC_BLOSCLZ = 0
const  BLOSC_LZ4 = 1
const  BLOSC_LZ4HC = 2
const  BLOSC_ZLIB = 4
const  BLOSC_ZSTD = 5
const  BLOSC_LAST_CODEC = 6 #!< Determine the last codec defined by Blosc.

"""
Codes for compression libraries shipped with Blosc (code must be < 8)
"""
const  BLOSC_BLOSCLZ_LIB = 0
const  BLOSC_LZ4_LIB = 1
const  BLOSC_ZLIB_LIB = 3
const  BLOSC_ZSTD_LIB = 4
const  BLOSC_UDCODEC_LIB = 6
const  BLOSC_SCHUNK_LIB = 7   #!< compressor library in super-chunk header

"""
  SplitMode
Split mode for blocks.
NEVER and ALWAYS are for experimenting with compression ratio.
AUTO for nearly optimal behaviour (based on heuristics).
FORWARD_COMPAT provides best forward compatibility (default).
"""
const  BLOSC_ALWAYS_SPLIT = 1
const  BLOSC_NEVER_SPLIT = 2
const  BLOSC_AUTO_SPLIT = 3
const  BLOSC_FORWARD_COMPAT_SPLIT = 4

"""
The codes for compressor formats shipped with Blosc
"""
const  BLOSC_BLOSCLZ_FORMAT = BLOSC_BLOSCLZ_LIB
const  BLOSC_LZ4_FORMAT = BLOSC_LZ4_LIB # LZ4HC and LZ4 share the same format
const  BLOSC_LZ4HC_FORMAT = BLOSC_LZ4_LIB
const  BLOSC_ZLIB_FORMAT = BLOSC_ZLIB_LIB,
const  BLOSC_ZSTD_FORMAT = BLOSC_ZSTD_LIB,
const  BLOSC_UDCODEC_FORMAT = BLOSC_UDCODEC_LIB