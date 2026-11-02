// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)],
    products: [.library(name: "SimpleKeychain", targets: ["SimpleKeychain"])],
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
