module Simda

const consonants = "qwrtpsdfghjklzxcvbnmv"
const vowels = "eyuioa"
function gen_one(len=rand(8:32),key="1676d5775e05c50b46baa5579d4fc7", base=rand(2:2^32), tld="")
    domain = ""
    step = 0
    for m in key
        step += Int(m)
    end
    base += step
    for i in 1:len
        index = trunc(Int64, base/(3+2*i))
        if i%2 == 0
            char = consonants[index%20 + 1]
        else
            char = vowels[index%6 + 1]
        end
        domain *= char
    end
    domain *= tld
    
    return domain
end

function gen_many(cnt=100)
    res = []
    key="1676d5775e05c50b46baa5579d4fc7"
    base=rand(2:2^32)
    step = 0
    for m in key
        step += Int(m)
    end
    for _ in 1:cnt
        domain = ""
        len=rand(8:32)
        base += step
        for i in 1:len
            index = trunc(Int64, base/(3+2*i))
            if i%2 == 0
                char = consonants[index%20 + 1]
            else
                char = vowels[index%6 + 1]
            end
            domain *= char
        end
        res = [res..., domain]
    end
    return res
end

end  # module Simda
