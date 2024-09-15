# SwiftSolarWind

A tiny library to retrieve NOAA space weather measurements.

## Quick start

```swift
import SolarWind

do {
  // Get the past 5 minutes of NOAA magnetometer measurements
  let magnetometerMeasurements = try await SolarWind.magnetometer(
    forInterval: SolarWind.Interval.fiveMinute)

  print("Latest magnetometer measurements:")
  for measurement in magnetometerMeasurements {
    print(measurement)
  }

  // Get the past 7 days of NOAA plasma measurements
  let plasmaMeasurements = try await SolarWind.plasma(forInterval: SolarWind.Interval.sevenDay)

  print("Last week of plasma temperature measurements:")
  for measurement in plasmaMeasurements {
    print(measurement.temperature)
  }
} catch {
  print("Failed to fetch solar wind data: \(error)")
}
```
