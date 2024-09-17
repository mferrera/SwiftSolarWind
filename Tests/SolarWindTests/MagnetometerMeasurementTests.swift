import XCTest

@testable import SolarWind

final class MagnetometerMeasurementsTests: XCTestCase {
  func testUnit_magneticPressure() {
    let magnetometer = SolarWindTestHelper.magnetometerMeasurement()
    XCTAssertEqual(magnetometer.magneticPressure(), 2.53376e-11, accuracy: 0.0001)
  }
}
