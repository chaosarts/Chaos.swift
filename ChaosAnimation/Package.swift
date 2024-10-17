// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosAnimation",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14)],
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
	
