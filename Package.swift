// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chaos",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
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
    ],
    dependencies: [
        .package(name: "Promises", url: "https://github.com/google/promises.git", "1.2.8" ..< "1.3.0"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", "5.4.1" ..< "5.5.0")
    ],
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
            dependencies: [
                .product(name: "Promises", package: "Promises")
            ],
            path: "ChaosCore/Classes"
        ),
        .target(
            name: "ChaosGraphics",
            dependencies: [
                "ChaosCore"
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
                "ChaosCore",
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "ChaosNet/Classes"
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
                "ChaosGraphics"
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
        )
    ]
)
