// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Chaos",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosCore", targets:["ChaosCore"]),
        .library(name: "ChaosAnimation", targets:["ChaosAnimation"]),
        .library(name: "ChaosCombine", targets:["ChaosCombine"]),
        .library(name: "ChaosGraphics", targets:["ChaosGraphics"]),
        .library(name: "ChaosMath", targets:["ChaosMath"]),
        .library(name: "ChaosMetal", targets:["ChaosMetal"]),
        .library(name: "ChaosNet", targets:["ChaosNet"]),
        .library(name: "ChaosSwiftUI", targets:["ChaosSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "601.0.0")
    ],
    targets: [
        .target(
            name: "ChaosMacroKit",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "ChaosMacroKit"
        ),
        .macro(
            name: "ChaosCoreMacros",
            dependencies: [
                "ChaosMacroKit",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "ChaosCoreMacros"
        ),
        .testTarget(
            name: "ChaosCoreTests",
            dependencies: ["ChaosCore"],
            path: "ChaosCoreTests"
        ),
        .target(
            name: "ChaosCore",
            dependencies: [
                "ChaosCoreMacros"
            ],
            path: "ChaosCore"
        ),

        .target(
            name: "ChaosCombine",
            path: "ChaosCombine"
        ),

        .target(
            name: "ChaosMath",
            dependencies: [
                "ChaosCore"
            ],
            path: "ChaosMath"
        ),
        .testTarget(
            name: "ChaosMathTests",
            dependencies: [
                "ChaosCore",
                "ChaosMath"
            ],
            path: "ChaosMathTests"
        ),

        .target(
            name: "ChaosGraphics",
            dependencies: [
                "ChaosMath"
            ],
            path: "ChaosGraphics"
        ),


        .target(
            name: "ChaosAnimation",
            dependencies: [
                "ChaosGraphics"
            ],
            path: "ChaosAnimation"
        ),

        .target(
            name: "ChaosMetal",
            dependencies: [
                "ChaosMath"
            ],
            path: "ChaosMetal"
        ),
        .target(
            name: "ChaosNet",
            dependencies: [
                "ChaosCore"
            ],
            path: "ChaosNet"
        ),

        .macro(
            name: "ChaosSwiftUIMacros",
            dependencies: [
                "ChaosCore",
                "ChaosMacroKit",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "ChaosSwiftUIMacros"
        ),
        .target(
            name: "ChaosSwiftUI",
            dependencies: [
                "ChaosCore",
                "ChaosNet",
                "ChaosSwiftUIMacros"
            ],
            path: "ChaosSwiftUI"
        ),
    ]
)
