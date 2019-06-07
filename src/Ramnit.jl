module Ramnit
mutable struct RANDINT
    seed
end

function rand_int_modulus!(r, modulus)
    ix = r.seed
    ix = 16807*(ix % 127773) - 2836*trunc(Int64, ix/127773) & 0xFFFFFFFF
    r.seed = ix
    return ix % modulus
end

function gen_one(seed=0x123abc12, tld="")
    domain = ""
    r = RANDINT(seed)
    seed_a = r.seed
    domain_len = rand_int_modulus!(r,12) + 8
    seed_b = r.seed
    for i in 1:domain_len
        domain *= 'a' + rand_int_modulus!(r,25)
    end
    domain *= tld
    return domain
end

function gen_many(cnt=100)
    res = []
    r = RANDINT(0x123abc12)
    for _ in 1:cnt
        seed_a = r.seed
        domain_len = rand_int_modulus!(r,12) + 8
        seed_b = r.seed
        domain = ""
        for i in 1:domain_len
            domain *= 'a' + rand_int_modulus!(r,25)
        end
        m = seed_a*seed_b
        r.seed = (m + trunc(Int64, m/(2^32))) % 2^32
        res =[res..., domain]
    end
    return res
end

end  # module Ramnit
