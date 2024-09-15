import Foundation

struct NOAAMagnetometer: NOAASolarWindProduct {

  /// The URL to NOAA JSON containing the last 5 minutes of measurements.
  internal static let fiveMinute: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-5-minute.json"
  )!

  /// The URL to NOAA JSON containing the last two hours of measurements.
  internal static let twoHour: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-2-hour.json"
  )!

  /// The URL to NOAA JSON containing the last six hours of measurements.
  internal static let sixHour: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-6-hour.json"
  )!

  /// The URL to NOAA JSON containing the last 24 hours of measurements.
  internal static let oneDay: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json"
  )!

  /// The URL to NOAA JSON containing the last three days of measurements.
  internal static let threeDay: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-3-day.json"
  )!

  /// The URL to NOAA JSON containing the last seven days of measurements.
  internal static let sevenDay: URL = URL(
    string:
      "https://services.swpc.noaa.gov/products/solar-wind/mag-7-day.json"
  )!

  /// The ordered header of NOAA magnetometer data.
  internal static let header: [String] = [
    "time_tag",
    "bx_gsm",
    "by_gsm",
    "bz_gsm",
    "lon_gsm",
    "lat_gsm",
    "bt",
  ]

  /// Parses raw measurement data into a measurement type.
  internal static func parseMeasurements<T: Collection>(_ dataRows: T) throws
    -> [NOAAMagnetometerMeasurement] where T.Element == [NOAAMeasurementValue]
  {
    var measurements = [NOAAMagnetometerMeasurement]()
    for row in dataRows {
      guard row.count == NOAAMagnetometer.header.count else {
        throw SolarWind.SolarWindError.invalidFormat(
          details: "Data row length not as expected. Expected row length of "
            + "\(NOAAMagnetometer.header.count), got \(row.count)."
        )
      }

      if let timeTag = try row[0].toDate(),
        let bxGSM = row[1].toFloat(),
        let byGSM = row[2].toFloat(),
        let bzGSM = row[3].toFloat(),
        let lonGSM = row[4].toFloat(),
        let latGSM = row[5].toFloat(),
        let bt = row[6].toFloat()
      {
        let measurement = NOAAMagnetometerMeasurement(
          timeTag: timeTag,
          bxGSM: bxGSM,
          byGSM: byGSM,
          bzGSM: bzGSM,
          lonGSM: lonGSM,
          latGSM: latGSM,
          bt: bt
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

  /// Retrieves the JSON for the relevant measurement type and interval.
  internal static func downloadJSON(from: URL) async throws -> [NOAAMagnetometerMeasurement] {
    let (data, _) = try await URLSession.shared.data(from: from)
    let rawMeasurements =
      try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]]

    guard let rawMeasurements = rawMeasurements, rawMeasurements.count > 1 else {
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Received data contains no measurements."
      )
    }

    guard let header = rawMeasurements[0] as? [String], header == NOAAMagnetometer.header else {
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Headers do not match. Expected \(NOAAMagnetometer.header), got \(header)."
      )
    }

    let convertedMeasurements = try NOAAMeasurementValue.fromJson(from: rawMeasurements)
    return try parseMeasurements(convertedMeasurements.dropFirst())
  }

  /// Returns a list of magnetometer measurements for a given interval.
  public static func measurements(interval: SolarWind.Interval) async throws
    -> [NOAAMagnetometerMeasurement]
  {
    switch interval {
    case SolarWind.Interval.fiveMinute:
      return try await downloadJSON(from: NOAAMagnetometer.fiveMinute)
    case SolarWind.Interval.twoHour:
      return try await downloadJSON(from: NOAAMagnetometer.twoHour)
    case SolarWind.Interval.sixHour:
      return try await downloadJSON(from: NOAAMagnetometer.sixHour)
    case SolarWind.Interval.oneDay:
      return try await downloadJSON(from: NOAAMagnetometer.oneDay)
    case SolarWind.Interval.threeDay:
      return try await downloadJSON(from: NOAAMagnetometer.threeDay)
    case SolarWind.Interval.sevenDay:
      return try await downloadJSON(from: NOAAMagnetometer.sevenDay)
    }
  }
}
