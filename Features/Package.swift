// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(path: "API"),
        .package(path: "UI")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .byName(name: "API"),
                .byName(name: "UI")
            ],
            path: ""
        )
    ]
)
