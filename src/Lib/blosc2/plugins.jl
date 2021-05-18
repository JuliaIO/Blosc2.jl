"""
    blosc2_io

Input/Output parameters.
"""
struct blosc2_io
  id ::UInt8 #!< The IO identifier.
  params ::Ref{Cvoid} #!< The IO parameters.
  blosc2_io(;id = BLOSC2_IO_FILESYSTEM, params = C_NULL) = new(id, params)
end