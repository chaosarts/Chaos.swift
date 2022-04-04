// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chaos",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosAnimation", targets: ["ChaosAnimation"]),
        .library(name: "ChaosCore", targets: ["ChaosCore"]),
        .library(name: "ChaosGraphics", targets: ["ChaosGraphics"]),
        .library(name: "ChaosKit", targets: ["ChaosKit"]),
        .library(name: "ChaosMath", targets: ["ChaosMath"]),
        .library(name: "ChaosMetal", targets: ["ChaosMetal"]),
        .library(name: "ChaosNet", targets: ["ChaosNet"]),
        .library(name: "ChaosThree", targets: ["ChaosThree"]),
        .library(name: "ChaosUi", targets: ["ChaosUi"]),
        .library(name: "ChaosSwiftUI", targets: ["ChaosSwiftUI"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ChaosAnimation",
            dependencies: [
                "ChaosCore",
                "ChaosGraphics"
            ],
            path: "ChaosAnimation/Classes"
        ),
        .target(
            name: "ChaosCore",
            path: "ChaosCore/Classes"
        ),
        .testTarget(
            name: "ChaosCoreTests",
            dependencies: ["ChaosCore"],
            path: "ChaosCore/Tests"
        ),
        .target(
            name: "ChaosGraphics",
            dependencies: [
                "ChaosCore",
                "ChaosMath"
            ],
            path: "ChaosGraphics/Classes"
        ),
        .target(
            name: "ChaosMath",
            dependencies: [
                "ChaosCore"
            ],
            path: "ChaosMath/Classes"
        ),
        .testTarget(
            name: "ChaosMathTests",
            dependencies: ["ChaosCore", "ChaosMath"],
            path: "ChaosMath/Tests"
        ),
        .target(
            name: "ChaosMetal",
            dependencies: [
                "ChaosCore",
                "ChaosMath"
            ],
            path: "ChaosMetal/Classes"
        ),
        .target(
            name: "ChaosNet",
            dependencies: [
                "ChaosCore"
            ],
            path: "ChaosNet/Classes"
        ),
        .testTarget(
            name: "ChaosNetTests",
            dependencies: ["ChaosNet"],
            path: "ChaosNet/Tests",
            resources: [
                .process("Resources", localization: nil)
            ]
        ),
        .target(
            name: "ChaosThree",
            dependencies: [
                "ChaosCore",
                "ChaosMath"
            ],
            path: "ChaosThree/Classes"
        ),
        .target(
            name: "ChaosUi",
            dependencies: [
                "ChaosCore",
                "ChaosGraphics",
                "ChaosAnimation"
            ],
            path: "ChaosUi/Classes"
        ),
        .target(
            name: "ChaosKit",
            dependencies: [
                "ChaosCore",
                "ChaosNet",
                "ChaosUi"
            ],
            path: "ChaosKit/Classes"
        ),
        .target(
            name: "ChaosSwiftUI",
            dependencies: [
                "ChaosCore",
                "ChaosGraphics",
            ],
            path: "ChaosSwiftUI/Classes"
        )
    ]
)
