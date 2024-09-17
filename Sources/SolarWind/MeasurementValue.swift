import Foundation

enum MeasurementValue {
  case string(String)
  case int(Int)
  case null  // NOAA sometimes has missing/incomplete readings. These are null in the JSON.

  /// Formats time stamps given in NOAA data.
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()

  /// Casts the value to an Int. Resolves to 0 if null.
  func toInt() -> Int? {
    switch self {
    case .string(let stringValue):
      return Int(stringValue)
    case .int(let intValue):
      return intValue
    case .null:
      return 0
    }
  }

  /// Casts the value to a Double. Resolves to 0.0 if null.
  func toDouble() -> Double? {
    switch self {
    case .string(let stringValue):
      return Double(stringValue)
    case .int(let intValue):
      return Double(intValue)
    case .null:
      return 0.0
    }
  }

  /// Casts the value to a Float. Resolves to 0.0 if null.
  func toFloat() -> Float? {
    switch self {
    case .string(let stringValue):
      return Float(stringValue)
    case .int(let intValue):
      return Float(intValue)
    case .null:
      return 0.0
    }
  }

  /// Casts the value to a String. Resolves to "" if null.
  func toString() -> String? {
    switch self {
    case .string(let stringValue):
      return stringValue
    case .int(let intValue):
      return String(intValue)
    case .null:
      return ""
    }
  }

  /// Casts a String to a formatted date. Throws a `SolarWindError.invalidFormat` if the value is
  /// not a string.
  func toDate() throws -> Date? {
    switch self {
    case .string(let stringValue):
      guard let timeTag = MeasurementValue.dateFormatter.date(from: stringValue) else {
        throw SolarWind.SolarWindError.invalidFormat(
          details: "Unable to parse date into expected format. Expected format "
            + "\(MeasurementValue.dateFormatter.dateFormat!), got \(stringValue)."
        )
      }
      return timeTag
    case .int(let intValue):
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Attempted to construct a date from an integer. Int value: \(intValue)"
      )
    case .null:
      throw SolarWind.SolarWindError.invalidFormat(
        details: "Attempted to construct a date from a JSON null."
      )
    }
  }

  /// Transforms an Any object created from JSON into a list of lists containing measurement values.
  static func fromJson(from rawMeasurements: [[Any]]) throws -> [[MeasurementValue]] {
    return try rawMeasurements.map { row in
      try row.map { element in
        if let stringValue = element as? String {
          return MeasurementValue.string(stringValue)
        } else if let intValue = element as? Int {
          return MeasurementValue.int(intValue)
        } else if element is NSNull {
          return MeasurementValue.null
        } else {
          throw SolarWind.SolarWindError.invalidFormat(
            details: "Unsupported value type in JSON: \(element)"
          )
        }
      }
    }
  }
}
