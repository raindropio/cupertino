// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "API",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "API",
            targets: ["API"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "API",
            dependencies: [],
            path: ""
        )
    ]
)
