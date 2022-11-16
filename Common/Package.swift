// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
            ],
            path: ""
        )
    ]
)
