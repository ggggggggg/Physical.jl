const k_boltzman = 1.3806488e23*Joule/Kelvin
const n_avagadro = 6.02214129e23*Entity/Mole
const h_plank = 6.62606957e-34*Joule*Second
const hbar_plank = 2*pi*h_plank
const G_gravity = 6.67384e-11*Meter^3*KiloGram^-1*Second^-2
const g_gravity = 9.80665*Meter/Second^2
const c_light = 299792458*Meter/Second
const e_electron = 1.60817657e-19*Coulomb
const m_electron = 9.10938291*KiloGram
const m_proton = 1.672621777*Kilogram
const a_bohr = 5.2917721092e-11*Meter
const u_magnetic = 4e-7*pi*Newton*Ampere^-2
const e0_electric = 1/(u_magnetic*c_light^2)
const z0_freespace = u_magnetic*e0_electric
const k_coulomb = 1/(4*pi*e0_electric)
const u_bohr = e_electron*hbar_plank/(2*m_electron)
const conductance_quantum = 2*e_electron/h_plank
const k_josephson = 2*e_electron/h_plank
const phi0_flux = h_plank/(2*e_electron)
const u_nuclear = e*hbar_plank/(2*m_proton)
const alpha_fine_structure = 7.2973525698e-3
const rydberg_const = alpha_fine_structure^2*m_electron*c_light/(2*h_plank)


const ElectronVolt = QUnit("eV", e_electron*Volt)
const Phi0_flux = QUnit("\u03d5\u2080", phi0_flux)
