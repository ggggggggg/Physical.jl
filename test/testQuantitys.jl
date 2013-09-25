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

R = 10*Ohm
@test R*Ampere/Volt == R/Ohm
@test Ohm == Volt/Ampere

# change base unit
const Slug = QUnit("slug")
QUnit("kg", 0.0685217659*Slug)
@test asbase(KiloGram) == 0.0685217659*Slug
@test as(KiloGram, Slug) == 0.0685217659*Slug
@test asbase(KiloGram).unit == Slug.unit
@test KiloGram.unit != Slug.unit
@test KiloGram.unit != asbase(Slug.unit)
@test Slug.unit == asbase(Slug.unit)
QUnit("kg")
QUnit("slug", 14.5939029*KiloGram)
@test asbase(KiloGram) != 0.0685217659*Slug
@test isapprox(as(KiloGram, Slug), 0.0685217659*Slug)
@test asbase(KiloGram).unit != Slug.unit
@test KiloGram.unit != Slug.unit
@test KiloGram.unit == asbase(Slug.unit)
@test Slug.unit != asbase(Slug.unit)

# long unit chain
A = QUnit("A")
B = QUnit("B", 2*A)
C = QUnit("C", 2*A*B)
D = QUnit("D", 2*A*B*C)
asbase(D)
as(A*B*C, D)