const k_boltzman = 1.3806488e23*Joule/Kelvin
const n_avagadro = 6.02214129e23*Entity/Mole
const h_plank = 6.62606957e-34*Joule*Second
const hbar_plank = 2*pi*h_plank
const g_gravitation = 6.67384e-11*Meter^3*KiloGram^-1*Second^-2
const g__earth_gravity = 9.80665*Meter/Second^2
const c_light = 299792458*Meter/Second
const e_electron = 1.60817657e-19*Coulomb
const m_electron = 9.10938291*KiloGram
const m_proton = 1.672621777*Kilogram
const a_bohr = 5.2917721092e-11*Meter
const u0_magnetic = 4e-7*pi*Newton*Ampere^-2
const e0_electric = 1/(u0_magnetic*c_light^2)
const z0_freespace = u0_magnetic*e0_electric
const k_coulomb = 1/(4*pi*e0_electric)
const u_bohr = e_electron*hbar_plank/(2*m_electron)
const conductance_quantum = 2*e_electron/h_plank
const k_josephson = 2*e_electron/h_plank
const phi0_flux = h_plank/(2*e_electron)
const u_nuclear = e*hbar_plank/(2*m_proton)
const alpha_fine_structure = 7.2973525698e-3
const rydberg_const = alpha_fine_structure^2*m_electron*c_light/(2*h_plank)


const ElectronVolt = QUnit("eV", e_electron*Volt)
const Angstrom = QUnit("Å", 1e-10*Meter)
const Fermi = QUnit("F", Femto*Meter)
const Phi0_flux = QUnit("ϕ₀", phi0_flux)
const H_plank = QUnit("h", h_plank)
const Hbar_plank = QUnit("ħ", hbar_plank)
const K_boltzman = QUnit("kᵇ", k_boltzman) # I can't find a unicode subscript b
const U0_magnetic = QUnit("μ₀", u0_magnetic)
const E0_electric = QUnit("ε₀", e0_electric)
const Z0_freespace = QUnit("Z₀", z0_freespace)
const A_bohr = QUnit("a₀", a_bohr)
const N_avagadro = QUnit("Nₐ", n_avagadro)


export k_boltzman, n_avagadro, h_plank, hbar_plank, g_gravitation, g_earth_gravity, c_light
export e_electron, m_electron, m_proton, a_bohr, u0_magnetic, e0_electric, z0_freespace
export k_coulomb, u_bohr, conductance_quantum, k_josephson, phi0_flux, u_nuclear, alpha_fine_structure
export rydberg_const

export ElectronVolt, Phi0_flux, Angstrom, Fermi, Phi0_flux, H_plank, Hbar_plank, K_boltzman
export U0_magnetic, E0_electric, Z0_freespace, A_bohr, N_avagadro
