// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chaos",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Chaos", targets: ["Chaos"])
    ],
    dependencies: [
        .package(path: "ChaosAnimation"),
        .package(path: "ChaosCore"),
        .package(path: "ChaosCombine"),
        .package(path: "ChaosGraphics"),
        .package(path: "ChaosKit"),
        .package(path: "ChaosMath"),
        .package(path: "ChaosMetal"),
        .package(path: "ChaosNet"),
        .package(path: "ChaosThree"),
        .package(path: "ChaosUi"),
        .package(path: "ChaosSwiftUI")
    ],
    targets: [
        .target(
            name: "Chaos",
            dependencies: [
                "ChaosAnimation",
                "ChaosCore",
                "ChaosCombine",
                "ChaosGraphics",
                "ChaosKit",
                "ChaosMath",
                "ChaosMetal",
                "ChaosNet",
                "ChaosThree",
                "ChaosUi",
                "ChaosSwiftUI"
            ]
        )
    ]
)
