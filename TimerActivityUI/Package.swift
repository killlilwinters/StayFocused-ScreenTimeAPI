// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// https://stackoverflow.com/a/79265117
//
import PackageDescription

let package = Package(
    name: "TimerActivityUI",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "TimerActivityUI",
            targets: ["TimerActivityUI"]
        ),
    ],
    dependencies: [
        .package(path: "../TimerActivityContent"),
    ],
    targets: [
        .target(name: "TimerActivityUI", dependencies: ["TimerActivityContent"])
    ]
)
