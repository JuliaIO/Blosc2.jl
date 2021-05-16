using Blosc2
import Blosc2.Lib as lb
@testset "init destroy" begin
    lb.blosc_init()
    lb.blosc_destroy()
    @test 1 == 1
end

@testset "blosc_compress / decompress" begin
    lb.blosc_init()
    n = 10000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc_compress(9, lb.BLOSC_BITSHUFFLE, sizeof(Int64), sizeof(data), data, buff, sizeof(buff))
    @test sz > 0
    res = Vector{Int64}(undef, n + 500)
    sz = lb.blosc_decompress(buff, res, sizeof(res))
    @test sz == sizeof(data)
    @test data == res[1:div(sz, sizeof(Int64))]
    lb.blosc_destroy()
end

@testset "blosc_getitem" begin
    lb.blosc_init()
    n = 10000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc_compress(9, lb.BLOSC_BITSHUFFLE, sizeof(Int64), sizeof(data), data, buff, sizeof(buff))
    res = Int64[1, 2]
    for i = 1 : div(n, 2)
        sz = lb.blosc_getitem(buff, (i - 1) * 2, 2, res)
        @test sz == sizeof(res)
        @test res == data[(i - 1)*2 + 1:i*2]
    end
    lb.blosc_destroy()
end

@testset "blosc_get_nthreads / set_nthreads" begin
    lb.blosc_init()
    n = lb.blosc_get_nthreads()
    @test n == 1
    n = lb.blosc_set_nthreads(2)
    @test n == 1
    n = lb.blosc_get_nthreads()
    @test n == 2
    lb.blosc_destroy()
end

@testset "blosc_get_compressor / set_compressor" begin
    lb.blosc_init()
    r = lb.blosc_get_compressor()
    @test r == "blosclz"
    @test lb.blosc_set_compressor("lz4") >= 0
    r = lb.blosc_get_compressor()
    @test r == "lz4"
    lb.blosc_destroy()
end

@testset "set_delta / set_blocksize / free_resouces" begin
    lb.blosc_init()
    lb.blosc_set_delta(1)
    lb.blosc_set_blocksize(1000)
    r = lb.blosc_free_resources()
    @test r == 0
    lb.blosc_destroy()
end

@testset "blosc_cbufer_sizes / metainfo / versions / complib" begin
    lb.blosc_init()
    n = 10000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc_compress(9, lb.BLOSC_BITSHUFFLE, sizeof(Int64), sizeof(data), data, buff, sizeof(buff))
    sizes = lb.blosc_cbuffer_sizes(buff)
    @test sizes.nbytes == sizeof(data)
    @test sizes.cbytes == sz
    meta = lb.blosc_cbuffer_metainfo(buff)
    @test meta.typesize == 8
    versions = lb.blosc_cbuffer_versions(buff)
    @test 1 == 1
    complib = lb.blosc_cbuffer_complib(buff)
    @test complib == "LZ4"
    lb.blosc_destroy()
end

@testset "utilites" begin
    lb.blosc_init()
    @test lb.blosc_compcode_to_compname(0) == "blosclz"
    @test_throws ErrorException lb.blosc_compcode_to_compname(100)
    @test lb.blosc_compname_to_compcode("blosclz") == 0
    @test lb.blosc_compname_to_compcode("blosclz_rrrr") == -1
    @test length(lb.blosc_list_compressors()) > 1
    v = lb.blosc_get_version_string()
    @test !isempty(v)

    info = lb.blosc_get_complib_info("blosclz")
    @test info.code == 0
    @test info.complib == "BloscLZ"

    lb.blosc_destroy()
end