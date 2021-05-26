using Blosc2: Compressor, fill_available_compressors!, available_compressors, available_compressors_names, has_compressor, default_compressor
@testset "compressors" begin
    cprs = Dict{Symbol,Compressor}()
    fill_available_compressors!(cprs)
    @test haskey(cprs, :blosclz)
    @test haskey(available_compressors(), :blosclz)
    @test has_compressor(:blosclz)

    @test Blosc2.default_compressor_name() == :blosclz

    @test Blosc2.compressor(:blosclz) == Blosc2.default_compressor()
end

@testset "params" begin
    params = Blosc2.CompressionParams()
    @test params.compressor.code == default_compressor().code
    params = Blosc2.CompressionParams(Int32)
    @test params.typesize == sizeof(Int32)
    @test params.compressor.name == :blosclz

    params = Blosc2.CompressionParams(:lz4, Int8; level = 9, nthreads = 3, blocksize = 10, splitmode = true)
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

    ctx = Blosc2.DecompressionContext()
    @test typeof(ctx.params) == Blosc2.DecompressionParams
    @test ctx.params == Blosc2.DecompressionParams()

end

@testset "compress/decompress" begin
    n = 10000
    data = rand(1:1000, n)
    buffer = Blosc2.make_compress_buffer(data)
    sz = Blosc2.compress!(Blosc2.CompressionContext(), buffer, data)
    res = Vector{Int64}(undef, n)
    Blosc2.decompress!(Blosc2.DecompressionContext(),  res, buffer)
    @test res == data
end