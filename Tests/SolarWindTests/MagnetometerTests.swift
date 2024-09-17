import XCTest

@testable import SolarWind

final class MagnetometerTests: XCTestCase {
  func testUnit_parseMeasurements() throws {
    let measurements = try MeasurementValue.fromJson(from: [
      ["dummy header"],
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64", "9.83", "7.78"],
      ["2024-09-15 16:15:00.000", "-5.10", "6.00", "0.63", "130.34", "4.60", "7.90"],
    ])
    let rawMeasurements = measurements.dropFirst()
    let parsedMeasurements = try Magnetometer.parseMeasurements(rawMeasurements)

    for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
      let measurement = rawMeasurements[idx + 1]
      XCTAssertEqual(try measurement[0].toDate(), parsedMeasurement.timeTag)
      XCTAssertEqual(measurement[1].toDouble(), parsedMeasurement.bxGSM)
      XCTAssertEqual(measurement[2].toDouble(), parsedMeasurement.byGSM)
      XCTAssertEqual(measurement[3].toDouble(), parsedMeasurement.bzGSM)
      XCTAssertEqual(measurement[4].toDouble(), parsedMeasurement.lonGSM)
      XCTAssertEqual(measurement[5].toDouble(), parsedMeasurement.latGSM)
      XCTAssertEqual(measurement[6].toDouble(), parsedMeasurement.bt)
    }
  }

  func testUnit_parseNoMeasurements() throws {
    let measurements = try MeasurementValue.fromJson(from: [["dummy header"]])
    let rawMeasurements = measurements.dropFirst()
    let parsedMeasurements = try Magnetometer.parseMeasurements(rawMeasurements)
    XCTAssertEqual(0, parsedMeasurements.count)
  }

  func testUnit_parsingBadNumberOfFieldsThrows() throws {
    let measurements = try MeasurementValue.fromJson(from: [
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64"]
    ])

    XCTAssertThrowsError(try Magnetometer.parseMeasurements(measurements)) { error in
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
    let measurements = try MeasurementValue.fromJson(from: [
      ["09-15 16:14:00.000", "-4.47", "6.23", "1.33", "125.64", "9.83", "7.78"]
    ])

    XCTAssertThrowsError(try Magnetometer.parseMeasurements(measurements)) { error in
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

  func testUnit_parsingInvalidDoubleFieldThrows() throws {
    let measurements = try MeasurementValue.fromJson(from: [
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", "????", "125.64", "9.83", "7.78"]
    ])

    XCTAssertThrowsError(try Magnetometer.parseMeasurements(measurements)) { error in
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

  func testUnit_parsingNullFieldCastsToZero() throws {
    let measurements = try MeasurementValue.fromJson(from: [
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", NSNull(), "125.64", "9.83", "7.78"]
    ])

    let parsedMeasurements = try Magnetometer.parseMeasurements(measurements)
    XCTAssertEqual(parsedMeasurements[0].bzGSM, 0.0)
  }

  func testRandom_parseMeasurements() throws {
    for _ in 1...RandomGeneratorHelper.numRandomTests {
      let numMeasurements = Int.random(in: 1...100)
      let measurements = MagnometerTestHelper.generateMeasurements(num: numMeasurements)
      XCTAssertEqual(measurements[0], Magnetometer.header)

      let convertedMeasurements = try MeasurementValue.fromJson(from: measurements)
      let parsedMeasurements = try Magnetometer.parseMeasurements(
        convertedMeasurements.dropFirst())
      XCTAssertEqual(convertedMeasurements.count - 1, parsedMeasurements.count)

      for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
        let measurement = convertedMeasurements[idx + 1]
        XCTAssertEqual(
          measurement[0].toString(),
          MeasurementValue.dateFormatter.string(from: parsedMeasurement.timeTag))
        XCTAssertEqual(measurement[1].toDouble(), parsedMeasurement.bxGSM)
        XCTAssertEqual(measurement[2].toDouble(), parsedMeasurement.byGSM)
        XCTAssertEqual(measurement[3].toDouble(), parsedMeasurement.bzGSM)
        XCTAssertEqual(measurement[4].toDouble(), parsedMeasurement.lonGSM)
        XCTAssertEqual(measurement[5].toDouble(), parsedMeasurement.latGSM)
        XCTAssertEqual(measurement[6].toDouble(), parsedMeasurement.bt)
      }
    }
  }
}
