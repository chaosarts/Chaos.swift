// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chaos",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosCore", targets: ["ChaosCore"]),
        .library(name: "ChaosNet", targets: ["ChaosNet"]),
        .library(name: "ChaosGraphics", targets: ["ChaosGraphics"]),
        .library(name: "ChaosUi", targets: ["ChaosUi"]),
        .library(name: "ChaosKit", targets: ["ChaosKit"])
    ],
    dependencies: [
        .package(name: "Promises", url: "https://github.com/google/promises.git", "1.2.8" ..< "1.3.0"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", "5.4.1" ..< "5.5.0")
    ],
    targets: [
        .target(
            name: "ChaosCore",
            dependencies: [
                .product(name: "Promises", package: "Promises")
            ],
            path: "ChaosCore/Classes"
        ),
        .testTarget(
            name: "ChaosCoreTest",
            dependencies: [
                "ChaosCore"
            ],
            path: "Example/Tests/ChaosCore"
        ),
        .target(
            name: "ChaosNet",
            dependencies: [
                "ChaosCore",
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "ChaosNet"
        ),
        .target(
            name: "ChaosGraphics",
            dependencies: [
                "ChaosCore"
            ],
            path: "ChaosGraphics"
        ),
        .target(
            name: "ChaosUi",
            dependencies: [
                "ChaosCore",
                "ChaosGraphics"
            ],
            path: "ChaosUi"
        ),
        .target(
            name: "ChaosKit",
            dependencies: [
                "ChaosCore",
                "ChaosNet",
                "ChaosUi"
            ],
            path: "ChaosKit"
        )
    ]
)
