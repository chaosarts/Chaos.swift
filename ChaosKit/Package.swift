// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChaosKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ChaosKit", targets: ["ChaosKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "ChaosKit"),
    ]
)
	
