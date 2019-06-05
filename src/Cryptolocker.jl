module Cryptolocker
using Dates

function gen_domain(date::Dates.Date, tld="", num=8)
    domain = ""
    year, month, day = Dates.year(date), Dates.month(date), Dates.day(date)
    for _ in 1:num
        year = ((year ⊻ 8 * year) >> 11) ⊻ ((year & 0xFFFFFFF0) << 17)
        month = ((month ⊻ 4 * month) >> 25) ⊻ 16 * (month & 0xFFFFFFF8)
        day = ((day ⊻ (day << 13)) >> 19) ⊻ ((day & 0xFFFFFFFE) << 12)
        domain *= ((year ⊻ month ⊻ day) % 25) + 'a'
    end
    domain *= tld
    return domain
end

function gen_one(date=missing, tld="", num=8)
    if date === missing
        date = Dates.Date(Dates.now())
    end
    domain = gen_domain(date, tld, num)
    return domain
end

function gen_many(cnt=100)
    res = []
    iter_num = trunc(Int,cnt/24)
    remain_num = cnt%24
    date = Dates.Date(Dates.now())
    for num in 8:31
        start_date = date + Dates.Day(trunc(Int64, rand()*1000000))
        for i in 1:iter_num
            new_date = start_date + Dates.Day(i*2+1)
            res = [res..., gen_domain(new_date, "", num)]
        end
    end
    for i in 1:remain_num
        res = [res..., gen_one(date, "", i+7)]
    end
    return res
end

end  # module Cryptolocker
