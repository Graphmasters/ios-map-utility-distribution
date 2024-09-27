// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "ios-map-utility",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "GMMapUtility",
            targets: ["GMMapUtility"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/maplibre/maplibre-gl-native-distribution.git", from: "5.13.0")
    ],
    targets: [
        .target(
            name: "GMMapUtility",
            dependencies: [
                .product(name: "Mapbox", package: "maplibre-gl-native-distribution")
            ],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
