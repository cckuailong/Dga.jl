module Kraken
using Dates

function trans(r)
    return (1103515245 * r + 12435) & 0xFFFFFFFF
end

function crop(r)
    return trunc(Int64, r/256) % 32768
end

function gen_one(index=missing, date=missing, seed_set='a', tld_set_nr=3, tmp=true)
    domain = ""
    if index === missing
        index = trunc(Int64, rand()*10000)
    end
    if date === missing
        date = Dates.Date(Dates.now())
    end
    tld_sets = Dict{Int8,Any}(1=>["com", "net", "tv", "cc"],
                            2=>["dyndns.org", "yi.org", "dynserv.com", "mooo.com"],
                            3=>missing)
    seeds = Dict{Char,Dict}('a'=>Dict{String,Int64}("ex"=>24938314, "nex"=>24938315),
                            'b'=>Dict{String,Int64}("ex"=>1600000, "nex"=>1600001))
    tld = tld_sets[tld_set_nr]

    domain_nr = trunc(Int64, index/2)
    if tmp
        r = 3*domain_nr + seeds[seed_set]["ex"]
    else
        r = 3*domain_nr + seeds[seed_set]["nex"]
    end
    discards = trunc(Int64, (Dates.datetime2unix(Dates.now())-1207000000)/604800) + 2
    if domain_nr % 9 < 8
        if domain_nr % 9 >= 6
            discards -= 1
        end
        for _ in 1:discards
            r = crop(trans(r))
        end
    end

    rands = [0,0,0]
    for i in 1:3
        r = trans(r)
        rands[i] = crop(r)
    end
    len_domain = (rands[1]*rands[2]+rands[3])%6 + 7
    for _ in 1:len_domain
        r = trans(r)
        ch = crop(r)%26 + 97
        domain *= Char(ch)
    end
    if tld !== missing
        domain *= "."*tld[domain_nr%4+1]
    end
    return domain
end

function gen_many(cnt=100)
    res = []
    for i in 1:cnt
        res = [res..., gen_one(i*2,missing,rand(['a','b']),3,rand(Bool))]
    end
    return res
end

end  # module Kraken
