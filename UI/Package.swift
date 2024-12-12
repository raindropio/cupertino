// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0"),
        .visionOS("1.0")
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/kean/Nuke.git",
            from: "13.0.0-beta.1"
        )
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .product(name: "NukeUI", package: "Nuke")
            ],
            path: ""
        )
    ]
)
