import XCTest

@testable import SolarWind

final class PlasmaTests: XCTestCase {
  func testUnit_parseMeasurements() throws {
    let measurements = try MeasurementValue.fromJson(from: [
      ["dummy header"],
      ["2024-09-15 16:14:00.000", "-4.47", "6.23", 12345],
      ["2024-09-15 16:15:00.000", "-5.10", "6.00", 54321],
    ])
    let rawMeasurements = measurements.dropFirst()
    let parsedMeasurements = try Plasma.parseMeasurements(rawMeasurements)

    for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
      let measurement = rawMeasurements[idx + 1]
      XCTAssertEqual(try measurement[0].toDate(), parsedMeasurement.timeTag)
      XCTAssertEqual(measurement[1].toDouble(), parsedMeasurement.density)
      XCTAssertEqual(measurement[2].toDouble(), parsedMeasurement.speed)
      XCTAssertEqual(measurement[3].toDouble(), parsedMeasurement.temperature)
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
      ["2024-09-15 16:14:00.000", "-4.47", "6.23"]
    ])

    XCTAssertThrowsError(try Plasma.parseMeasurements(measurements)) { error in
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
      ["09-15 16:14:00.000", "-4.47", "6.23", 12345]
    ])

    XCTAssertThrowsError(try Plasma.parseMeasurements(measurements)) { error in
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
      ["2024-09-15 16:14:00.000", "-4.47", "????", "12345"]
    ])

    XCTAssertThrowsError(try Plasma.parseMeasurements(measurements)) { error in
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

  func testUnit_parsingInvalidIntFieldThrows() throws {
    let measurements = try MeasurementValue.fromJson(
      from: [
        ["2024-09-15 16:14:00.000", "-4.47", "6.23", "????"]
      ])

    XCTAssertThrowsError(try Plasma.parseMeasurements(measurements)) { error in
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
      ["2024-09-15 16:14:00.000", "-4.47", NSNull(), "12345"]
    ])

    let parsedMeasurements = try Plasma.parseMeasurements(measurements)
    XCTAssertEqual(parsedMeasurements[0].speed, 0.0)
  }

  func testRandom_parseMeasurements() throws {
    for _ in 1...RandomGeneratorHelper.numRandomTests {
      let numMeasurements = Int.random(in: 1...100)
      let measurements = PlasmaTestHelper.generateMeasurements(num: numMeasurements)
      XCTAssertEqual(measurements[0], Plasma.header)

      let convertedMeasurements = try MeasurementValue.fromJson(from: measurements)
      let parsedMeasurements = try Plasma.parseMeasurements(convertedMeasurements.dropFirst())
      XCTAssertEqual(convertedMeasurements.count - 1, parsedMeasurements.count)

      for (idx, parsedMeasurement) in parsedMeasurements.enumerated() {
        let measurement = convertedMeasurements[idx + 1]
        XCTAssertEqual(
          measurement[0].toString(),
          MeasurementValue.dateFormatter.string(from: parsedMeasurement.timeTag))
        XCTAssertEqual(measurement[1].toDouble(), parsedMeasurement.density)
        XCTAssertEqual(measurement[2].toDouble(), parsedMeasurement.speed)
        XCTAssertEqual(measurement[3].toDouble(), parsedMeasurement.temperature)
      }
    }
  }
}
