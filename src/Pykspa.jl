module Pykspa
using JSON, Dates

function get_sld(length, seed)
    sld = ""
    modulo = 541 * length + 4
    a = length * length
    for i in 1:length
        index = (a + (seed*((seed % 5) + (seed % 123456) + i*((seed & 1) + (seed % 4567))) & 0xFFFFFFFF)) % 26
        a += length
        a &= 0xFFFFFFFFF
        sld *= 'a'+index
        seed += (((7837632 * seed * length) & 0xFFFFFFFF) + 82344) % modulo
    end
    return sld
end

function gen_one(nr=missing, date=missing, set_nr=2, add_tld=false)
    if date === missing
        date = Dates.Date(Dates.now())
    end
    if nr === missing
        nr = rand(Int8)
    end
    seeds = JSON.parsefile(string(@__DIR__) * "/../data/set$(set_nr)_seeds.json")
    dt = Dates.datetime2unix(Dates.DateTime(date))
    days = set_nr==1 ? 20 : 1
    index = trunc(Int64, dt/(days*3600*24))
    if !(string(index) in keys(seeds))
        return domain
    end
    seed = parse(Int64, seeds[string(index)], base=16)
    orig_seed = seed
    s = seed % (nr + 1)
    seed += (s+1)
    len = (seed + nr)%7 + 6
    second_level_domain = get_sld(len,seed)
    if add_tld
        tlds = ["com", "net", "org", "info", "cc"]
            top_level_domain = tlds[(seed & 3)+1]
            domain = second_level_domain * '.' * top_level_domain
    else
        domain = second_level_domain
    end
    return domain
end

function gen_many(cnt=100)
    res = []
    date = Dates.Date(Dates.now())
    seeds = JSON.parsefile(string(@__DIR__) * "/../data/set2_seeds.json")
    dt = Dates.datetime2unix(Dates.DateTime(date))
    days = 1
    index = trunc(Int64, dt/(days*3600*24))
    if !(string(index) in keys(seeds))
        return domain
    end
    seed = parse(Int64, seeds[string(index)], base=16)
    orig_seed = seed

    for dga_nr in 1:cnt
        s = seed % (dga_nr + 1)
        seed += (s+1)
        len = (seed + dga_nr)%7 + 6
        second_level_domain = get_sld(len,seed)
        domain = second_level_domain
        res = [res..., domain]
    end

    return res
end

end  # module Pykspa
