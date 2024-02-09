using Blosc2: Compressor, fill_available_compressors!, available_compressors, available_compressors_names, has_compressor, default_compressor
@testset "compressors" begin
    cprs = Dict{Symbol,Compressor}()
    fill_available_compressors!(cprs)
    @test haskey(cprs, :blosclz)
    @test haskey(available_compressors(), :blosclz)
    @test has_compressor(:blosclz)

    @test Blosc2.default_compressor_name() == :blosclz

    @test Blosc2.compressor_by_name(:blosclz) == Blosc2.default_compressor()
end

@testset "filters" begin
    @test has_filter(:shuffle)
    @test !has_filter(:shuffle2)

    f = Blosc2.make_filter(:nofilter)
    @test f.id == 0
    @test f.meta == 0

    f = Blosc2.make_filter(:delta, 10)
    @test f.id == Blosc2.Lib.BLOSC_DELTA
    @test f.meta == 10

    @test :shuffle in available_filter_names()

    @test filter_description(:nofilter) == "No filter."

    pipe = filter_pipeline(:nofilter, :trunc_prec=>22, :shuffle)
    @test pipe.filters[1].name == :nofilter
    @test pipe.filters[1].id == 0
    @test pipe.filters[1].meta == 0


    @test pipe.filters[2].name == :trunc_prec
    @test pipe.filters[2].id == Blosc2.Lib.BLOSC_TRUNC_PREC
    @test pipe.filters[2].meta == 22

    @test pipe.filters[3].name == :shuffle
    @test pipe.filters[3].id == Blosc2.Lib.BLOSC_SHUFFLE
    @test pipe.filters[3].meta == 0

    for i in 4:Blosc2.max_filters_count()
        @test pipe.filters[i].name == :nofilter
        @test pipe.filters[i].id == 0
        @test pipe.filters[i].meta == 0

    end
    pipe = filter_pipeline()
    for i in 1:Blosc2.max_filters_count()
        @test pipe.filters[i].name == :nofilter
        @test pipe.filters[i].id == 0
        @test pipe.filters[i].meta == 0

    end

end

@testset "params" begin
    params = Blosc2.CompressionParams()
    @test params.compressor.code == default_compressor().code
    params = Blosc2.CompressionParams(Int32)
    @test params.typesize == sizeof(Int32)
    @test params.compressor.name == :blosclz

    params = Blosc2.CompressionParams(Int8; compressor = :lz4, level = 9, nthreads = 3, blocksize = 10, splitmode = true)
    @test params.typesize == sizeof(Int8)
    @test params.compressor.name == :lz4
    @test params.level == 9
    @test params.nthreads == 3
    @test params.blocksize == 10
    @test params.splitmode == true

    cp = Blosc2.make_cparams(params)
    @test cp.typesize == sizeof(Int8)
    @test cp.compcode == 1
    @test cp.clevel == 9
    @test cp.nthreads == 3
    @test cp.blocksize == 10
    @test cp.splitmode == 1
    @test cp.filters == (Blosc2.Lib.BLOSC_SHUFFLE, 0, 0, 0, 0, 0)
    @test cp.filters_meta == (0, 0, 0, 0, 0, 0)

    params = Blosc2.CompressionParams(Int8; filter_pipeline = filter_pipeline(:trunc_prec=>22, :shuffle))
    cp = Blosc2.make_cparams(params)
    @test cp.filters == (Blosc2.Lib.BLOSC_TRUNC_PREC, Blosc2.Lib.BLOSC_SHUFFLE, 0, 0, 0, 0)
    @test cp.filters_meta == (22, 0, 0, 0, 0, 0)


    dparams = Blosc2.DecompressionParams(nthreads = 10)
    dp = Blosc2.make_dparams(dparams)
    @test dp.nthreads == 10
end

@testset "context" begin
    ctx = Blosc2.Context(Blosc2.CompressionParams(level = 9))
    @test ctx.params.nthreads == 1
    @test ctx.params.level == 9
    @test typeof(ctx) == Blosc2.CompressionContext
    @test typeof(ctx.params) == Blosc2.CompressionParams

    ctx = Blosc2.CompressionContext(Blosc2.CompressionParams(level = 8))
    @test ctx.params.nthreads == 1
    @test ctx.params.level == 8
    @test typeof(ctx) == Blosc2.CompressionContext
    @test typeof(ctx.params) == Blosc2.CompressionParams

    ctx = Blosc2.CompressionContext(level = 8, nthreads = 2)
    @test ctx.params.nthreads == 2
    @test ctx.params.level == 8
    @test typeof(ctx) == Blosc2.CompressionContext
    @test typeof(ctx.params) == Blosc2.CompressionParams

    ctx = Blosc2.CompressionContext()
    @test ctx.params == Blosc2.CompressionParams()
    @test typeof(ctx.params) == Blosc2.CompressionParams


    ctx = Blosc2.Context(Blosc2.DecompressionParams(nthreads = 2))
    @test ctx.params.nthreads == 2
    @test typeof(ctx) == Blosc2.DecompressionContext
    @test typeof(ctx.params) == Blosc2.DecompressionParams

    ctx = Blosc2.DecompressionContext(Blosc2.DecompressionParams(nthreads = 3))
    @test ctx.params.nthreads == 3
    @test typeof(ctx) == Blosc2.DecompressionContext
    @test typeof(ctx.params) == Blosc2.DecompressionParams

    ctx = Blosc2.DecompressionContext(nthreads = 3)
    @test ctx.params.nthreads == 3
    @test typeof(ctx) == Blosc2.DecompressionContext
    @test typeof(ctx.params) == Blosc2.DecompressionParams

    ctx = Blosc2.DecompressionContext()
    @test typeof(ctx.params) == Blosc2.DecompressionParams
    @test ctx.params == Blosc2.DecompressionParams()

    ctx = CompressionContext(Int32)
    @test ctx.params.typesize == 4
    ctx = CompressionContext(Int32, typesize = 2)
    @test ctx.params.typesize == 2
end

@testset "compress!/decompress!/info" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = Blosc2.compress!(Blosc2.CompressionContext(), buffer, data)
    @test Blosc2.compressed_sizeof(buffer) == sz
    @test Blosc2.uncompressed_sizeof(buffer) == n * sizeof(Int64)
    res = Vector{Int64}(undef, n)
    Blosc2.decompress!(Blosc2.DecompressionContext(),  res, buffer)
    @test res == data

    res = Vector{Int64}(undef, ceil(Int64, n/2))
    @test_throws BoundsError Blosc2.decompress!(Blosc2.DecompressionContext(),  res, buffer)

    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = Blosc2.compress!(buffer, data)
    @test Blosc2.compressed_sizeof(buffer) == sz
    @test Blosc2.uncompressed_sizeof(buffer) == n * sizeof(Int64)
    res = Vector{Int64}(undef, n)
    Blosc2.decompress!(res, buffer)
    @test res == data

    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = Blosc2.compress!(buffer, data; level = 0)
    @test Blosc2.compressed_sizeof(buffer) == sz
    @test sz == sizeof(buffer)
    @test Blosc2.uncompressed_sizeof(buffer) == n * sizeof(Int64)
    res = Vector{Int64}(undef, n)
    dsz = Blosc2.decompress!(res, buffer)
    @test dsz == n
    @test res == data
end

@testset "compress/decompress" begin
    n = 100000
    data = rand(1:1000, n)
    buffer = compress(CompressionContext(), data)
    @test sizeof(buffer) > 0
    @test sizeof(buffer) < max_compressed_size(data)
    res = decompress(DecompressionContext(), Int, buffer)
    @test res == data

    data = rand(Base.OneTo{Int16}(1000), n)
    buffer = compress(data, level = 9)
    @test sizeof(buffer) > 0
    @test sizeof(buffer) < max_compressed_size(data)
    res = decompress(Int16, buffer, nthreads = 2)
    @test res == data

    data = rand(Base.OneTo{Int16}(1000), n)
    buffer = compress(data, 51:60, level = 9)
    @test sizeof(buffer) > 0
    @test sizeof(buffer) < max_compressed_size(data)
    res = decompress(Int16, buffer, nthreads = 2)
    @test res == data[51:60]

end

@testset "unsafe compress/decompress" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = GC.@preserve data buffer begin
        unsafe_compress!(CompressionContext(), pointer(buffer), sizeof(buffer), pointer(data), sizeof(data))
    end
    @test sz > 0
    res = Vector{Int64}(undef, n)
    dsz = GC.@preserve data buffer begin
        unsafe_decompress!(DecompressionContext(), pointer(res), sizeof(res), pointer(buffer), sizeof(buffer))
    end
    @test dsz == n
    @test res == data

    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = GC.@preserve data buffer begin
        unsafe_compress!(pointer(buffer), sizeof(buffer), pointer(data), sizeof(data), level = 1)
    end
    @test sz > 0
    res = Vector{Int64}(undef, n)
    dsz = GC.@preserve data buffer begin
        unsafe_decompress!(pointer(res), sizeof(res), pointer(buffer), sizeof(buffer), nthreads = 2)
    end
    @test dsz == n
    @test res == data
end

@testset "offsets compress/decompress" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    pos = 1
    sz = compress!(CompressionContext(),buffer, data, pos, 1:500)
    @test sz > 0
    pos += sz
    sz = compress!(CompressionContext(),buffer, data, pos, 501:1000)
    @test sz > 0
    result = Vector{Int64}(undef, 1500)

    sz = decompress!(DecompressionContext(), result, buffer, 501, pos)
    @test sz == 500
    @test result[501:1000] == data[501:1000]

    sz = decompress!(DecompressionContext(), result, buffer, 1001, 1)
    @test sz == 500
    @test result[1001:1500] == data[1:500]

    n = 10000
    data = rand(Base.OneTo{Int16}(1000), n)
    buffer = Blosc2.make_compress_buffer(data)
    pos = 1
    sz = compress!(buffer, data, pos, 1:500)
    @test sz > 0
    pos += sz
    sz = compress!(buffer,  data, pos, 501:1000)
    @test sz > 0
    result = Vector{Int16}(undef, 1500)

    sz = decompress!(result, buffer, 501, pos)
    @test sz == 500
    @test result[501:1000] == data[501:1000]

    sz = decompress!(result, buffer, 1001, 1)
    @test sz == 500
    @test result[1001:1500] == data[1:500]
end

@testset "decompress_items!" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    pos = 1
    sz = compress!(CompressionContext(),buffer, data, pos, 1:500)
    @test sz > 0
    pos += sz
    sz = compress!(CompressionContext(),buffer, data, pos, 501:1000)
    @test sz > 0
    result = Vector{Int64}(undef, 1500)

    r = decompress_items!(DecompressionContext(), result,  buffer, 11:20, 50, pos)
    @test r == 10
    @test result[50:59] == data[511:520]

    r = decompress_items!(result,  buffer, 11:20)
    @test r == 10
    @test result[1:10] == data[11:20]

end

@testset "filters test" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = compress(data)
    sz1 = sizeof(buffer)
    sdata = sort(data)
    sbuffer = compress(sdata, filter_pipeline = filter_pipeline(:delta, :shuffle))
    sz2 = sizeof(sbuffer)
    @test sz2 < sz1
    @test decompress(Int, sbuffer) == sdata
end
