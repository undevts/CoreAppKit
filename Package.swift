// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "CoreAppKit",
    products: [
        .library(
            name: "CoreAppKit",
            targets: ["CoreAppKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/undevts/CoreSwift.git", from: "0.1.3"),
        .package(url: "https://github.com/undevts/LayoutKit.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "CoreAppKit",
            dependencies: [
                "CoreAsyncKit",
                .product(name: "CoreSwift", package: "CoreSwift"),
                .product(name: "LayoutKit", package: "LayoutKit"),
            ]),
        .target(
            name: "CoreAsyncKit",
            dependencies: [
                .product(name: "CoreSwift", package: "CoreSwift"),
                .product(name: "NIOCore", package: "swift-nio"),
            ]),
        .testTarget(
            name: "CoreAppKitTests",
            dependencies: ["CoreAppKit"]),
    ]
)
