// swift-tools-version: 5.10.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOS",
    products: [
        .library(
            name: "SwiftOS",
            type: .static,
            targets: ["SwiftOS"]),
        .library(
            name: "Cibrary",
            type: .static,
            targets: ["Cibrary"]),
    ],

    targets: [
        .target(
            name: "SwiftOS",
            dependencies: (["Cibrary"]),
            swiftSettings: [
                .interoperabilityMode(.C),
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags([
                    "-whole-module-optimization", 
                    "-disable-batch-mode", 
                    "-Xfrontend", "-disable-stack-protector",
                    "-Xcc", "-mstrict-align",
                    "-Xcc", "-mgeneral-regs-only",
                    "-Xcc", "-mno-implicit-float",
                ]),
            ]
        ),
        .target(
            name: "Cibrary",
            cSettings: [
                .unsafeFlags([
                    "-mstrict-align",
                    "-mgeneral-regs-only",
                    "-mno-implicit-float",
                ])
            ]
        ),
    ]
)
