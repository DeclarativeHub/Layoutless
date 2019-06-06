// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Layoutless",
    platforms: [
        .macOS(.v10_11), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "Layoutless", targets: ["Layoutless"])
    ],
    targets: [
        .target(name: "Layoutless", path: "Sources")
    ]
)
