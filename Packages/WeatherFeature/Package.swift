// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherFeature",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherFeature",
            targets: ["WeatherFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../WeatherCore"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeatherFeature",
            dependencies: [
                "WeatherCore",
            ],
        ),
        .testTarget(
            name: "WeatherFeatureTests",
            dependencies: ["WeatherFeature"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
