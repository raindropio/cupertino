// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Backport",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
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
            path: "",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        )
    ]
)
