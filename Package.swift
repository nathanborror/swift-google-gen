// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-google-gen",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(name: "GoogleGen", targets: ["GoogleGen"]),
        .executable(name: "GoogleGenCmd", targets: ["GoogleGenCmd"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/nathanborror/swift-shared-kit", branch: "main"),
    ],
    targets: [
        .target(name: "GoogleGen", dependencies: [
            .product(name: "SharedKit", package: "swift-shared-kit"),
        ]),
        .executableTarget(name: "GoogleGenCmd", dependencies: [
            "GoogleGen",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "SharedKit", package: "swift-shared-kit"),
        ]),
    ]
)
