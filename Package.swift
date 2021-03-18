// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VaporEmulsion",
    platforms: [.macOS(.v11)],
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
