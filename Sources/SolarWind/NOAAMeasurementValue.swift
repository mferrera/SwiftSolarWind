import Foundation

enum NOAAMeasurementValue {
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

  func toDate() throws -> Date? {
    switch self {
    case .string(let stringValue):
      guard let timeTag = NOAAMeasurementValue.dateFormatter.date(from: stringValue) else {
        throw SolarWind.SolarWindError.invalidFormat(
          details: "Unable to parse date into expected format. Expected format "
            + "\(NOAAMeasurementValue.dateFormatter.dateFormat!), got \(stringValue)."
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

  static func fromJson(from rawMeasurements: [[Any]]) throws
    -> [[NOAAMeasurementValue]]
  {
    return try rawMeasurements.map { row in
      try row.map { element in
        if let stringValue = element as? String {
          return NOAAMeasurementValue.string(stringValue)
        } else if let intValue = element as? Int {
          return NOAAMeasurementValue.int(intValue)
        } else if element is NSNull {
          return NOAAMeasurementValue.null
        } else {
          throw SolarWind.SolarWindError.invalidFormat(
            details: "Unsupported value type in JSON: \(element)"
          )
        }
      }
    }
  }

}
