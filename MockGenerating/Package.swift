// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockGenerating",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MockGenerating",
            targets: ["MockGenerating"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hummingbird-project/swift-mustache.git",
            from: "2.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MockGenerating"),
        .testTarget(
            name: "MockGeneratingTests",
            dependencies: [
                "MockGenerating",
                .product(name: "Mustache", package: "swift-mustache")
            ],
            resources: [
                .copy("Resources/Fixtures"),
                .copy("Resources/Templates")
            ]
        ),
    ]
)
