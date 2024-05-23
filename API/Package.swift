// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "API",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0"),
        .visionOS("1.0")
    ],
    products: [
        .library(
            name: "API",
            targets: ["API"]
        ),
    ],
    dependencies: [
//        .package(
//            url: "https://github.com/apple/swift-collections.git",
//            .upToNextMinor(from: "1.0.0") // or `.upToNextMajor
//        )
    ],
    targets: [
        .target(
            name: "API",
            dependencies: [
//                .product(name: "Collections", package: "swift-collections")
            ],
            path: ""
        )
    ]
)
