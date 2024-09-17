import Foundation

/// This struct represents a single NOAA plasma measurement.
///
/// These data include parameters describing the physical characteristics of solar wind.
///
/// density: The number of particles (mainly protons) per unit volume in the solar wind. It is
///   typically measured in protons per cubic centimeter (protons/cm^3).
///   Solar wind density tells us how many solar particles are passing through a given area of
///   space.
///   The particles in the solar wind are primarily protons, with some electrons and helium nuclei.
///   Higher density solar wind can enhance the compression of Earth's magnetosphere, potentially
///   leading to geomagnetic storms. Increased density can also contribute to more intense auroras.
///
/// speed: The speed of the solar wind is how fast the solar wind particles are traveling through
///   space, measured in kilometers per second (km/s).
///   Solar wind speed refers to the velocity at which the charged particles from the Sun (plasma)
///   are moving. Solar wind speeds can vary significantly, from around 250 km/s in quiet conditions
///   to over 750 km/s during solar storms.
///   Higher-speed solar wind can more easily penetrate and interact with Earth's magnetosphere.
///   When high-speed solar wind arrives at Earth, it can creates disturbances in the magnetosphere,
///   leading to geomagnetic storms and enhanced auroras.
///
/// temperature: The temperature of the solar wind is a measure of the kinetic energy of the
///   particles in Kelvin (K).
///   In plasma physics, temperature is related to the average energy of the particles in the solar
///   wind. Higher temperatures correspond to faster-moving particles.
///   The temperature of the solar wind can indicate how energetic the particles are. While
///   temperature alone doesn't directly cause geomagnetic storms, it can be a contributing factor
///   in determining how the solar wind interacts with the Earth's magnetic field.
public struct PlasmaMeasurement: Measurement {
  /// The timestamp associated with this measurement.
  public let timeTag: Date

  /// The number of particles (mainly protons) per unit volume in the solar wind. It is typically
  /// measured in protons per cubic centimeter (protons/cm^-3).
  public let density: Double

  /// The speed of the solar wind is how fast the solar wind particles are traveling through space,
  /// measured in kilometers per second (km/s).
  public let speed: Double

  /// The temperature of the solar wind is a measure of the kinetic energy of the particles in
  /// Kelvin (K).
  public let temperature: Double

  /// The mass density of the plasma measurement. Since solar wind consists mainly of protons the
  /// mass of a proton is used.
  ///
  ///   ρ = n m_p
  ///
  /// Where
  ///   - ρ is the mass density in kg/m^3,
  ///   - n is the particle number density in m^-3,
  ///   - m_p is the proton mass.
  ///
  /// - Returns: A double representing mass density ρ in kg/m^3.
  public func massDensity() -> Double {
    return (density * 1e6) * Constants.mp
  }

  /// Solar wind dynamic pressure (P_dyn) is the pressure exerted by the flow of solar wind
  /// particles as they stream from the Sun towards the Earth. It represents the kinetic energy per
  /// unit volume of the solar wind plasma and is a key driver of the interaction between the solar
  /// wind and the Earth's magnetopshere.
  ///
  ///           p V^2
  ///   P_dyn = -----
  ///             2
  ///
  /// Where
  ///   - P_dyn is the dynamic pressure in pascals (Pa),
  ///   - p is the mass density in kg/m^3,
  ///   - V in the speed in m/s.
  ///
  /// - Returns: The dynamic pressure for this measurement in pascals (Pa).
  public func dynamicPressure() -> Double {
    let speedMs = speed * 1e3
    return 0.5 * massDensity() * speedMs * speedMs
  }

  /// The thermal pressure for a Maxwellian distribution.
  ///
  /// Thermal pressure is the pressure exerted by the random thermal motions of particles (e.g.,
  /// protons, electrons) in the plasma. Is is analogous to the pressure in a gas, where the
  /// particles' kinetic energy creates a force that pushes outward.
  ///
  ///   P_th = n k_B T
  ///
  /// Where
  ///   - P_th is the thermal pressure in pascals (Pa),
  ///   - n is the particle number density in m^-3,
  ///   - k_B is the Boltzmann constant in J/K,
  ///   - T is the temperature in Kelvin.
  ///
  /// - Returns: The thermal pressure in pascals (Pa).
  public func thermalPressure() -> Double {
    return (density * 1e6) * Constants.kB * temperature
  }

  /// The sound speed in the plasma.
  ///
  /// The sound speed C_s in a plasma is the speed at which pressure waves (sound waves) propagate
  /// through the plasma. It depends on the temperature of the plasma and the mass of the particles,
  /// which are typically dominated by protons.
  ///
  ///   C_s = sqrt( γ k_B T / m_p )
  ///
  /// Where
  ///   - C_s is the sound speed in m/s,
  ///   - γ is the adiabatic index (typically 5/3 for a monoatomic gas like plasma),
  ///   - k_B is the Boltzmann constant in J/K,
  ///   - T is the plasma temperature in Kelvin (K),
  ///   - m_p is the proton mass in kg.
  ///
  /// - Returns: The sound speed in m/s.
  public func soundSpeed() -> Double {
    return ((5 * Constants.kB * temperature) / (3 * Constants.mp)).squareRoot()
  }

  /// The Mach number for this measurement.
  ///
  /// The Mach number of solar wind is a measure of the speed of the solar wind relative to the
  /// sound speed in the plasma. It's important in describing shock waves in the solar wind, e.g.,
  /// bow shock in front of Earth's magnetosphere.
  ///
  ///        V
  ///   M = ---
  ///       C_s
  ///
  /// Where
  ///   - M is the Mach number,
  ///   - V is the speed in m/s,
  ///   - C_s is the sound speed in the plasma.
  ///
  /// - Returns: The Mach number for this measurement, no unit.
  public func machNumber() -> Double {
    return (speed * 1e3) / soundSpeed()
  }
}
