// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [.iOS(.v14), .macOS(.v10_15), .tvOS(.v14), .watchOS(.v7), .visionOS(.v1)],
    products: [
      .library(name: "SimpleKeychain", targets: ["SimpleKeychain"]),
      .library(name: "SimpleKeychain-dynamic", type: .dynamic, targets: ["SimpleKeychain"])
    ],
    targets: [
        .target(
            name: "SimpleKeychain",
            dependencies: [],
            path: "SimpleKeychain",
            exclude: ["Info.plist"]),
        .testTarget(
            name: "SimpleKeychainTests",
            dependencies: [
                "SimpleKeychain",
            ],
            path: "SimpleKeychainTests",
            exclude: ["Info.plist"])
    ]
)
