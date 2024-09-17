import Foundation

/// This struct represents a single NOAA magnetometer measurement.
///
/// These measurements come as vector components in the Geocentric Solar Magnetospheric (GSM)
/// coordinate system. This system is particularly useful for understanding how the solar wind
/// interacts with the Earth's magnetosphere.
///
/// Here is a rough diagram of this coordinate system.
///      ______
///     / Sun  \
///    |        |
///    |   /\   |
///     \____\_/
///    x-axis \
///            \      y-axis
///      _______\________\
///              \       /
///               \ /|\
///                \_|_ N
///                / | \  Earth
///                \_|_/
///                  | z-axis
///                  |
///
/// Bx is generally less significant for geomagnetic activity. It describes the part of the
/// Interplanetary Magnetic Field (IMF) that aligns with the Earth-Sun axis but does not typically
/// affect how the solar wind interacts with Earth's magnetic field. It is more of a reference
/// component.
///
/// By can contribute to the twisting and deformation of Earth's magnetic field. It represents the
/// east-west component of the IMF and can affect the dynamics of the magnetosphere, especially in
/// combination with Bz.
///
/// Bz is the most critical component for geomagnetic storms. When Bz is negative (southward), it
/// can couple with the Earth's magnetic field and lead to magnetic reconnection, causing
/// disturbances such as auroras and magnetic storms. A positive Bz (northward) generally leads to
/// less interaction and fewer geomagnetic disturbances.
///
/// Bx: tells you how strong the field is pointing toward or away from the sun.
///
/// By: tells you how strong the field is pointing east or west.
///
/// Bz: tells you how strong the field is pointing north or south.
///
/// Lat GSM is the The latitudinal angle of the magnetic field vector in the GSM Z direction
/// (north-south), relative to the equatorial plane (which is aligned with the GSM XY plane).
/// Measured in degrees, from -90° to 90°.
///
/// A positive latitude indicates that the magnetic field is pointing more toward the north
/// (positive Z direction, toward Earth's magnetic north). A negative latitude indicates the
/// magnetic field is pointing more toward the south (negative Z direction, toward Earth's magnetic
/// south).
///
/// Lat GSM is particularly important because it describes how much of the magnetic field is tilted
/// toward or away from the Earth's magnetic poles. This helps assess how well the IMF can interact
/// with Earth's magnetosphere, with larger deviations indicating stronger coupling (especially if
/// aligned with Earth's magnetic field).
///
/// The longitudinal angle of the magnetic field vector measured in the XY plane (the equatorial
/// plane), relative to the GSM X-axis (which points toward the Sun). Measured in degrees, from 0°
/// - 360°.
///
/// BT represents the total strength (magnitude) of the Interplanetary Magnetic Field (IMF),
/// calculated from the three components Bx, By, and Bz. Measured in nanoteslas (nT).
///
///     BT = sqrt(Bx^2 + By^2 + Bz^2)
///
/// BT is the total magnitude of the magnetic field vector, regardless of direction. It helps
/// describe the overall intensity of the IMF. Higher BT values indicate stronger solar wind
/// magnetic fields, which are often associated with more intense space weather conditions.
public struct MagnetometerMeasurement: Measurement {
  /// The timestamp associated with this measurement.
  public let timeTag: Date

  /// The x-axis component, which points from the Earth toward the sun. Unit: nanotesla (nT).
  public let bxGSM: Double

  /// The y-axis component, which points perpendicular to both the x-axis and the magnetic dipole
  /// axis of Earth, roughly in the direction of the ecliptic plane (the plane in which Earth
  /// orbits the sun). Unit: nanotesla (nT).
  public let byGSM: Double

  /// The z-axis component, which points toward Earth's north magnetic pole, perpendicular to the
  /// ecliptic plane. Unit: nanotesla (nT).
  public let bzGSM: Double

  /// The longitudinal angle of the magnetic field vector measured in the XY plane (the equatorial
  /// plane), relative to the GSM X-axis (which points toward the Sun). Unit: degrees, from 0° -
  /// 360°.
  public let lonGSM: Double

  /// The latitudinal angle of the magnetic of the magnetic field vector in the GSM Z direction
  /// (north-south), relative to the equatorial plane (which is aligned with the GSM XY plane).
  /// Unit: degrees, from -90° - 90°.
  public let latGSM: Double

  /// BT represents the total strength (magnitude) of the Interplanetary Magnetic Field (IMF),
  /// calculated from the three components Bx, By, and Bz. Unit: nanoteslas (nT).
  public let bt: Double

  /// Calculate the magnetic pressure from this measurement.
  ///
  /// Magnetic pressure is the pressure exerted by the magnetic field in the plasma. It is the force
  /// per unit area due to the magnetic field and represents the nergy density stored in the
  /// magnetic field. It affects how the plasma behaves and interacts with magnetic fields like the
  /// Earth's magnetosphere.
  ///
  /// The magnetic pressure is given by:
  ///
  ///            B^2
  ///   P_mag = -----
  ///           2 μ_0
  ///
  /// Where
  ///   - P_mag is the magnetic pressure in pascals (Pa),
  ///   - B is the magnetic field strength in Telsas (T),
  ///   - μ_0 is the vacuum permeability constant in N/A^2.
  ///
  /// - Returns: The magnetic pressure in pascals (Pa).
  public func magneticPressure() -> Double {
    let btInTesla = bt * 1e-9
    return (btInTesla * btInTesla) / (2.0 * Constants.mu0)
  }

  /// Calculate the clock angle of the IMF in the GSM coordinate system.
  ///
  /// The clock angle describes the orientation of the Interplanetary Magnetic Field (IMF) in the
  /// Geocentric Solar Magnetospheric (GSM) coordinate system. It is the angle that the magnetic
  /// field vector makes in the YZ plane of the GSM system, relative to the Z-axis which points
  /// toward Earth's magnetic north pole.
  ///
  ///   θ_c = tan^-1(By /Bz)
  ///
  /// - Returns: The clock angle in degrees, from 0° to 360°.
  public func clockAngle() -> Double {
    let angle = atan(byGSM / bzGSM) * (180.0 / Double.pi)
    if angle < 0.0 {
      return angle + 360.0
    }
    return angle
  }
}
