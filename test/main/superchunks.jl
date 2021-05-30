using Blosc2:Lib
@testset "storage" begin
    s = Storage()
    @test s.contiguous == false
    @test isnothing(s.urlpath)
    @test isnothing(s.cparams)
    @test isnothing(s.dparams)

    Blosc2.with_preserved_blosc2_storage(s) do bs
        @test bs.contiguous == false
        @test bs.urlpath == C_NULL
        @test bs.cparams == C_NULL
        @test bs.dparams == C_NULL
        @test bs.io == C_NULL
    end

    s = Storage(contiguous = true,
        urlpath = "test",
        cparams = CompressionParams(Int32),
        dparams = DecompressionParams(nthreads = 2)
    )

    @test s.contiguous == true
    @test s.urlpath == "test"
    @test s.cparams.typesize == 4
    @test s.dparams.nthreads == 2

    Blosc2.with_preserved_blosc2_storage(s) do bs
        @test bs.contiguous == true
        @test unsafe_string(bs.urlpath) == "test"
        @test bs.cparams != C_NULL
        @test bs.dparams != C_NULL
        @test unsafe_load(bs.cparams.typesize) == 4
        @test unsafe_load(bs.dparams.nthreads) == 2
        @test bs.io == C_NULL
    end
end

@testset "superchunk create" begin
    schunk = SChunk(Storage())
    @test clevel(schunk) == 5
    @test typesize(schunk) == 8

    schunk = SChunk(Storage(cparams = CompressionParams(Int16, level = 9)))
    @test clevel(schunk) == 9
    @test typesize(schunk) == 2
end

@testset "schunk append buffer" begin
    schunk = SChunk(Storage())
    n = 100000
    data = rand(1:1000, n)
    r = GC.@preserve data begin
        unsafe_append_buffer!(schunk, pointer(data), sizeof(data))
    end
    @test r == 1

    data2 = rand(1:1000, floor(Int64, n/2))
    r = GC.@preserve data begin
        unsafe_append_buffer!(schunk, pointer(data2), sizeof(data2))
    end
    @test r == 2

    @test nchunks(schunk) == 2

    res = Vector{Int64}(undef, n)
    r = GC.@preserve res begin
        unsafe_decompress_chunk(schunk, 2, pointer(res), sizeof(res))
    end
    @test r == length(data2)
    @test res[1:r] == data2


    r = GC.@preserve res begin
        unsafe_decompress_chunk(schunk, 1, pointer(res), sizeof(res))
    end
    @test r == n
    @test res == data

    @test_throws BoundsError unsafe_decompress_chunk(schunk, 3, pointer(res), sizeof(res))
end

@testset "schunk unsafe chunk manipulations" begin
    schunk = SChunk(Storage())
    n = 100000
    data = rand(1:1000, n)
    r = GC.@preserve data begin
        unsafe_append_buffer!(schunk, pointer(data), sizeof(data))
    end
    println(chunksize(schunk))
    @test r == 1

    data2 = rand(1:1000, n)
    chunk = compress(data2)
    r = GC.@preserve chunk begin
        unsafe_append_chunk!(schunk, pointer(chunk))
    end
    @test r == 2

    data3 = rand(1:1000, n)
    chunk = compress(data3)
    r = GC.@preserve chunk begin
        unsafe_insert_chunk!(schunk, 2, pointer(chunk))
    end
    @test r == 3

    res = Vector{Int64}(undef, n)
    r = GC.@preserve res begin
        unsafe_decompress_chunk(schunk, 2, pointer(res), sizeof(res))
    end
    @test res == data3

    data4 = rand(1:1000, n)
    chunk = compress(data4)
    r = GC.@preserve chunk begin
        unsafe_update_chunk!(schunk, 2, pointer(chunk))
    end
    @test r == 3
    r = GC.@preserve res begin
        unsafe_decompress_chunk(schunk, 2, pointer(res), sizeof(res))
    end
    @test res == data4

    @test delete_chunk!(schunk, 2) == 2

    r = GC.@preserve res begin
        unsafe_decompress_chunk(schunk, 2, pointer(res), sizeof(res))
    end
    @test res == data2

    chunk2 = unsafe_get_chunk(schunk, 1)
    @test decompress(Int64, chunk2) == data

end