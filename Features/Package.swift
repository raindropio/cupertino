// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(path: "API"),
        .package(path: "Backport"),
        .package(path: "UI")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .byName(name: "API"),
                .byName(name: "Backport"),
                .byName(name: "UI")
            ],
            path: ""
        )
    ]
)
