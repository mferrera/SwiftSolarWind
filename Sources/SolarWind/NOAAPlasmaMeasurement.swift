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
public struct NOAAPlasmaMeasurement: NOAAMeasurement {
  /// The timestamp associated with this measurement.
  public let timeTag: Date

  /// The number of particles (mainly protons) per unit volume in the solar wind. It is typically
  /// measured in protons per cubic centimeter (protons/cm^3).
  public let density: Float

  /// The speed of the solar wind is how fast the solar wind particles are traveling through space,
  /// measured in kilometers per second (km/s).
  public let speed: Float

  /// The temperature of the solar wind is a measure of the kinetic energy of the particles in
  /// Kelvin (K).
  public let temperature: Int
}
