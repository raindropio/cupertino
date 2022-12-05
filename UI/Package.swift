// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(path: "Backport"),
        .package(
            url: "https://github.com/kean/Nuke.git",
            from: "11.3.1"
        )
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .byName(name: "Backport"),
                .product(name: "NukeUI", package: "Nuke")
            ],
            path: ""
        )
    ]
)
