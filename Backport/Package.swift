// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Backport",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Backport",
            targets: ["Backport"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Backport",
            dependencies: [
            ],
            path: ""
        )
    ]
)
