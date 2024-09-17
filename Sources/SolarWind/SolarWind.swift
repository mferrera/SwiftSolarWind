import Foundation

public enum SolarWind {
  /// The intervals of measurement readings exposed by the NOAA solar winds data product. NOAA
  /// offers one reading per minute irregardless of the interval you choose, but does not
  /// attach the last two minutes of readings.
  public enum Interval { case fiveMinute, twoHour, sixHour, oneDay, threeDay, sevenDay }

  public enum SolarWindError: Error {
    /// Thrown when the retrieved data does not conform to what is expected.
    case invalidFormat(details: String)
  }

  /// Fetches the most recent magnetometer measurements for the provided `SolarWind.Interval`,
  /// minus the last two minutes of measurements. This is due to how the NOAA exposes these data
  /// products.
  ///
  /// These measurements are ordered in ascending order, giving the oldest measurement first (e.g.
  /// from 5 minutes ago) to the latest one (two minutes ago).
  ///
  /// - Parameters:
  ///   - forInterval: The `Interval` time interval to retrieve measurements for.
  ///
  /// - Returns: An array of `MagnetometerMeasurement` representing magnetometer measurements.
  ///
  /// - Throws: An error if the data could not be fetched or parsed.
  public static func magnetometer(forInterval interval: Interval) async throws
    -> [MagnetometerMeasurement]
  {
    return try await Magnetometer.measurements(interval: interval)
  }

  /// Fetches the most recent plasma measurements for the provided `SolarWind.Interval`, minus the
  /// last two minutes of measurements. This is due to how the NOAA exposes these data products.
  ///
  /// These measurements are ordered in ascending order, giving the oldest measurement first (e.g.
  /// from 5 minutes ago) to the latest one (two minutes ago).
  ///
  /// - Parameters:
  ///   - forInterval: The `Interval` time interval to retrieve measurements for.
  ///
  /// - Returns: An array of `PlasmaMeasurement` representing plasma measurements.
  ///
  /// - Throws: An error if the data could not be fetched or parsed.
  public static func plasma(forInterval interval: Interval) async throws -> [PlasmaMeasurement] {
    return try await Plasma.measurements(interval: interval)
  }

  /// The magnetic reconnection field is a measure of how much energy is being transferred into the
  /// Earth's magnetosphere due to the interaction between the solar wind and Earth's magnetic
  /// field.
  ///
  ///   E = V B_z
  ///
  /// Where
  ///   - E is the reconnection electric field in mV/m,
  ///   - V is the solar wind velocity in km/s,
  ///   - B_z is the north-south component of the Interplanetary Magnetic Field (IMF) in nanoteslas
  ///       (nT)
  ///
  /// - Parameters:
  ///   - plasma: An `PlasmaMeasurement` at a given timestamp.
  ///   - magnetometer: An `MagnetometerMeasurement` at the same timestamp (not enforced).
  ///
  /// - Returns: The reconnection electric field rate in unit mV/m.
  public static func magneticReconnectionField(
    plasma: PlasmaMeasurement, magnetometer: MagnetometerMeasurement
  ) -> Double {
    return plasma.speed * magnetometer.bzGSM
  }

  /// The ratio of plasma pressure to magnetic pressure, which gives insights into whether the
  /// solar wind is magnetically or pressure dominated.
  ///
  ///       2 μ_0 n k_B T
  ///   β = -------------
  ///            B^2
  ///
  /// Where
  ///   - β is the plasma beta with no unit,
  ///   - μ_0 is the vacuum permeability (free space permeability) in N/A^2,
  ///   - n is the number density of the plasma in particles per cubic meter (m^−3),
  ///   - k_B is the Boltzmann constant in J/K,
  ///   - T is the plasma temperature in Kelvin (K),
  ///   - B is the magnetic field strength in Teslas (T).
  ///
  /// An equivalent formulation of this is:
  ///
  ///       P_th
  ///   β = -----
  ///       P_mag
  ///
  /// Where
  ///   - β is the plasma beta with no unit,
  ///   - P_mag is the magnetic pressure
  ///   - P_th is the thermal pressure
  ///
  /// NOAA can given null data which is converted to 0. Hence one should ensure `magnetometer.bt`
  /// has not been nulled before calling else a division by zero error may occur.
  ///
  /// - Parameters:
  ///   - plasma: An `PlasmaMeasurement` at a given timestamp.
  ///   - magnetometer: An `MagnetometerMeasurement` at the same timestamp (not enforced).
  ///
  /// - Returns: The plasma beta, no unit.
  public static func plasmaBeta(plasma: PlasmaMeasurement, magnetometer: MagnetometerMeasurement)
    -> Double
  {
    return plasma.thermalPressure() / magnetometer.magneticPressure()
  }

  /// Return the Bohm diffusion coefficient.
  ///
  /// Bohm diffusion is a concept in plasma physics that describes the anomalous diffusion of
  /// charged particles (such as electrons and ions) across magnetic fields.
  ///
  ///         1    k_B T
  ///   D_b = -- * -----
  ///         16    e B
  ///
  /// Where
  ///   - D_b is the Bohm diffusion coefficient in m^2/s,
  ///   - k_b is the Boltzmann constants in J/K,
  ///   - T is the temperature of the plasma in Kelvin (K),
  ///   - e is the elementary charge in Coulombs (C),
  ///   - B is the magnetic field strength in Teslas (T),
  ///
  /// - Parameters:
  ///   - plasma: An `PlasmaMeasurement` at a given timestamp.
  ///   - magnetometer: An `MagnetometerMeasurement` at the same timestamp (not enforced).
  ///
  /// - Returns: The Bohm diffusion coefficient in m^2/s.
  public static func bohmDiffusion(plasma: PlasmaMeasurement, magnetometer: MagnetometerMeasurement)
    -> Double
  {
    return Constants.kB * plasma.temperature / (16.0 * Constants.e * (magnetometer.bt * 1e-9))
  }

  /// Return the Alfvén speed.
  ///
  /// The Alfvén speed is the speed at which magnetic waves travel in a plasma. It can be calculated
  /// using the magnetic field strength and the mass density of the solar wind.
  ///
  ///              B
  ///   V_A = -----------
  ///         sqrt(μ_0 ρ)
  ///
  /// Where
  ///   - V_A is the Alfvén speed in m/s,
  ///   - B is the magnetic field strength in Teslas (T),
  ///   - μ_0 is the magnetic permeability of free space in N/A^2
  ///   - ρ is the plasma mass density in kg/m^3
  ///
  /// - Parameters:
  ///   - plasma: An `PlasmaMeasurement` at a given timestamp.
  ///   - magnetometer: An `MagnetometerMeasurement` at the same timestamp (not enforced).
  ///
  /// - Returns: The Alfvén speed in m/s.
  public static func alfvenSpeed(plasma: PlasmaMeasurement, magnetometer: MagnetometerMeasurement)
    -> Double
  {
    return (magnetometer.bt * 1e-9) / (Constants.mu0 * plasma.massDensity()).squareRoot()
  }

  /// Return the result of the Newell coupling function.
  ///
  /// This coupling function provides a good approximation of geomagnetic activity.
  /// See Newell et al., 2007, "A nearly universal solar wind-magnetosphere coupling function
  /// inferred from 10 magnetospheric state variables"
  ///
  ///   dΦ/dt = V^4/3 B_T^2/3 sin^4(θ_c / 2)
  ///
  /// Where
  ///   - dΦ/dt represents the reconnection rate,
  ///   - V is the solar wind speed in km/s,
  ///   - B_T is the transverse magnetic field, calculated as B_T = sqrt(B_Y^2 + B_Z^2), in nT,
  ///   - θ_c is the clock angle in degrees.
  ///
  /// - Parameters:
  ///   - plasma: An `PlasmaMeasurement` at a given timestamp.
  ///   - magnetometer: An `MagnetometerMeasurement` at the same timestamp (not enforced).
  ///
  /// - Returns: The estimate rate of magnetic reconnection, or rate of magnetic flux transfer, in
  ///     nT km/s
  public static func newellCoupling(
    plasma: PlasmaMeasurement, magnetometer: MagnetometerMeasurement
  ) -> Double {
    let bt = (pow(magnetometer.byGSM, 2) + pow(magnetometer.bzGSM, 2)).squareRoot()
    return pow(plasma.speed, 4 / 3) * pow(bt, 2 / 3) * pow(sin(magnetometer.clockAngle() / 0.5), 4)
  }
}
