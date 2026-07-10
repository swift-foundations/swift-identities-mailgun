// swift-tools-version: 6.3.3

import Foundation
import PackageDescription

extension String {
    static let identitiesMailgun: Self = "IdentitiesMailgun"
    static let identitiesMailgunLive: Self = "IdentitiesMailgunLive"
}

extension Target.Dependency {
    static var identitiesMailgun: Self { .target(name: .identitiesMailgun) }
    static var identitiesMailgunLive: Self { .target(name: .identitiesMailgunLive) }
}

extension Target.Dependency {
    static var identitiesTypes: Self { .product(name: "IdentitiesTypes", package: "swift-identities-types") }
    static var identities: Self { .product(name: "Identity Backend", package: "swift-authentication") }
    static var mailgunMessages: Self { .product(name: "Mailgun Messages", package: "swift-mailgun") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var HTMLEmail: Self { .product(name: "HTMLEmail", package: "swift-html") }
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlWebsite: Self { .product(name: "HTMLWebsite", package: "swift-html") }
    static var serverFoundation: Self { .product(name: "ServerFoundation", package: "swift-server-foundation") }
}

let package = Package(
    name: "swift-identities-mailgun",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: .identitiesMailgun, targets: [.identitiesMailgun]),
        .library(name: .identitiesMailgunLive, targets: [.identitiesMailgunLive])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-identities-types.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-authentication.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-mailgun.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-server-foundation.git", branch: "main")
    ],
    targets: [
        .target(
            name: .identitiesMailgun,
            dependencies: [
                .identitiesTypes,
                .identities,
                .mailgunMessages,
                .HTMLEmail,
                .html,
                .htmlWebsite,
                .serverFoundation
            ]
        ),
        .target(
            name: .identitiesMailgunLive,
            dependencies: [
                .identitiesMailgun,
                .dependencies
            ]
        ),
        .testTarget(
            name: .identitiesMailgun.tests,
            dependencies: [
                .identitiesMailgun,
                .identitiesMailgunLive
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String { var tests: Self { "\(self) Tests" } }
