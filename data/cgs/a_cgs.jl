# following http://en.wikipedia.org/w/index.php?title=Centimetre%E2%80%93gram%E2%80%93second_system_of_units&oldid=569933131
const CentiMeter = BaseUnit("m", prefix=-2)
const Second = BaseUnit("s")
const Gram = BaseUnit("g")
const Kelvin = BaseUnit("K")

const Dyne = DerivedUnit("dyn",Gram*CentiMeter*Second^-2)
const Erg = DerivedUnit("erg", Gram*CentiMeter^2*Second^-2)
const Barye = DerivedUnit("Ba", Gram/(CentiMeter*Second^2))
const Poise = DerivedUnit("P", Gram/(CentiMeter*Second))
const Stokes = DerivedUnit("St", CentiMeter^2/Second)
const StatCoulomb = DerivedUnit("Fr", (Erg*CentiMeter)^(0.5))


const c_light = 29979245800*CentiMeter/Second
const C_light = DerivedUnit("c",c_light)
const k_boltzmann = 1.3806488e-16*Erg/Kelvin
const h_planck = 6.62606957e-37*Erg*Second
const hbar_planck = h_planck/2π
const g_gravitation = 6.67428e-8*CentiMeter^3*Gram^-1*Second^-2
const e_electron = 4.80320427e-10*StatCoulomb
const m_electron = 9.10938215e-28*Gram
const a_bohr = 5.2917721092e-9*CentiMeter
const u_bohr = e_electron*hbar_planck/(2*m_electron)
const alpha_fine_structure = 7.2973525698e-3

const Franklin = StatCoulomb

const Ohm = DerivedUnit("Ω", Volt/Ampere)



export CentiMeter, Second, Gram, Kelvin
export Dyne, Erg, Barye, Poise, Stokes, StatCoulomb
export c_light, C_light, k_boltzmann, h_planck, g_gravitation, e_electron
export m_electron, a_bohr, u_bohr, alpha_fine_structure
