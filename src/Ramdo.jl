module Ramdo
function gen_one(iter=rand(Int16), seed_num=5, len=rand(8:0x10), tld=false)
    domain = ""
    sh1 = seed_num << 1
    step1 = (iter+1) * sh1
    iter_seed = iter * seed_num
    imul_edx = iter_seed * 0x1a
    xor1 = step1 ⊻ imul_edx
    domain_length = 0

    while domain_length < len
        xor1_remainder = xor1 % 0x1a
        xo1_rem_20 = xor1_remainder + 0x20
        xo1_step2 = xo1_rem_20 ⊻ 0xa1
        dom_byte = 0x41 + (0xa1 ⊻ xo1_step2)
        domain *= Char(dom_byte)
        imul_iter = domain_length * step1
        imul_result = domain_length * imul_iter
        imul_1a = 0x1a * imul_result
        xor2 = xor1 ⊻ imul_1a
        xor1 = xor1 + xor2
        domain_length += 1
    end

    return domain
end

function gen_many(cnt=100)
    res = []
    for i in 1:cnt
        res = [res..., gen_one(i)]
    end
    return res
end

end  # module Ramdo
