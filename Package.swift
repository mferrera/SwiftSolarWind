// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "SolarWind",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .library(
      name: "SolarWind",
      targets: ["SolarWind"])
  ],
  targets: [
    .target(
      name: "SolarWind"),
    .testTarget(
      name: "SolarWindTests",
      dependencies: ["SolarWind"]),
  ]
)
