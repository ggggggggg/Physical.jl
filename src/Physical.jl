include("Quantitys.jl")
include("Uncertainty.jl")
module Physical
using Quantitys, Uncertainty

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

const k_boltzman = 1.3806488e23*Joule/Kelvin
const N_avagadro = 6.02214129e23*Entity/Mole
const h_plank = 6.62606957e-34*Joule*Second
const hbar_plank = 2*pi*h_plank
const G_gravity = 6.67384e-11*Meter^3*KiloGram^-1*Second^-2
const g_gravity = 9.80665*Meter/Second^2
const c_light = 299792458*Meter/Second
const e_electron = 1.60817657e-19*Coulomb
const a_bohr = 5.2917721092e-11*Meter



export as, asbase, QUnit
export Meter, Second, KiloGram, Kilogram, Kelvin, Mole, Candela, Newton, Joule, Coulomb, Ohm, Radian, Volt, Ampere

end # end module
