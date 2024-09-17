import Foundation

@testable import SolarWind

enum SolarWindTestHelper {
  static let testDate = "2024-09-15 16:14:00.000"
  static let timeTag = MeasurementValue.dateFormatter.date(from: SolarWindTestHelper.testDate)!

  /// Fixture to create a plasma measurement.
  static func plasmaMeasurement() -> PlasmaMeasurement {
    return PlasmaMeasurement(
      timeTag: timeTag,
      density: 3.74,
      speed: 445.5,
      temperature: 117208)

  }

  /// Fixture to create a magnetometer measurement.
  static func magnetometerMeasurement() -> MagnetometerMeasurement {
    return MagnetometerMeasurement(
      timeTag: timeTag,
      bxGSM: -2.38,
      byGSM: 6.14,
      bzGSM: 4.52,
      lonGSM: 111.18,
      latGSM: 34.50,
      bt: 7.98)
  }
}
