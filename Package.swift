// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "SolarWind",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(
      name: "SolarWindCLI",
      targets: ["SolarWindCLI"]
    ),
    .library(
      name: "SolarWind",
      targets: ["SolarWind"]),
  ],
  targets: [
    .executableTarget(
      name: "SolarWindCLI",
      dependencies: ["SolarWind"]
    ),
    .target(
      name: "SolarWind"),
    .testTarget(
      name: "SolarWindTests",
      dependencies: ["SolarWind"]),
  ]
)
