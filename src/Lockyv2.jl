module Lockyv2
using Dates

const config = Dict{Int8,Dict}(
1=> Dict{String,Any}(
"seed"=> 7077,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
2=> Dict{String,Any}(
"seed"=> 5566,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
3=> Dict{String,Any}(
"seed"=> 9106,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
4=> Dict{String,Any}(
"seed"=> 5579,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
5=> Dict{String,Any}(
"seed"=> 111,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
6=> Dict{String,Any}(
"seed"=> 9044,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
7=> Dict{String,Any}(
"seed"=> 9099,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
8=> Dict{String,Any}(
"seed"=> 9047,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
9=> Dict{String,Any}(
"seed"=> 9133,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
10=> Dict{String,Any}(
"seed"=> 9199,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
),
11=> Dict{String,Any}(
"seed"=> 9190,
"shift"=> 7,
"tlds"=> ["ru", "info", "biz", "click", "su", "work", "pl", "org", "pw", "xyz"]
)
)

function ror32(v, s)
    v &= 0xFFFFFFFF
    return ((v >> s) | (v << (32-s))) & 0xFFFFFFFF
end

function rol32(v, s)
    v &= 0xFFFFFFFF
    return ((v << s) | (v >> (32-s))) & 0xFFFFFFFF
end

function gen_one(date=missing, config_nr=1, domain_nr=missing, add_tld=false)
    domain = ""
    if date === missing
        date = Dates.Date(Dates.now())
    end
    if domain_nr === missing
        domain_nr = rand(Int16)
    end
    c = config[config_nr]
    seed_shifted = rol32(c["seed"], 17)
    dnr_shifted = rol32(domain_nr, 21)

    k = 0
    year,month,day = Dates.year(date),Dates.month(date),Dates.day(date)
    for _ in 1:7
        t_0 = ror32(0xB11924E1 * (year + k + 0x1BF5), c["shift"]) & 0xFFFFFFFF
        t_1 = ((t_0 + 0x27100001) ⊻ k) & 0xFFFFFFFF
        t_2 = (ror32(0xB11924E1 * (t_1 + c["seed"]), c["shift"])) & 0xFFFFFFFF
        t_3 = ((t_2 + 0x27100001) ⊻ t_1) & 0xFFFFFFFF
        t_4 = (ror32(0xB11924E1 * (trunc(Int64,day/2) + t_3), c["shift"])) & 0xFFFFFFFF
        t_5 = (0xD8EFFFFF - t_4 + t_3) & 0xFFFFFFFF
        t_6 = (ror32(0xB11924E1 * (month + t_5 - 0x65CAD), c["shift"])) & 0xFFFFFFFF
        t_7 = (t_5 + t_6 + 0x27100001) & 0xFFFFFFFF
        t_8 = (ror32(0xB11924E1 * (t_7 + seed_shifted + dnr_shifted), c["shift"])) & 0xFFFFFFFF
        k = ((t_8 + 0x27100001) ⊻ t_7) & 0xFFFFFFFF
        year += 1
    end

    length = (k % 11) + 7
    for i in 1:length
        k = (ror32(0xB11924E1*rol32(k, i), c["shift"]) + 0x27100001) & 0xFFFFFFFF
        domain *= 'a' + k % 25
    end

    k = ror32(k*0xB11924E1, c["shift"])
    tlds = c["tlds"]
    tld_i = ((k + 0x27100001) & 0xFFFFFFFF)%10 + 1

    if add_tld
        domain *= '.' + tlds[tld_i]
    end

    return domain
end

function gen_many(cnt=100)
    res = []
    date = Dates.Date(Dates.now())
    each_domain_items = trunc(Int64, cnt/11)
    remain_items = cnt%11
    for i in 1:11
        for j in 1:each_domain_items
            res = [res..., gen_one(date,i,j)]
        end
    end
    for i in 1:remain_items
        res = [res..., gen_one(date,rand(1:11),rand(1:each_domain_items))]
    end
    return res
end

end  # module Lockyv2
