// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [
        .iOS("9.0"),
        .macOS("10.11"),
        .watchOS("2.0"),
        .tvOS("9.0"),
    ],
    products: [
        .library(
            name: "SimpleKeychain",
            targets: ["SimpleKeychain"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", from: "2.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "8.0.0"),

    ],
    targets: [
        .target(
            name: "SimpleKeychain",
            dependencies: [],
            path: "SimpleKeychain"
        ),
        .testTarget(
            name: "SimpleKeychainTests",
            dependencies: ["SimpleKeychain", "Quick", "Nimble"],
            path: "SimpleKeychainTests"
        ),
    ]
)