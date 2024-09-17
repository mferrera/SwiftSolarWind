import Foundation
import SolarWind

@main
struct Entrypoint {
  static func main() async {
    do {
      // Get the past 5 minutes of NOAA magnetometer measurements
      let magnetometerMeasurements = try await SolarWind.magnetometer(
        forInterval: SolarWind.Interval.fiveMinute)

      print("Latest magnetometer measurements:")
      for magnetometer in magnetometerMeasurements {
        print(magnetometer)
      }

      // Get the past 7 days of NOAA plasma measurements
      let plasmaMeasurements = try await SolarWind.plasma(forInterval: SolarWind.Interval.sevenDay)

      print("Last week of plasma temperature measurements:")
      for plasma in plasmaMeasurements {
        print("\(plasma.timeTag): \(plasma.temperature) Kelvin")
      }
    } catch {
      print("Failed to fetch solar wind data: \(error)")
    }
  }
}
