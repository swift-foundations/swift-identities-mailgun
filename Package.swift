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
    static var emailAddress: Self { .product(name: "EmailAddress", package: "swift-emailaddress") }
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var loggerDependencies: Self { .product(name: "Logger Dependencies", package: "swift-logger-dependencies") }
    static var logging: Self { .product(name: "Logging", package: "swift-log") }
    static var translatedString: Self { .product(name: "Translated String", package: "swift-translating") }
    // The email document shell + email-safe components (Email.Document /
    // VStack / Header / Paragraph / Link). Replaces the retired HTMLEmail and
    // HTMLWebsite products, which swift-html no longer vends — it vends exactly
    // one product, "HTML".
    static var emailHTMLRendering: Self {
        .product(name: "Email HTML Rendering", package: "swift-email-html")
    }
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
        .package(url: "https://github.com/swift-foundations/swift-emailaddress.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-email-html.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-logger-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-translating.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-log.git", branch: "main")
    ],
    targets: [
        .target(
            name: .identitiesMailgun,
            dependencies: [
                .identitiesTypes,
                .identities,
                .mailgunMessages,
                .emailAddress,
                .html,
                .emailHTMLRendering,
                .translatedString
            ]
        ),
        .target(
            name: .identitiesMailgunLive,
            dependencies: [
                .identitiesMailgun,
                .dependencies,
                .loggerDependencies,
                .logging
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
