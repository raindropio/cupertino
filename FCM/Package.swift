// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FCM",
    platforms: [
        .iOS("16.0"),
        .visionOS("1.0")
    ],
    products: [
        .library(
            name: "FCM",
            targets: ["FCM"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.1.0"
        )
    ],
    targets: [
        .target(
            name: "FCM",
            dependencies: [
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: ""
        )
    ]
)
