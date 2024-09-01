// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosNet",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosNet", targets: ["ChaosNet"]),
    ],
    dependencies: [
        .package(path: "../ChaosCore")
    ],
    targets: [
        .target(name: "ChaosNet",
                dependencies: ["ChaosCore"]),
        .testTarget(name: "ChaosNetTests",
                    dependencies: ["ChaosNet"])
    ]
)
	
