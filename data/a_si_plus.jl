const Meter = QUnit("m")
const Second = QUnit("s")
const KiloGram = QUnit("kg")
const Kilogram = KiloGram
const Kelvin = QUnit("K")
const Mole = QUnit("mol")
const Candela = QUnit("cd")
const Radian = QUnit("rad")
const Ampere = QUnit("A")
const Photon = QUnit("\u0194")
const Entity = QUnit("entity")

const Newton = QUnit("N",KiloGram*Meter/Second^2)
const Joule = QUnit("J", Newton*Meter)
const Coulomb = QUnit("C", Ampere*Second)
const Volt = QUnit("V", Joule/Coulomb)
const Ohm = QUnit("\u03a9", Volt/Ampere)
const Hertz = QUnit("Hz", 1/Second)
const Steradian = QUnit("sr", Radian^2)
const Pascal = QUnit("Pa", Newton/Meter^2)
const Watt = QUnit("W",Joule/Second)
const Farad = QUnit("F",Coulomb/Volt)
const Siemen = QUnit("S", Ohm^-1)
const Weber = QUnit("Wb", Joule/Ampere)
const Tesla = QUnit("T", Newton/(Ampere*Meter))
const Henry = QUnit("H", Weber/Ampere)
const Lumen = QUnit("lm", Candela/Steradian)
const Lux = QUnit("lx", Lumen/Meter^2)
const Becquerel = QUnit("Bq",Photon/Second)
const Katal = QUnit("kat",Mole/Second)

export Meter, Second, KiloGram, Kilogram, Kelvin, Mole, Candela, Radian, Ampere, Photon
export Entity, Newton, Joule, Coulomb, Volt, Ohm, Hertz, Steradian, Pascal, Watt, Farad
export Siemen, Weber, Tesla, Henry, Lumen, Lux, Becquerel, Katal