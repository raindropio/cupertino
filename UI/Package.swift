// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/onevcat/Kingfisher",
            from: "7.0.0"
        )
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                "Kingfisher"
            ],
            path: ""
        )
    ]
)
