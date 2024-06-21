// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [.iOS(.v13), .macOS(.v11), .tvOS(.v13), .watchOS(.v7)],
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
