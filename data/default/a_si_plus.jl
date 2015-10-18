const Meter = BaseUnit("m")
const Second = BaseUnit("s")
const KiloGram = BaseUnit("g", prefix=3)
const Kilogram = KiloGram
const Kelvin = BaseUnit("K")
const Mole = BaseUnit("mol")
const Candela = BaseUnit("cd")
const Radian = BaseUnit("rad")
const Ampere = BaseUnit("A")
const Photon = BaseUnit("\u0194")
const Entity = BaseUnit("entity")

const Gram = Milli*KiloGram
const Newton = DerivedUnit("N",KiloGram*Meter/Second^2)
const Joule = DerivedUnit("J", Newton*Meter)
const Coulomb = DerivedUnit("C", Ampere*Second)
const Volt = DerivedUnit("V", Joule/Coulomb)
const Ohm = DerivedUnit("\u03a9", Volt/Ampere)
const Hertz = DerivedUnit("Hz", 1/Second)
const Steradian = DerivedUnit("sr", Radian^2)
const Pascal = DerivedUnit("Pa", Newton/Meter^2)
const Watt = DerivedUnit("W",Joule/Second)
const Farad = DerivedUnit("F",Coulomb/Volt)
const Siemens = DerivedUnit("S", Ohm^-1)
const Weber = DerivedUnit("Wb", Joule/Ampere)
const Tesla = DerivedUnit("T", Newton/(Ampere*Meter))
const Henry = DerivedUnit("H", Weber/Ampere)
const Lumen = DerivedUnit("lm", Candela/Steradian)
const Lux = DerivedUnit("lx", Lumen/Meter^2)
const Becquerel = DerivedUnit("Bq",Photon/Second)
const Katal = DerivedUnit("kat",Mole/Second)

export Meter, Second, KiloGram, Kilogram, Kelvin, Mole, Candela, Radian, Ampere, Photon, Gram
export Entity, Newton, Joule, Coulomb, Volt, Ohm, Hertz, Steradian, Pascal, Watt, Farad
export Siemens, Weber, Tesla, Henry, Lumen, Lux, Becquerel, Katal
