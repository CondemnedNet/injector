// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Injector",
    platforms: [.iOS(.v15),
                .tvOS(.v15),
                .watchOS(.v8),
                .visionOS(.v1),
                .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Injector",
            targets: ["Injector"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.54.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Injector",
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "InjectorTests",
            dependencies: ["Injector"]),
    ]
)
