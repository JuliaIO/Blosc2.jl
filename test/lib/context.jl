using Blosc2
import Blosc2.Lib as lb
@testset "init destroy" begin
    ctx = lb.blosc2_create_cctx()
    lb.blosc2_free_ctx(ctx)
    @test 1 == 1

    ctx = lb.blosc2_create_dctx()
    lb.blosc2_free_ctx(ctx)
    @test 1 == 1
end

@testset "blosc2_compress_ctx / decompress" begin
    ctx = lb.blosc2_create_cctx(lb.blosc2_cparams(typesize = sizeof(Int64)))
    n = 10000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc2_compress_ctx(ctx, data, sizeof(data), buff, sizeof(buff))
    @test sz > 0
    lb.blosc2_free_ctx(ctx)

    dctx = lb.blosc2_create_dctx()

    res = Vector{Int64}(undef, n + 500)
    sz = lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res))
    @test sz == sizeof(data)
    @test data == res[1:div(sz, sizeof(Int64))]

    lb.blosc2_free_ctx(dctx)
end

@testset "blosc2_getitem_ctx" begin
    ctx = lb.blosc2_create_cctx(lb.blosc2_cparams(typesize = sizeof(Int64)))
    n = 10000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc2_compress_ctx(ctx, data, sizeof(data), buff, sizeof(buff))
    @test sz > 0
    lb.blosc2_free_ctx(ctx)

    dctx = lb.blosc2_create_dctx()

    res = Int64[1, 2]

    for i = 1 : div(n, 2)
        sz = lb.blosc2_getitem_ctx(dctx, buff, sizeof(buff), (i - 1) * 2, 2, res, sizeof(res))
        @test sz == sizeof(res)
        @test res == data[(i - 1)*2 + 1:i*2]
    end
    lb.blosc2_free_ctx(dctx)
end

@testset "blosc2_set_maskout" begin
    ctx = lb.blosc2_create_cctx(lb.blosc2_cparams(typesize = sizeof(Int64), blocksize = 80000))
    n = 100000
    data = rand(1:1000, n)
    buff = Vector{UInt8}(undef, sizeof(data) + lb.BLOSC_MAX_OVERHEAD)
    sz = lb.blosc2_compress_ctx(ctx, data, sizeof(data), buff, sizeof(buff))
    @test sz > 0
    lb.blosc2_free_ctx(ctx)

    dctx = lb.blosc2_create_dctx()

    mask = Vector{Bool}(undef, 10)
    fill!(mask, false)
    mask[5:end] .= true
    r = lb.blosc2_set_maskout(dctx, mask, sizeof(mask))

    res = Vector{Int64}(undef, n + 500)
    fill!(res, 0)
    sz = lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res))
    @test sz == sizeof(data)
    int_block = div(80000,sizeof(Int))
    @test data[1:int_block*4] == res[1:int_block*4]
    @test sum(res[int_block*4 + 1 : end]) == 0

    lb.blosc2_free_ctx(dctx)
end