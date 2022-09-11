// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreedyKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GreedyKit",
            targets: ["GreedyKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GreedyKit",
            dependencies: []
        ),
        .testTarget(
            name: "GreedyKitTests",
            dependencies: ["GreedyKit"]
        )
    ]
)
