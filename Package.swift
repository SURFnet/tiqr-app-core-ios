// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tiqr",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Tiqr",
            targets: ["Tiqr"]),
    ],
    dependencies: [
        .package(url: "https://github.com/roberthein/TinyConstraints.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "Tiqr",
            dependencies: ["TiqrCoreObjC", "TiqrCore"]
        ),
        .target(
            name: "TiqrCore"
        ),
        .target(
            name: "TiqrCoreObjC",
            dependencies: ["TiqrCore", "EduIDExpansion"],
            resources: [
                .process("Resources/Audio/cowbell.wav"),
                .process("Resources/Views/HTML/start.html")]
        ),
        .target(
            name: "EduIDExpansion",
            dependencies: ["TinyConstraints"]
        )
    ]
)
