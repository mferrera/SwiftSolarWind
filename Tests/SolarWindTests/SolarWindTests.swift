import XCTest

@testable import SolarWind

final class SolarWindTests: XCTestCase {
  func testUnit_magneticReconnectionField() {
    let magRecField = SolarWind.magneticReconnectionField(
      plasma: SolarWindTestHelper.plasmaMeasurement(),
      magnetometer: SolarWindTestHelper.magnetometerMeasurement())
    XCTAssertEqual(magRecField, 2013.659999, accuracy: 0.0001)
  }

  func testUnit_plasmaBeta() {
    let plasmaBeta = SolarWind.plasmaBeta(
      plasma: SolarWindTestHelper.plasmaMeasurement(),
      magnetometer: SolarWindTestHelper.magnetometerMeasurement())
    XCTAssertEqual(plasmaBeta, 0.2388614, accuracy: 0.0001)
  }

  func testUnit_bohmDiffusion() {
    let bohmDiffusion = SolarWind.bohmDiffusion(
      plasma: SolarWindTestHelper.plasmaMeasurement(),
      magnetometer: SolarWindTestHelper.magnetometerMeasurement())
    XCTAssertEqual(bohmDiffusion, 79105607.53363971, accuracy: 0.0001)
  }

  func testUnit_alfvenSpeed() {
    let bohmDiffusion = SolarWind.alfvenSpeed(
      plasma: SolarWindTestHelper.plasmaMeasurement(),
      magnetometer: SolarWindTestHelper.magnetometerMeasurement())
    XCTAssertEqual(bohmDiffusion, 90004.3015, accuracy: 0.0005)
  }

  func testUnit_newellCoupling() {
    let newellCoupling = SolarWind.newellCoupling(
      plasma: SolarWindTestHelper.plasmaMeasurement(),
      magnetometer: SolarWindTestHelper.magnetometerMeasurement())
    XCTAssertEqual(newellCoupling, 546.1965113, accuracy: 0.0001)
  }
}
