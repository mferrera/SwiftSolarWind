import Foundation

enum RandomGeneratorHelper {
  static let numRandomTests = 20

  static func generateRandomInt() -> Int {
    return Int.random(in: Int.min...Int.max)
  }

  static func generateRandomIntString() -> String {
    return String(RandomGeneratorHelper.generateRandomInt())
  }

  static func generateRandomFloat() -> Float {
    return Float.random(in: Float.leastNormalMagnitude...Float.greatestFiniteMagnitude)
  }

  static func generateRandomFloatString() -> String {
    return String(RandomGeneratorHelper.generateRandomFloat())
  }

  // Generates a random date string in the format "yyyy-MM-dd HH:mm:ss.SSS"
  static func generateRandomNOAADateString() -> String {
    // Create a date formatter with the desired format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // UTC timezone

    let randomDate = RandomGeneratorHelper.randomDateBetween(
      start: Date(timeIntervalSince1970: 0), end: Date())

    let dateString = dateFormatter.string(from: randomDate)
    return dateString
  }

  // Generate a random date between two dates
  static func randomDateBetween(start: Date, end: Date) -> Date {
    let timeInterval = end.timeIntervalSince(start)
    let randomInterval = TimeInterval.random(in: 0..<timeInterval)
    return start.addingTimeInterval(randomInterval)
  }
}
