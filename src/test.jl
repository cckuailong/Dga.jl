using JSON
set_nr = 2
seeds = JSON.parsefile(pwd()*@sprintf("/Dga.jl/data/set%d_seeds.json",set_nr))
if !("16113" in keys(seeds))
    print(111)
else
    print(222)
end
