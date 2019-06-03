using Dga
using Test

@testset "Dga.jl" begin
    @testset "Banjori" begin
        @test Banjori.gen_one() == "pfrMailong"
        @test length(Banjori.gen_many(100)) == 100
    end
    @testset "Corebot" begin
        @test Corebot.gen_one() == "zzz"
    end
end
