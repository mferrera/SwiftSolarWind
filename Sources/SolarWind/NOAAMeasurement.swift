import Foundation

protocol NOAAMeasurement {
  /// The timestamp associated with this measurement.
  var timeTag: Date { get }
}
