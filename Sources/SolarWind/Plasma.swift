import Foundation

struct Plasma: SolarWindProduct {
  /// The URL to NOAA JSON containing the last 5 minutes of measurements.
  static let fiveMinute: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-5-minute.json")!

  /// The URL to NOAA JSON containing the last two hours of measurements.
  static let twoHour: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-2-hour.json")!

  /// The URL to NOAA JSON containing the last six hours of measurements.
  static let sixHour: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-6-hour.json")!

  /// The URL to NOAA JSON containing the last 24 hours of measurements.
  static let oneDay: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json")!

  /// The URL to NOAA JSON containing the last three days of measurements.
  static let threeDay: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-3-day.json")!

  /// The URL to NOAA JSON containing the last seven days of measurements.
  static let sevenDay: URL = URL(
    string: "https://services.swpc.noaa.gov/products/solar-wind/plasma-7-day.json")!

  /// The ordered header of NOAA magnetometer data.
  static let header: [String] = [
    "time_tag",
    "density",
    "speed",
    "temperature",
  ]

  /// Parses raw measurement data into a measurement type.
  static func parseMeasurements<T: Collection>(_ dataRows: T) throws -> [PlasmaMeasurement]
  where T.Element == [MeasurementValue] {
    var measurements = [PlasmaMeasurement]()
    for row in dataRows {
      guard row.count == Plasma.header.count else {
        throw SolarWind.SolarWindError.invalidFormat(
          details: "Data row length not as expected. Expected row length of "
            + "\(Plasma.header.count), got \(row.count)."
        )
      }

      if let timeTag = try row[0].toDate(),
        let density = row[1].toDouble(),
        let speed = row[2].toDouble(),
        let temperature = row[3].toDouble()
      {
        let measurement = PlasmaMeasurement(
          timeTag: timeTag,
          density: density,
          speed: speed,
          temperature: temperature
        )
        measurements.append(measurement)
      } else {
        throw SolarWind.SolarWindError.invalidFormat(
          details: "Invalid data found in measurement. Failing raw data: \(row)."
        )
      }
    }
    return measurements
  }

  /// Retrieves and parses the JSON for the relevant measurement type and interval.
  static func downloadMeasurements(from: URL) async throws -> [PlasmaMeasurement] {
    let (data, _) = try await URLSession.shared.data(from: from)
    let rawMeasurements =
      try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]]

    guard let rawMeasurements = rawMeasurements, rawMeasurements.count > 1 else {
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Received data contains no measurements."
      )
    }

    guard let header = rawMeasurements[0] as? [String], header == Plasma.header else {
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Headers do not match. Expected \(Plasma.header), got \(header)."
      )
    }

    let convertedMeasurements = try MeasurementValue.fromJson(from: rawMeasurements)
    return try parseMeasurements(convertedMeasurements.dropFirst())
  }

  /// Returns a list of magnetometer measurements for a given interval.
  static func measurements(interval: SolarWind.Interval) async throws -> [PlasmaMeasurement] {
    switch interval {
    case SolarWind.Interval.fiveMinute:
      return try await downloadMeasurements(from: Plasma.fiveMinute)
    case SolarWind.Interval.twoHour:
      return try await downloadMeasurements(from: Plasma.twoHour)
    case SolarWind.Interval.sixHour:
      return try await downloadMeasurements(from: Plasma.sixHour)
    case SolarWind.Interval.oneDay:
      return try await downloadMeasurements(from: Plasma.oneDay)
    case SolarWind.Interval.threeDay:
      return try await downloadMeasurements(from: Plasma.threeDay)
    case SolarWind.Interval.sevenDay:
      return try await downloadMeasurements(from: Plasma.sevenDay)
    }
  }
}
