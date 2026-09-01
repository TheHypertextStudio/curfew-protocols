// swift-tools-version:5.9
//
// Curfew Protocols — the Swift face of the @thehypertextstudio/curfew-protocols
// versioned wire-format contract. The Swift sources under
// `generated/swift/Sources/CurfewProtocols/` are emitted from the canonical
// JSON Schemas in `schemas/` by `codegen/swift.ts`. They are committed so
// downstream consumers (the Curfew macOS app, the curfew-mcp binary) don't
// need a Node toolchain to build.
//
// Every change to a schema must be paired with `pnpm codegen` and a contract
// test pass before the new revision is tagged — see AGENTS.md.

import PackageDescription

let package = Package(
    name: "CurfewProtocols",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CurfewProtocols",
            targets: ["CurfewProtocols"]
        )
    ],
    targets: [
        .target(
            name: "CurfewProtocols",
            path: "generated/swift/Sources/CurfewProtocols"
        ),
        .testTarget(
            name: "CurfewProtocolsTests",
            dependencies: ["CurfewProtocols"],
            path: "generated/swift/Tests/CurfewProtocolsTests"
        )
    ]
)
