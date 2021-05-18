using Blosc2
import Blosc2.Lib as lb
@testset "fixed size" begin
    sc = lb.blosc2_schunk_new()
    content = UInt8[1,2,3,4]
    @test lb.blosc2_meta_exists(sc, "test") < 0
    li = lb.blosc2_meta_add(sc, "test", content, sizeof(content))
    @test li == 0
    li = lb.blosc2_meta_add(sc, "test2", content, sizeof(content))
    @test li == 1

    @test lb.blosc2_meta_exists(sc, "test") == 0
    @test lb.blosc2_meta_exists(sc, "test2") == 1

    @test lb.blosc2_meta_get(sc, "test") == content
    @test lb.blosc2_meta_get(sc, "test2") == content

    @test lb.blosc2_meta_update(sc, "test", UInt8[3, 4, 5, 6], 4) == 0
    @test lb.blosc2_meta_get(sc, "test") == UInt8[3, 4, 5, 6]

    lb.blosc2_schunk_free(sc)
end

@testset "variable size" begin
    sc = lb.blosc2_schunk_new()
    content = UInt8[1,2,3,4]
    @test lb.blosc2_vlmeta_exists(sc, "test") < 0
    li = lb.blosc2_vlmeta_add(sc, "test", content, sizeof(content))
    @test li == 0
    li = lb.blosc2_vlmeta_add(sc, "test2", content, sizeof(content))
    @test li == 1

    @test lb.blosc2_vlmeta_exists(sc, "test") == 0
    @test lb.blosc2_vlmeta_exists(sc, "test2") == 1

    @test lb.blosc2_vlmeta_get(sc, "test") == content
    @test lb.blosc2_vlmeta_get(sc, "test2") == content

    @test lb.blosc2_vlmeta_update(sc, "test", UInt8[3, 4, 5, 6, 7], 5) == 0
    @test lb.blosc2_vlmeta_get(sc, "test") == UInt8[3, 4, 5, 6, 7]

    lb.blosc2_schunk_free(sc)
end