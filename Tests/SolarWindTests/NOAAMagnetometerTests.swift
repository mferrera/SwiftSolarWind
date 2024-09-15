import XCTest

@testable import SolarWind

final class NOAAMagnetometerTests: XCTestCase {
  func testUnit_parseMeasurements() throws {
    let measurements = try NOAAMeasurementValue.fromJson(from: [
      ["dummy header"],
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64", "9.83", "7.78"],
      ["2024-09-15 16:15:00.000", "-5.10", "6.00", "0.63", "130.34", "4.60", "7.90"],
    ])
    let rawMeasurements = measurements.dropFirst()
    let parsedMeasurements = try NOAAMagnetometer.parseMeasurements(rawMeasurements)

    for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
      let measurement = rawMeasurements[idx + 1]
      XCTAssertEqual(try measurement[0].toDate(), parsedMeasurement.timeTag)
      XCTAssertEqual(measurement[1].toFloat(), parsedMeasurement.bxGSM)
      XCTAssertEqual(measurement[2].toFloat(), parsedMeasurement.byGSM)
      XCTAssertEqual(measurement[3].toFloat(), parsedMeasurement.bzGSM)
      XCTAssertEqual(measurement[4].toFloat(), parsedMeasurement.lonGSM)
      XCTAssertEqual(measurement[5].toFloat(), parsedMeasurement.latGSM)
      XCTAssertEqual(measurement[6].toFloat(), parsedMeasurement.bt)
    }
  }

  func testUnit_parsingBadNumberOfFieldsThrows() throws {
    let measurements = try NOAAMeasurementValue.fromJson(from: [
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64"]
    ])

    XCTAssertThrowsError(try NOAAMagnetometer.parseMeasurements(measurements)) { error in
      if let error = error as? SolarWind.SolarWindError {
        switch error {
        case .invalidFormat(let details):
          XCTAssertTrue(
            details.contains("Data row length not as expected."),
            "Error details not of expected type. Error: \(error)")
        }
      } else {
        XCTFail("Unexpected error type: \(error)")
      }
    }
  }

  func testUnit_parsingBadDateThrows() throws {
    let measurements = try NOAAMeasurementValue.fromJson(from: [
      ["09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64", "9.83", "7.78"]
    ])

    XCTAssertThrowsError(try NOAAMagnetometer.parseMeasurements(measurements)) { error in
      if let error = error as? SolarWind.SolarWindError {
        switch error {
        case .invalidFormat(let details):
          XCTAssertTrue(
            details.contains("Unable to parse date into expected format."),
            "Error details not of expected type. Error: \(error)")
        }
      } else {
        XCTFail("Unexpected error type: \(error)")
      }
    }
  }

  func testUnit_parsingInvalidFloatFieldThrows() throws {
    let measurements = try NOAAMeasurementValue.fromJson(from: [
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "????", "125.64", "9.83", "7.78"]
    ])

    XCTAssertThrowsError(try NOAAMagnetometer.parseMeasurements(measurements)) { error in
      if let error = error as? SolarWind.SolarWindError {
        switch error {
        case .invalidFormat(let details):
          XCTAssertTrue(
            details.contains("Invalid data found in measurement."),
            "Error details not of expected type. Error: \(error)")
        }
      } else {
        XCTFail("Unexpected error type: \(error)")
      }
    }
  }

  func testRandom_parseMeasurements() throws {
    for _ in 1...RandomGeneratorHelper.numRandomTests {
      let numMeasurements = Int.random(in: 1...100)
      let measurements = NOAAMagnometerTestHelper.generateMeasurements(num: numMeasurements)
      XCTAssertEqual(measurements[0], NOAAMagnetometer.header)

      let convertedMeasurements = try NOAAMeasurementValue.fromJson(from: measurements)
      let parsedMeasurements = try NOAAMagnetometer.parseMeasurements(
        convertedMeasurements.dropFirst())
      XCTAssertEqual(convertedMeasurements.count - 1, parsedMeasurements.count)

      for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
        let measurement = convertedMeasurements[idx + 1]
        XCTAssertEqual(
          try measurement[0].toString(),
          NOAAMeasurementValue.dateFormatter.string(from: parsedMeasurement.timeTag))
        XCTAssertEqual(measurement[1].toFloat(), parsedMeasurement.bxGSM)
        XCTAssertEqual(measurement[2].toFloat(), parsedMeasurement.byGSM)
        XCTAssertEqual(measurement[3].toFloat(), parsedMeasurement.bzGSM)
        XCTAssertEqual(measurement[4].toFloat(), parsedMeasurement.lonGSM)
        XCTAssertEqual(measurement[5].toFloat(), parsedMeasurement.latGSM)
        XCTAssertEqual(measurement[6].toFloat(), parsedMeasurement.bt)
      }
    }
  }
}
