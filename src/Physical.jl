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

const Newton = KiloGram*Meter/Second^2
const Joule = Newton*Meter
const Coulomb = Ampere*Second
const Volt = Joule/Coulomb
const Ohm = Volt/Ampere
const Hertz = 1/Second
const Steradian = Radian^2
const Pascal = Newton/Meter^2
const Watt = Joule/Second
const Farad = Coulomb/Volt
const Siemen = Ohm^-1
const Weber = Joule/Ampere
const Tesla = Newton/(Ampere*Meter)
const Henry = Weber/Ampere
const Lumen = Candela/Steradian
const Lux = Lumen/Meter^2
const Becquerel = Photon/Second
const Katal = Mole/Second

const k_boltzman = 1.3806488e23*Joule/Kelvin
const N_avagadro = 6.02214129e23*Entity/Mole
const h_plank = 6.62606957e-34*Joule*Second
const hbar_plank = 2*pi*h_plank
const G_gravity = 6.67384e-11*Meter^3*KiloGram^-1*Second^-2
const g_gravity = 9.80665*Meter/Second^2
const c_light = 299792458*Meter/Second
const e_electron = 1.60817657e-19*Coulomb
const a_bohr = 5.2917721092e-11*Meter

export Meter, Second, KiloGram, Kilogram, Kelvin, Mole, Candela, Newton, Uncertain

end # end module
