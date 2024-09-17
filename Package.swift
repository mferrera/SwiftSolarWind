// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "SolarWind",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(
      name: "solarwind-example",
      targets: ["solarwind-example"]
    ),
    .library(
      name: "SolarWind",
      targets: ["SolarWind"]),
  ],
  targets: [
    .executableTarget(
      name: "solarwind-example",
      dependencies: ["SolarWind"]
    ),
    .target(
      name: "SolarWind"),
    .testTarget(
      name: "SolarWindTests",
      dependencies: ["SolarWind"]),
  ]
)
