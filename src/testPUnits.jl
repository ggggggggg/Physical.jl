using PUnits, Base.Test

Milli = Prefix("m",-3)
PreZero = Prefix("",0)
a=PUnits.UnitSymbol(convert(UTF8String, "m"), int16(-3))

b = Unit("m")
c = Unit("c")

println(b*c)
println(c^-2)
println(-b)
println(c/b)
@test b==b
@test c*b == b*c

println(Milli*b)
println(remove_prefix(b*c))
println(remove_prefix(Milli*b))
