// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosMath",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosMath", targets: ["ChaosMath"]),
    ],
    dependencies: [
        .package(path: "../ChaosCore")
    ],
    targets: [
        .target(name: "ChaosMath",
                dependencies: ["ChaosCore"]),
        .testTarget(name: "ChaosMathTests",
                    dependencies: ["ChaosMath"])
    ]
)

