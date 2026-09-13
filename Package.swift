// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TFYProgressSwiftHUD",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "TFYProgressSwiftHUD", targets: ["TFYProgressSwiftHUD"])
    ],
    targets: [
        .target(
            name: "TFYProgressSwiftHUD",
            path: "TFYProgressSwiftHUD/TFYProgressSwiftHUD"
        ),
        .testTarget(
            name: "TFYProgressSwiftHUDPackageTests",
            dependencies: ["TFYProgressSwiftHUD"],
            path: "Tests/TFYProgressSwiftHUDPackageTests"
        )
    ]
)
