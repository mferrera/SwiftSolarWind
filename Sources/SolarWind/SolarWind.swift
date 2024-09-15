import Foundation

public enum SolarWind {

  /// The intervals of measurement readings exposed by the NOAA solar winds data product. NOAA
  /// offers one reading per minute irregardless of the interval you choose, but does not
  /// attach the last two minutes of readings.
  public enum Interval {
    case fiveMinute, twoHour, sixHour, oneDay, threeDay, sevenDay
  }

  enum SolarWindError: Error {
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
  ///  - Parameters:
  ///    - forInterval: The `Interval` time interval to retrieve measurements for.
  ///
  /// - Returns: An array of `NOAAMagnetometerMeasurement` representing magnetometer measurements.
  ///
  /// - Throws: An error if the data could not be fetched or parsed.
  public static func magnetometer(forInterval interval: Interval) async throws
    -> [NOAAMagnetometerMeasurement]
  {
    return try await NOAAMagnetometer.measurements(interval: interval)
  }

  /// Fetches the most recent plasma measurements for the provided `SolarWind.Interval`, minus the
  /// last two minutes of measurements. This is due to how the NOAA exposes these data products.
  ///
  /// These measurements are ordered in ascending order, giving the oldest measurement first (e.g.
  /// from 5 minutes ago) to the latest one (two minutes ago).
  ///
  ///  - Parameters:
  ///    - forInterval: The `Interval` time interval to retrieve measurements for.
  ///
  /// - Returns: An array of `NOAAPlasmaMeasurement` representing plasma measurements.
  ///
  /// - Throws: An error if the data could not be fetched or parsed.
  public static func plasma(forInterval interval: Interval) async throws -> [NOAAPlasmaMeasurement]
  {
    return try await NOAAPlasma.measurements(interval: interval)
  }
}
