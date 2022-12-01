// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tiqr",
    defaultLocalization: "en",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "Tiqr",
            targets: ["Tiqr"]),
    ],
    targets: [
        .target(
            name: "Tiqr",
            dependencies: ["TiqrCoreObjC", "TiqrCore"]),
        .target(
            name: "TiqrCore"
        ),
        .target(
            name: "TiqrCoreObjC",
            dependencies: ["TiqrCore"],
            resources: [
                .process("Resources/Audio/cowbell.wav"),
                .process("Resources/Views/HTML/start.html")
            ])
    ]
)
