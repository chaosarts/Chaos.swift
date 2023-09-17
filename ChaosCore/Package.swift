// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ChaosCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosCore", targets: ["ChaosCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(name: "ChaosCoreMacros",
               dependencies: [
                   .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                   .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
               ]),
        .target(name: "ChaosCore",
                dependencies: [
                    "ChaosCoreMacros"
                ]),
        .testTarget(name: "ChaosCoreTests",
                    dependencies: ["ChaosCore"])
    ]
)
	
