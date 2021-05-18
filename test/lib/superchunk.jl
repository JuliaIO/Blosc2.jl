using Blosc2
import Blosc2.Lib as lb
@testset "init destroy" begin
    sc = lb.blosc2_schunk_new()
    lb.blosc2_schunk_free(sc)
    @test 1 == 1

end

@testset "blosc2_schunk_append_buffer / blosc2_schunk_decompress_chunk" begin

    sc = lb.blosc2_schunk_new()
    n = 100000
    data = rand(1:1000, n)

    sz = lb.blosc2_schunk_append_buffer(sc, data, sizeof(data))
    @test sz > 0
    @test unsafe_load(sc, 1).nchunks == 1
    res = Vector{Int64}(undef, n + 500)
    sz = lb.blosc2_schunk_decompress_chunk(sc, 0, res, sizeof(res))
    @test sz == sizeof(data)
    @test data == res[1:div(sz, sizeof(Int64))]

    sz = lb.blosc2_schunk_append_buffer(sc, data, sizeof(data))
    @test sz > 0


    lb.blosc2_schunk_free(sc)
end

@testset "dealing with chuncks" begin

    sc = lb.blosc2_schunk_new()
    n = 10000
    chuncks_n = 5
    ch_comp_sizes = Vector{Int32}(undef, chuncks_n)
    datas = Vector{Vector{Int}}(undef, chuncks_n)
    for i in 1:chuncks_n
        datas[i] = rand(1:1000, n)
        sz = lb.blosc2_schunk_append_buffer(sc, datas[i], sizeof(datas[i]))
        @test sz > 0
        ch_comp_sizes[i] = sz
    end
    @test unsafe_load(sc, 1).nchunks == chuncks_n

    buff = lb.blosc2_schunk_get_chunk(sc, 1)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[2]

    chn = lb.blosc2_schunk_append_chunk(sc, buff, true)
    @test chn == chuncks_n + 1

    buff = lb.blosc2_schunk_get_chunk(sc, chuncks_n)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[2]

    chn = lb.blosc2_schunk_insert_chunk(sc, 2, buff, true)
    @test chn == chuncks_n + 2

    buff = lb.blosc2_schunk_get_chunk(sc, 2)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[2]

    chn = lb.blosc2_schunk_update_chunk(sc, 1, buff, true)
    @test chn == chuncks_n + 2

    buff = lb.blosc2_schunk_get_chunk(sc, 1)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[2]

    chn = lb.blosc2_schunk_delete_chunk(sc, 0)
    @test chn == chuncks_n + 1

    buff = lb.blosc2_schunk_get_chunk(sc, 0)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[2]

    lb.blosc2_schunk_free(sc)
end

@testset "blosc2_schunk_reorder_offsets" begin
    sc = lb.blosc2_schunk_new()
    n = 10000
    chuncks_n = 5
    ch_comp_sizes = Vector{Int32}(undef, chuncks_n)
    datas = Vector{Vector{Int}}(undef, chuncks_n)
    for i in 1:chuncks_n
        datas[i] = rand(1:1000, n)
        sz = lb.blosc2_schunk_append_buffer(sc, datas[i], sizeof(datas[i]))
        @test sz > 0
        ch_comp_sizes[i] = sz
    end
    @test unsafe_load(sc, 1).nchunks == chuncks_n

    offsets = Int32.(collect(0:chuncks_n-1))
    offsets[4] = 0
    offsets[1] = 3

    r = lb.blosc2_schunk_reorder_offsets(sc, offsets)
    @test r == 0

    buff = lb.blosc2_schunk_get_chunk(sc, 0)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[4]

    buff = lb.blosc2_schunk_get_chunk(sc, 3)
    res = Vector{Int64}(undef, n + 500)
    dctx = lb.blosc2_create_dctx()
    dsz = div(lb.blosc2_decompress_ctx(dctx, buff, sizeof(buff), res, sizeof(res)), sizeof(Int64))
    lb.blosc2_free_ctx(dctx)
    @test dsz == n
    resize!(res, dsz)
    @test res == datas[1]


    lb.blosc2_schunk_free(sc)
end

@testset "blosc2_schunk_get_cparams / dparams" begin
    sc = lb.blosc2_schunk_new()
    params = lb.blosc2_schunk_get_cparams(sc)
    @test params.compcode == 0
    @test params.clevel == 5

    dparams = lb.blosc2_schunk_get_dparams(sc)
    @test dparams.nthreads == 1
    lb.blosc2_schunk_free(sc)
end