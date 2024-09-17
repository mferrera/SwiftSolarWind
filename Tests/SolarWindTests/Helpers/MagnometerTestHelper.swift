import Foundation

enum MagnometerTestHelper {

  static let header: [String] = [
    "time_tag",
    "bx_gsm",
    "by_gsm",
    "bz_gsm",
    "lon_gsm",
    "lat_gsm",
    "bt",
  ]

  static func generateMeasurement() -> [String] {
    return [
      RandomGeneratorHelper.generateRandomNOAADateString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
      RandomGeneratorHelper.generateRandomFloatString(),
    ]
  }

  static func generateMeasurements(num: Int) -> [[String]] {
    var measurements = [header]
    for _ in 1...num {
      measurements.append(MagnometerTestHelper.generateMeasurement())
    }
    return measurements
  }
}
