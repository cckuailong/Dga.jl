mutable struct test
    val
end
function a!(zz)
    zz.val = 2
end

function b!()
    zz = test(1)
    a!(zz)
    print(zz.val)
end
b!()
