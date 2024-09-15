import Foundation
import SolarWind

@main
struct SolarWindCLI {
  static func main() async {
    do {
      // Get the past 5 minutes of NOAA magnetometer measurements
      // let magnetometerMeasurements = try await SolarWind.magnetometer(
      //   forInterval: SolarWind.Interval.fiveMinute)

      // print("Latest magnetometer measurements:")
      // for measurement in magnetometerMeasurements {
      //   print(measurement)
      // }

      // Get the past 7 days of NOAA plasma measurements
      let plasmaMeasurements = try await SolarWind.plasma(forInterval: SolarWind.Interval.threeDay)

      print("Last week of plasma temperature measurements:")
      for measurement in plasmaMeasurements {
        print(measurement.temperature)
      }
    } catch {
      print("Failed to fetch solar wind data: \(error)")
    }
  }
}
