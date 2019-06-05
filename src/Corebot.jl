module Corebot
using Dates

function get_charset_r(date::Dates.Date, nr_b, r)
    year, month, day = Dates.year(date), Dates.month(date), Dates.day(date)
    r = (r + year + (nr_b<<16 + (month<<8)|day)) & 0xFFFFFFFF
    charset = "abcdefghijklmnopqrstuvwxyz0123456789"
    return charset, r
end

function gen_domain(charset, r, tld)
    domain = ""
    len_l, len_u = 0xC, 0x18
    r = (1664525*r + 1013904223) & 0xFFFFFFFF
    len_domain = len_l + r%(len_u-len_l)
    for _ in len_domain:-1:1
        r = ((1664525*r) + 1013904223) & 0xFFFFFFFF
        domain *= charset[r%length(charset)+1]
    end
    domain *= tld
    return r, domain
end

function gen_one(seed="1DBA8930", date=missing, tld="", nr_b=1, num=1)
    domain = ""
    if date === missing
        date = Dates.Date(Dates.now())
    end
    charset, r = get_charset_r(date, nr_b, parse(Int64, seed, base=16))
    for _ in 1:num
        r, domain = gen_domain(charset, r, tld)
    end
    return domain
end

function gen_many(cnt=100)
    res = []
    seed = "1DBA8930"
    date = Dates.Date(Dates.now())
    charset, r = get_charset_r(date, 1, parse(Int64, seed, base=16))
    for _ in 1:cnt
        r, domain = gen_domain(charset, r, "")
        res = [res...,domain]
    end
    return res
end

end  # module Corebot
