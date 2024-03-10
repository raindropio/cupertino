// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SignInWithGoogle",
    platforms: [
        .iOS("16.0"),
        .visionOS("1.0")
    ],
    products: [
        .library(
            name: "SignInWithGoogle",
            targets: ["SignInWithGoogle"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS",
            from: "7.0.0"
        )
    ],
    targets: [
        .target(
            name: "SignInWithGoogle",
            dependencies: [
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            path: ""
        )
    ]
)
