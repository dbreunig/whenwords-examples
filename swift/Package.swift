// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "whenwords",
    targets: [
        .target(
            name: "Whenwords",
            path: ".",
            sources: ["Whenwords.swift"]
        ),
        .testTarget(
            name: "WhenwordsTests",
            dependencies: ["Whenwords"],
            path: ".",
            sources: ["WhenwordsTests.swift"]
        )
    ]
)
