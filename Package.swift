// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SimpleKeychain",
    platforms: [.iOS(.v12), .macOS(.v10_15), .tvOS(.v12), .watchOS("6.2")],
    products: [.library(name: "SimpleKeychain", targets: ["SimpleKeychain"])],
    dependencies: [
        .package(name: "Quick", url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "6.0.0")),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "12.0.0"))
    ],
    targets: [
        .target(
            name: "SimpleKeychain",
            dependencies: [],
            path: "SimpleKeychain",
            exclude: ["Info.plist"]),
        .testTarget(
            name: "SimpleKeychainTests",
            dependencies: ["SimpleKeychain", "Quick", "Nimble"],
            path: "SimpleKeychainTests",
            exclude: ["Info.plist"])
    ]
)
