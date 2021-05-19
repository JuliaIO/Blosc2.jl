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
end