// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LayoutlessRebeloper",
    platforms: [
        .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "LayoutlessRebeloper", targets: ["Layoutless"])
    ],
    targets: [
        .target(name: "Layoutless", path: "Sources")
    ]
)
