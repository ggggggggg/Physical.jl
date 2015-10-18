using Physical, Base.Test

a = 27
am = a*Meter
b = rand()
bu = b*Newton
c=BigFloat(2)*Meter
import Physical.Quantities.PUnits.UnitSymbol

@test isapprox((am^3.0*bu)/(Meter^3.0*Newton), a^3.0*b)
@test isapprox((am^3.0*bu), a^3.0*b*(Meter^3.0*Newton))
a = rand(5)*Newton
@test_throws ErrorException a[1] = 1
@test_throws ErrorException a[1] = 1*Meter
a[1] = 1*Newton
@test a[1] ==  1*Newton
@test a[1] == 1*Kilogram*Meter*Second^-2

R = 10*Ohm
@test R*Ampere/Volt == R/Ohm
@test Ohm == Volt/Ampere

@test Second*(1/Second) == 1
@test Meter*(1/Meter) == 1
@test Meter*([1,2,3]./Meter) == [1,2,3]
@test isapprox(ElectronVolt + Joule, Joule + ElectronVolt)
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
@test isapprox((Milli*Newton)/Newton, 1//1000)
@test isapprox((Milli*Newton)*(1/Newton), 1//1000)
@test sqrt(Meter^2) == Meter
@test_throws MethodError a = Milli*Milli*Meter
@test (Milli*Meter)*(Mega*Physical.ElectronVolt) == (Kilo*Meter)*Physical.ElectronVolt
@test_throws AssertionError 1*ElectronVolt>2*Meter
@test ElectronVolt<Joule

# and prefixes with a prefixed base unit
@test isapprox(Nano*KiloGram, 1e-9*KiloGram)
@test isapprox(Nano*Gram, 1e-12*KiloGram)
@test Gram*Gram==1e-6*KiloGram^2
@test isapprox(as(Joule*Joule/asbase(ElectronVolt), ElectronVolt)/ElectronVolt, (Joule/ElectronVolt)^2 )

# other functions
@test round(5.13891283*Meter,3)==5.139*Meter
