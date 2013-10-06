using Physical, Base.Test

a = 27
am = a*Meter
b = rand()
bu = b*Newton
c=BigFloat(2)*Meter
import Physical.Quantitys.PUnits.UnitSymbol

@test isapprox((am^3.0*bu)/(Meter^3.0*Newton), a^3.0*b)
@test isapprox((am^3.0*bu), a^3.0*b*(Meter^3.0*Newton))
@test UnitSymbol("m",0) == UnitSymbol("m",0)
a = rand(5)*Newton
@test_throws a[1] = 1
@test_throws a[1] = 1*Meter
a[1] = 1*Newton
@test a[1] ==  1*Newton
@test a[1] == 1*Kilogram*Meter*Second^-2

R = 10*Ohm
@test R*Ampere/Volt == R/Ohm
@test Ohm == Volt/Ampere

@test Second*(1/Second) == 1
@test Meter*(1/Meter) == 1
@test Meter*([1,2,3]./Meter) == [1,2,3]
@test ElectronVolt + Joule == Joule + ElectronVolt
@test (ElectronVolt+Joule).unit != (Joule+ElectronVolt).unit
@test Joule - Mega*ElectronVolt < Joule

# change base unit
const Slug = BaseUnit("slug")
DerivedUnit("g", 1e-3*0.0685217659*Slug)
@test asbase(KiloGram) == 0.0685217659*Slug
@test as(KiloGram, Slug) == 0.0685217659*Slug
@test asbase(KiloGram).unit == Slug.unit
@test KiloGram.unit != Slug.unit
@test KiloGram.unit != asbase(Slug.unit)
@test Slug.unit == asbase(Slug.unit)
BaseUnit("g", prefix=3)
DerivedUnit("slug", 14.5939029*KiloGram)
@test asbase(KiloGram) != 0.0685217659*Slug
@test isapprox(as(KiloGram, Slug), 0.0685217659*Slug)
@test asbase(KiloGram).unit != Slug.unit
@test KiloGram.unit != Slug.unit
@test KiloGram.unit == asbase(Slug).unit
@test Slug.unit != asbase(Slug).unit

# long unit chain
A = BaseUnit("A")
B = DerivedUnit("B", 2*A)
C = DerivedUnit("C", 2*A*B)
D = DerivedUnit("D", 2*A*B*C)
asbase(D)
as(A*B*C, D)

# now with prefixes

@test Milli*Meter == 1//1000*Meter
@test Milli*Newton == 1//1000*Newton
@test_throws a = Milli*Milli*Meter
@test (Milli*Meter)*(Mega*Physical.ElectronVolt) == (Kilo*Meter)*Physical.ElectronVolt
