module Dga
export Banjori, Corebot, Cryptolocker, Dircrypt, Kraken
export Lockyv2, Pykspa, Qakbot, Ramdo, Ramnit, Simda

include(string(@__DIR__) * "/Banjori.jl")
include(string(@__DIR__) * "/Corebot.jl")
include(string(@__DIR__) * "/Cryptolocker.jl")
include(string(@__DIR__) * "/Dircrypt.jl")
include(string(@__DIR__) * "/Kraken.jl")
include(string(@__DIR__) * "/Lockyv2.jl")
include(string(@__DIR__) * "/Pykspa.jl")
include(string(@__DIR__) * "/Qakbot.jl")
include(string(@__DIR__) * "/Ramdo.jl")
include(string(@__DIR__) * "/Ramnit.jl")
include(string(@__DIR__) * "/Simda.jl")
end # module
