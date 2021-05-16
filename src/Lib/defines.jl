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


"""
    FilterCodes
Codes for filters.
"""
@enum FilterCodes begin
  BLOSC_NOFILTER = 0    #!< No filter.
  BLOSC_SHUFFLE = 1     #!< Byte-wise shuffle.
  BLOSC_BITSHUFFLE = 2  #!< Bit-wise shuffle.
  BLOSC_DELTA = 3       #!< Delta filter.
  BLOSC_TRUNC_PREC = 4  #!< Truncate precision filter.
  BLOSC_LAST_FILTER = 5 #!< sentinel
end

"""
  FlagCodes
Codes for internal flags (see `blosc_cbuffer_metainfo`)
"""
@enum FlagCodes begin
  BLOSC_DOSHUFFLE = 0x1     #!< byte-wise shuffle
  BLOSC_MEMCPYED = 0x2      #!< plain copy
  BLOSC_DOBITSHUFFLE = 0x4  #!< bit-wise shuffle
  BLOSC_DODELTA = 0x8       #!< delta coding
end