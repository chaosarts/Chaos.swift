// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ChaosCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosCore", targets: ["ChaosCore"])
    ],
    dependencies: [
        .package(path: "../ChaosMacroKit"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.3"),
    ],
    targets: [
        .macro(
            name: "ChaosCoreMacros",
            dependencies: [
                "ChaosMacroKit",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "ChaosCore",
            dependencies: [
                "ChaosCoreMacros"
            ]
        ),
        .testTarget(name: "ChaosCoreTests",
                    dependencies: ["ChaosCore"])
    ]
)
	
