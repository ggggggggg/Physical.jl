# following http://en.wikipedia.org/w/index.php?title=Centimetre%E2%80%93gram%E2%80%93second_system_of_units&oldid=569933131
const CentiMeter = QUnit("cm")
const Second = QUnit("s")
const Gram = QUnit("g")
const Kelvin = QUnit("K")

const Dyne = QUnit("dyn",Gram*CentiMeter*Second^-2)
const Erg = QUnit("erg", Gram*CentiMeter^2*Second^-2)
const Barye = QUnit("Ba", Gram/(CentiMeter*Second^2))
const Poise = QUnit("P", Gram/(CentiMeter*Second))
const Stokes = QUnit("St", CentiMeter^2/Second)
const StatCoulomb = QUnit("Fr", (Erg*CentiMeter)^(0.5))


const c_light = 29979245800*CentiMeter/Second
const C_light = QUnit("c",c_light)
const k_boltzman = 1.3806488e-16*Erg/Kelvin
const h_plank = 6.62606957e-37*Erg*Second
const hbar_plank = 2*pi*h_plank
const g_gravitation = 6.67428e-8*CentiMeter^3*Gram^-1*Second^-2
const e_electron = 4.80320427e-10*StatCoulomb
const m_electron = 9.10938215e-28*Gram
const a_bohr = 5.2917721092e-9*Centimetre
const k_coulomb = 1/(4*pi*e0_electric)
const u_bohr = e_electron*hbar_plank/(2*m_electron)
const alpha_fine_structure = 7.2973525698e-3

const Franklin = StatCoulomb

const Ohm = QUnit("\u03a9", Volt/Ampere)



export Meter, Second, KiloGram, Kilogram, Kelvin, Mole, Candela, Radian, Ampere, Photon
export Entity, Newton, Joule, Coulomb, Volt, Ohm, Hertz, Steradian, Pascal, Watt, Farad
export Siemen, Weber, Tesla, Henry, Lumen, Lux, Becquerel, Katal