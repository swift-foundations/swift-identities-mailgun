//
//  Identity.Backend.Configuration.Email+Mailgun.swift
//  swift-identities-mailgun
//
//  Provides a Mailgun implementation of Identity.Backend.Configuration.Email
//

import Dependencies
import Foundation
import IdentitiesMailgun
@preconcurrency import IdentitiesTypes
import Identity_Backend
import Logger_Dependencies
import Logging
import Mailgun_Messages_Types

extension Identity.Backend.Configuration.Email {
    /// Creates an Identity.Backend.Configuration.Email that uses Mailgun for sending all identity-related emails.
    ///
    /// This provides a complete email configuration that can be plugged into
    /// Identity.Backend.Configuration or Identity.Standalone.Configuration.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    ///   - sendEmail: Custom email sender.
    /// - Returns: A configured Identity.Backend.Configuration.Email with Mailgun email support
    public static func mailgun<
        Router: ParserPrinter<URLRequestData, Identity.Route> & Sendable,
        SendFailure: Swift.Error
    >(
        business: BusinessDetails,
        router: Router,
        sendEmail:
            @escaping @Sendable (Mailgun.Messages.Send.Request) async throws(SendFailure) ->
            Void
    ) -> Self {
        @Dependency(\.logger) var logger

        return Self(
            sendVerificationEmail: { email, token in
                let verificationUrl = router.url(
                    for: .create(.view(.verify(.init(token: token, email: email.rawValue))))
                )
                let request = try Mailgun.Messages.Send.Request.requestEmailVerification(
                    verificationUrl: verificationUrl,
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendPasswordResetEmail: { email, token in
                let resetUrl = router.url(
                    for: .password(.view(.reset(.confirm(.init(token: token)))))
                )
                let request = try Mailgun.Messages.Send.Request.passwordResetRequest(
                    resetUrl: resetUrl,
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendPasswordChangeNotification: { email in
                let request = try Mailgun.Messages.Send.Request.passwordChangeNotification(
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendEmailChangeConfirmation: { currentEmail, newEmail, token in
                let verificationURL = router.url(
                    for: .email(.api(.change(.confirm(.init(token: token)))))
                )
                let request = try Mailgun.Messages.Send.Request.emailChangeConfirmationRequest(
                    verificationURL: verificationURL,
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(request)
            },
            sendEmailChangeRequestNotification: { currentEmail, newEmail in
                let request = try Mailgun.Messages.Send.Request.emailChangeRequestNotification(
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(request)
            },
            onEmailChangeSuccess: { currentEmail, newEmail in
                // Send notification to old email
                let oldEmailRequest = try Mailgun.Messages.Send.Request
                    .emailChangeSuccessToOldEmail(
                        currentEmail: currentEmail,
                        newEmail: newEmail,
                        business: business
                    )
                try await sendEmail(oldEmailRequest)

                // Send welcome to new email
                let newEmailRequest = try Mailgun.Messages.Send.Request
                    .emailChangeSuccessToNewEmail(
                        currentEmail: currentEmail,
                        newEmail: newEmail,
                        business: business
                    )
                try await sendEmail(newEmailRequest)
            },
            sendDeletionRequestNotification: { email in
                let request = try Mailgun.Messages.Send.Request.deletionRequestNotification(
                    email: email,
                    business: business
                )
                try await sendEmail(request)
            },
            sendDeletionConfirmationNotification: { email in
                let request = try Mailgun.Messages.Send.Request.deletionConfirmationNotification(
                    email: email,
                    business: business
                )
                try await sendEmail(request)
            },
            onIdentityCreationSuccess: { identity in
                // Optional: Send welcome email
                logger.info("New identity created: \(identity.email)")
            }
        )
    }

    /// Creates an Identity.Backend.Configuration.Email that uses the `Mailgun.Messages` dependency
    /// for sending all identity-related emails, logging every send outcome.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    /// - Returns: A configured Identity.Backend.Configuration.Email with Mailgun email support
    public static func mailgun<Router: ParserPrinter<URLRequestData, Identity.Route> & Sendable>(
        business: BusinessDetails,
        router: Router
    ) -> Self {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.logger) var logger

        return Self.mailgun(business: business, router: router) { request in
            do {
                let response = try await messages.client.send(request)
                logger.info(
                    "Email sent successfully",
                    metadata: [
                        "messageId": "\(response.id)",
                        "to": "\(request.to.map(\.rawValue).joined(separator: ", "))",
                    ]
                )
            } catch {
                logger.error(
                    "Failed to send email",
                    metadata: [
                        "error": "\(error)",
                        "to": "\(request.to.map(\.rawValue).joined(separator: ", "))",
                    ]
                )
                throw error
            }
        }
    }

    /// Creates a logging-only Identity.Backend.Configuration.Email for development/testing.
    ///
    /// This implementation logs all email operations without actually sending emails.
    /// Useful for local development and testing without Mailgun configuration.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    /// - Returns: A configured Identity.Backend.Configuration.Email that only logs email operations
    public static func mailgunLogging<
        Router: ParserPrinter<URLRequestData, Identity.Route> & Sendable
    >(
        business: BusinessDetails,
        router: Router
    ) -> Self {
        @Dependency(\.logger) var logger

        return Self(
            sendVerificationEmail: { email, token in
                let verificationUrl = router.url(
                    for: .create(.view(.verify(.init(token: token, email: email.rawValue))))
                )
                logger.info(
                    "Would send verification email",
                    metadata: [
                        "to": "\(email)",
                        "url": "\(verificationUrl)",
                    ]
                )
            },
            sendPasswordResetEmail: { email, token in
                let resetUrl = router.url(
                    for: .password(.view(.reset(.confirm(.init(token: token)))))
                )
                logger.info(
                    "Would send password reset email",
                    metadata: [
                        "to": "\(email)",
                        "url": "\(resetUrl)",
                    ]
                )
            },
            sendPasswordChangeNotification: { email in
                logger.info(
                    "Would send password change notification",
                    metadata: [
                        "to": "\(email)"
                    ]
                )
            },
            sendEmailChangeConfirmation: { currentEmail, newEmail, token in
                let verificationURL = router.url(
                    for: .email(.api(.change(.confirm(.init(token: token)))))
                )
                logger.info(
                    "Would send email change confirmation",
                    metadata: [
                        "currentEmail": "\(currentEmail)",
                        "newEmail": "\(newEmail)",
                        "url": "\(verificationURL)",
                    ]
                )
            },
            sendEmailChangeRequestNotification: { currentEmail, newEmail in
                logger.info(
                    "Would send email change request notification",
                    metadata: [
                        "currentEmail": "\(currentEmail)",
                        "newEmail": "\(newEmail)",
                    ]
                )
            },
            onEmailChangeSuccess: { currentEmail, newEmail in
                logger.info(
                    "Would send email change success notifications",
                    metadata: [
                        "oldEmail": "\(currentEmail)",
                        "newEmail": "\(newEmail)",
                    ]
                )
            },
            sendDeletionRequestNotification: { email in
                logger.info(
                    "Would send deletion request notification",
                    metadata: [
                        "to": "\(email)"
                    ]
                )
            },
            sendDeletionConfirmationNotification: { email in
                logger.info(
                    "Would send deletion confirmation",
                    metadata: [
                        "to": "\(email)"
                    ]
                )
            },
            onIdentityCreationSuccess: { identity in
                logger.info(
                    "Identity created successfully",
                    metadata: [
                        "id": "\(identity.id)",
                        "email": "\(identity.email)",
                    ]
                )
            }
        )
    }
}
