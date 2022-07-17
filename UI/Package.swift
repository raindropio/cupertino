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
            url: "https://github.com/SwiftUIX/SwiftUIX",
            branch: "master"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: ["SwiftUIX", .product(name: "Algorithms", package: "swift-algorithms")],
            path: ""
        )
    ]
)
