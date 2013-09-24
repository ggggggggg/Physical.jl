using Physical, Base.Test

a = 27
am = a*Meter
b = rand()
bu = b*Newton
c=BigFloat(2)*Meter

@test isapprox((am^3.0*bu)/(Meter^3.0*Newton), a^3.0*b)
@test isapprox((am^3.0*bu), a^3.0*b*(Meter^3.0*Newton))

a = rand(5)*Newton
@test_throws a[1] = 1
@test_throws a[1] = 1*Meter
a[1] = 1*Newton
@test a[1] ==  1*Newton
@test a[1] == 1*Kilogram*Meter*Second^-2
