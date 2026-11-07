// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "vapor-emulsion",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "VaporEmulsion", targets: ["VaporEmulsion"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "VaporEmulsion",
            path: "Sources"),
        .testTarget(
            name: "VaporEmulsionTests",
            dependencies: ["VaporEmulsion"],
            path: "Tests"),
    ]
)
