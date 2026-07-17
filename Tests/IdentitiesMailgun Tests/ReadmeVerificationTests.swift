//
//  ReadmeVerificationTests.swift
//  swift-identities-mailgun
//
//  README code example verification tests
//

import Dependencies
import IdentitiesMailgun
import IdentitiesMailgunLive
import IdentitiesTypes
import Identity_Backend
import Testing

@Suite
struct Test {

    @Test
    func `Business Details initialization - README line 42-46`() throws {
        // Example from README - Basic Setup with Live Mailgun
        let business = BusinessDetails(
            name: "MyApp",
            supportEmail: try EmailAddress("support@myapp.com"),
            fromEmail: try EmailAddress("noreply@myapp.com")
        )

        #expect(business.name == "MyApp")
        #expect(business.supportEmail.rawValue == "support@myapp.com")
        #expect(business.fromEmail.rawValue == "noreply@myapp.com")
    }

    @Test
    func `Email configuration type exists`() throws {
        // Verify Identity.Backend.Configuration.Email type exists
        let _: Identity.Backend.Configuration.Email.Type = Identity.Backend.Configuration.Email.self
    }
}
