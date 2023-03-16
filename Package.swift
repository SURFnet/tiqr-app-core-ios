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
            targets: ["Tiqr", "EduIDExpansion"]),
    ],
    dependencies: [
        .package(url: "https://github.com/roberthein/TinyConstraints.git", from: "4.0.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0"),
        .package(url: "https://github.com/openid/AppAuth-iOS.git", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        .target(
            name: "Tiqr",
            dependencies: ["TiqrCoreObjC", "TiqrCore"]
        ),
        .target(
            name: "EduIDExpansion",
            dependencies: ["TiqrCoreObjC", "TinyConstraints", "OpenAPIClient", .product(name: "AppAuth", package: "AppAuth-iOS")]
        ),
        .target(
            name: "TiqrCore"
        ),
        .target(
            name: "TiqrCoreObjC",
            dependencies: ["TiqrCore"],
            resources: [
                .process("Resources/Audio/cowbell.wav"),
                .process("Resources/Views/HTML/start.html")],
            cSettings: [
                    .headerSearchPath("Internal"), 
                 ]
        ),
        .target(
            name: "OpenAPIClient",
            dependencies: ["AnyCodable", .product(name: "AppAuth", package: "AppAuth-iOS")]
        )
    ]
)
