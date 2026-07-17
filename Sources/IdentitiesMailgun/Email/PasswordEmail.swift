//
//  PasswordEmail.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Email_HTML_Rendering
import Foundation
import HTML
import IdentitiesTypes
import Mailgun_Messages_Types
import Translated_String

// MARK: - Password Reset Request

extension Mailgun.Messages.Send.Request {
    public static func passwordResetRequest(
        resetUrl: URL,
        business: BusinessDetails,
        to user: EmailAddress
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Reset je wachtwoord",
            english: "Reset your password"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Reset je wachtwoord voor \(business.name)",
                english: "Reset your password for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Reset je wachtwoord",
                                english: "Reset your password"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We hebben een verzoek ontvangen om het wachtwoord voor je \(business.name) account te resetten. Klik op de onderstaande knop om je wachtwoord te wijzigen.",
                                english:
                                    "We received a request to reset the password for your \(business.name) account. Click the button below to change your password."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Link(href: .init(value: resetUrl.absoluteString)) {
                            TranslatedString(
                                dutch: "Reset wachtwoord",
                                english: "Reset password"
                            ).description
                        }
                        .color(.text.primary.reverse())
                        .padding(bottom: .medium)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch: "Om veiligheidsredenen verloopt deze link binnen 1 uur.",
                                english: "This link will expire in 1 hour for security reasons."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je geen wachtwoordreset hebt aangevraagd, kun je deze e-mail negeren.",
                                english:
                                    "If you didn't request a password reset, you can ignore this email."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Voor hulp, neem contact op met ons op via \(business.supportEmail).",
                                english: "For help, contact us at \(business.supportEmail)."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
        .backgroundColor(.background.primary.reverse())

        return .init(
            from: business.fromEmail,
            to: [user],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Password Reset Confirmation

extension Mailgun.Messages.Send.Request {
    public static func passwordResetConfirmation(
        business: BusinessDetails,
        to user: EmailAddress
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Wachtwoord succesvol gereset",
            english: "Password Successfully Reset"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Je wachtwoord is succesvol gereset voor \(business.name)",
                english: "Your password has been successfully reset for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Wachtwoord succesvol gereset",
                                english: "Password Successfully Reset"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We bevestigen dat je wachtwoord voor je \(business.name) account succesvol is gereset.",
                                english:
                                    "We confirm that the password for your \(business.name) account has been successfully reset."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch: "Je kunt nu inloggen met je nieuwe wachtwoord.",
                                english: "You can now log in using your new password."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je deze wijziging niet hebt aangevraagd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                                english:
                                    "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
        .backgroundColor(.background.primary.reverse())

        return .init(
            from: business.fromEmail,
            to: [user],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Password Change Notification

extension Mailgun.Messages.Send.Request {
    public static func passwordChangeNotification(
        business: BusinessDetails,
        to user: EmailAddress
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Wachtwoord gewijzigd",
            english: "Password Changed"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Je wachtwoord is gewijzigd voor \(business.name)",
                english: "Your password has been changed for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Wachtwoord gewijzigd",
                                english: "Password Changed"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We willen je informeren dat het wachtwoord voor je \(business.name) account zojuist is gewijzigd.",
                                english:
                                    "We're writing to inform you that the password for your \(business.name) account has just been changed."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Als je deze wijziging hebt aangevraagd, kun je deze e-mail als bevestiging beschouwen.",
                                english:
                                    "If you requested this change, please consider this email as confirmation."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je deze wijziging niet hebt aangevraagd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                                english:
                                    "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
        .backgroundColor(.background.primary.reverse())

        return .init(
            from: business.fromEmail,
            to: [user],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}
