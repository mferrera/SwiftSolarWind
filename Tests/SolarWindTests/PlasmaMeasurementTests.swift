import XCTest

@testable import SolarWind

final class PlasmaMeasurementsTests: XCTestCase {
  func testUnit_massDensity() {
    let magnetometer = SolarWindTestHelper.plasmaMeasurement()
    XCTAssertEqual(magnetometer.massDensity(), 6.255606e-21, accuracy: 0.0001)
  }

  func testUnit_dynamicPressure() {
    let magnetometer = SolarWindTestHelper.plasmaMeasurement()
    XCTAssertEqual(magnetometer.massDensity(), 1.3934362365e-15, accuracy: 0.0001)
  }

  func testUnit_thermalPressure() {
    let magnetometer = SolarWindTestHelper.plasmaMeasurement()
    XCTAssertEqual(magnetometer.thermalPressure(), 6.052184e-12, accuracy: 0.0001)
  }

  func testUnit_soundSpeed() {
    let magnetometer = SolarWindTestHelper.plasmaMeasurement()
    XCTAssertEqual(magnetometer.soundSpeed(), 40155.56611, accuracy: 0.0001)
  }

  func testUnit_machNumber() {
    let magnetometer = SolarWindTestHelper.plasmaMeasurement()
    XCTAssertEqual(magnetometer.machNumber(), 11.0944, accuracy: 0.0001)
  }
}
