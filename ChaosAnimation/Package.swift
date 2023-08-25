// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosAnimation",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosAnimation",
                 targets: ["ChaosAnimation"]),
    ],
    dependencies: [
        .package(path: "../ChaosGraphics"),
        .package(path: "../ChaosMath")
    ],
    targets: [
        .target(name: "ChaosAnimation",
                dependencies: ["ChaosGraphics",
                               "ChaosMath"])
    ]
)
	
