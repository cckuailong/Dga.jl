module Qakbot
using Printf,CRC32c,Dates

mutable struct OBJ
    index
    mt
end

function date2seed(date, seed)
    dx = trunc(Int64, (Dates.day(date)-1) / 10)
    dx = dx<=2 ? dx : 2
    data = @sprintf("%d.%s,%s,%s", dx,lowercase(Dates.monthabbr(date)),Dates.year(date),seed)
    crc = crc32c(data)
    return crc
end

function _int32(x)
    return UInt32(0xFFFFFFFF&x)
end

function rand_int!(obj, lower, upper)
    r = extract_num!(obj)
    r &= 0xFFFFFFF
    t = lower + r/(2^28)*(upper-lower+1)
    return trunc(Int64, t)
end

function extract_num!(obj)
    if obj.index >=625
        twist!(obj)
    end
    y = obj.mt[obj.index]
    y = y ⊻ y >> 11
    y = y ⊻ y << 7 & 2636928640
    y = y ⊻ y << 15 & 4022730752
    y = y ⊻ y >> 18

    obj.index += + 1
    return _int32(y)
end

function twist!(obj)
    for i in 1:624
        y = _int32((obj.mt[i] & 0x80000000) + (obj.mt[(i + 1)%624 + 1] & 0x7fffffff))
        obj.mt[i] = obj.mt[(i + 397)%624 + 1] ⊻ y >> 1

        if y % 2 != 0
            obj.mt[i] = obj.mt[i] ⊻ 0x9908b0df
        end
    end
    obj.index = 1
end

function gen_one(date=missing, seed=rand(Int16), tlds=missing, sandbox=false)
    domain = ""
    if date === missing
        date = Dates.Date(Dates.now())
    end
    obj = OBJ(624, zero(1:624))
    obj.mt[1] = date2seed(date, seed) + sandbox
    for i in 2:624
        obj.mt[i] = _int32(1812433253 * (obj.mt[i-1] ⊻ obj.mt[i-1]>>30) + i-1)
    end
    len = rand_int!(obj,8,25)
    for l in 1:len
        domain *= 'a'+rand_int!(obj,0,25)
    end
    if tlds !== missing && length(tlds) != 0
        tld_nr = rand_int!(obj,0,length(tlds)-1)
        domain *= "." * tlds[tld_nr+1]
    end

    return domain
end

function gen_many(cnt=100)
    res = []
    date = Dates.Date(Dates.now())
    seed = rand(typeof(cnt))
    obj = OBJ(624, zero(1:624))
    obj.mt[1] = date2seed(date, seed)
    for i in 2:624
        obj.mt[i] = _int32(1812433253 * (obj.mt[i-1] ⊻ obj.mt[i-1]>>30) + i-1)
    end
    for _ in 1:cnt
        domain = ""
        len = rand_int!(obj,8,25)
        for l in 1:len
            domain *= 'a'+rand_int!(obj,0,25)
        end
        res = [res..., domain]
    end

    return res
end

end  # module Qakbot
