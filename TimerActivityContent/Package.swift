// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TimerActivityContent",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "TimerActivityContent",
            targets: ["TimerActivityContent"]
        ),
    ],
    targets: [
        .target(
            name: "TimerActivityContent"
        ),
    ]
)
