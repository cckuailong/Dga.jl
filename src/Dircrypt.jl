module Dircrypt

function rand_modulus(ix, modulus)
    ix = 16807*(ix % 127773) - 2836*trunc(Int64, ix / 127773) & 0xFFFFFFFF
    return ix, ix % modulus
end

function gen_one(seed="1DBA8930", tld="")
    ix = trunc(Int64, rand()*parse(Int64, seed, base=16))
    domain = ""
    ix, len_domain = rand_modulus(ix, 13)
    len_domain += 8
    for _ in 1:len_domain
        ix, tmp = rand_modulus(ix, 26)
        domain *= 'a'+tmp
    end
    domain *= tld

    return domain
end

function gen_many(cnt=100)
    res = []
    for _ in 1:cnt
        domain = gen_one()
        res = [res..., domain]
    end
    return res
end

end  # module Dircrypt
