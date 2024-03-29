// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosMetal",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosMetal", targets: ["ChaosMetal"]),
    ],
    dependencies: [
        .package(path: "../ChaosMath")
    ],
    targets: [
        .target(name: "ChaosMetal",
                dependencies: ["ChaosMath"]),
        .testTarget(name: "ChaosMetalTests",
                    dependencies: ["ChaosMetal"])
    ]
)
	
