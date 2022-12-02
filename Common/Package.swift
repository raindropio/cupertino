// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        ),
    ],
    dependencies: [
        .package(path: "API"),
        .package(path: "UI")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                .byName(name: "API"),
                .byName(name: "UI")
            ],
            path: ""
        )
    ]
)
