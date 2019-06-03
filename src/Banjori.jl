module Banjori

function map2lowcase(s)
    return 97 + (s-97)%26
end

function next_domain(seed)
    sl = Array{UInt8,1}(seed)
    sl[1] = map2lowcase(sl[1]+sl[4])
    sl[2] = map2lowcase(sl[1]+2*sl[2])
    sl[3] = map2lowcase(sl[1]+sl[3]-1)
    sl[4] = map2lowcase(sl[2]+sl[3]+sl[4])
    return join([Char(x) for x in sl])
end

function gen_one(seed="cckuailong")
    if length(seed) < 4
        print("Banjori seed length must >= 4")
        return missing
    else
        return next_domain(seed)
    end
end

function gen_many(num)
    res = []
    seeds = ["somestring", "firetruck", "bulldozer", "airplane", "racecar",
            "apartment", "laptop", "laptopcomp", "malwareisbad", "crazytrain",
            "thepolice", "fivemonkeys", "hockey", "football", "baseball",
            "basketball", "trackandfield", "fieldhockey", "softball", "redferrari",
            "blackcheverolet", "yellowelcamino", "blueporsche", "redfordf150",
            "purplebmw330i", "subarulegacy", "hondacivic", "toyotaprius",
            "sidewalk", "pavement", "stopsign", "trafficlight", "turnlane",
            "passinglane", "trafficjam", "airport", "runway", "baggageclaim",
            "passengerjet", "delta1008", "american765", "united8765", "southwest3456",
            "albuquerque", "sanfrancisco", "sandiego", "losangeles", "newyork",
            "atlanta", "portland", "seattle", "washingtondc"]
    seed_len = length(seeds)
    each_seed_items = num / seed_len
    remain_items = num % seed_len
    for seed in seeds
        for i in 1:each_seed_items
            seed = next_domain(seed)
            res = [res..., seed]
        end
    end
    for seed in seeds[1:remain_items]
        seed = next_domain(seed)
        res = [res..., seed]
    end

    return res
end

end  # module Banjori
