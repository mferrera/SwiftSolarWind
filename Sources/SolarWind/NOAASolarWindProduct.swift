import Foundation

protocol NOAASolarWindProduct {
  /// The URL to NOAA JSON containing the last 5 minutes of measurements.
  static var fiveMinute: URL { get }

  /// The URL to NOAA JSON containing the last two hours of measurements.
  static var twoHour: URL { get }

  /// The URL to NOAA JSON containing the last six hours of measurements.
  static var sixHour: URL { get }

  /// The URL to NOAA JSON containing the last 24 hours of measurements.
  static var oneDay: URL { get }

  /// The URL to NOAA JSON containing the last three days of measurements.
  static var threeDay: URL { get }

  /// The URL to NOAA JSON containing the last seven days of measurements.
  static var sevenDay: URL { get }

  /// The ordered headers or NOAA solar wind data.
  static var header: [String] { get }

  associatedtype NOAAMeasurementType: NOAAMeasurement

  /// Parse the raw measurements retrieved from NOAA into a list of a measurement type.
  static func parseMeasurements<T: Collection>(_ dataRows: T) async throws
    -> [NOAAMeasurementType] where T.Element == [NOAAMeasurementValue]

  /// Download the raw JSON data from NOAA.
  static func downloadJSON(from: URL) async throws -> [NOAAMeasurementType]

  /// Collect and return measurements over a given internal.
  static func measurements(interval: SolarWind.Interval) async throws -> [NOAAMeasurementType]
}
