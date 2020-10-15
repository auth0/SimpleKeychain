// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "SimpleKeychain",
            targets: ["SimpleKeychain"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
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
        )
    ]
)
