import Foundation

enum NOAAPlasmaTestHelper {

  static let header: [String] = [
    "time_tag",
    "density",
    "speed",
    "temperature",
  ]

  static func generateMeasurement() -> [String] {
    return [
      RandomGeneratorHelper.generateRandomNOAADateString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomIntString(),
    ]
  }

  static func generateMeasurements(num: Int) -> [[String]] {
    var measurements = [header]
    for _ in 1...num {
      measurements.append(NOAAPlasmaTestHelper.generateMeasurement())
    }
    return measurements
  }
}
