//
//  EmailChangeEmails.swift
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

// MARK: - Email Change Request Notification

extension Mailgun.Messages.Send.Request {
    public static func emailChangeRequestNotification(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Belangrijk: Verzoek tot e-mailwijziging ontvangen",
            english: "Important: Email Change Request Received"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch:
                    "Er is een verzoek ingediend om je e-mailadres te wijzigen voor \(business.name)",
                english:
                    "A request has been made to change your email address for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Verzoek tot e-mailwijziging ontvangen",
                                english: "Email Change Request Received"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We hebben een verzoek ontvangen om het e-mailadres voor je \(business.name) account te wijzigen van \(currentEmail) naar \(newEmail).",
                                english:
                                    "We received a request to change the email address for your \(business.name) account from \(currentEmail) to \(newEmail)."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Als je dit verzoek hebt gedaan, hoef je verder niets te doen. De wijziging wordt binnenkort doorgevoerd.",
                                english:
                                    "If you made this request, no further action is needed. The change will be processed shortly."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je dit verzoek niet hebt gedaan, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
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
            to: [currentEmail],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Email Change Confirmation Request

extension Mailgun.Messages.Send.Request {
    public static func emailChangeConfirmationRequest(
        verificationURL: URL,
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Verifieer je e-mailadres",
            english: "Verify your email address"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Verifieer je nieuwe e-mailadres voor \(business.name)",
                english: "Verify your new email address for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Verifieer je nieuwe e-mailadres",
                                english: "Verify your new email address"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We hebben een verzoek ontvangen om het e-mailadres voor je \(business.name) account te wijzigen. Klik op de onderstaande knop om je nieuwe e-mailadres te verifiëren.",
                                english:
                                    "We received a request to change the email address for your \(business.name) account. Click the button below to verify your new email address."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Link(href: .init(value: verificationURL.absoluteString)) {
                            TranslatedString(
                                dutch: "Verifieer e-mailadres",
                                english: "Verify email address"
                            ).description
                        }
                        .color(.text.primary.reverse())
                        .padding(bottom: .medium)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch: "Deze link verloopt binnen 1 uur om veiligheidsredenen.",
                                english: "This link will expire in 1 hour for security reasons."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je geen wijziging van je e-mailadres hebt aangevraagd, kun je deze e-mail negeren.",
                                english:
                                    "If you didn't request an email address change, you can ignore this email."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Voor hulp, neem contact op met ons via \(business.supportEmail).",
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
            to: [newEmail],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Email Change Success Notification (to old email)

extension Mailgun.Messages.Send.Request {
    public static func emailChangeSuccessToOldEmail(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Belangrijk: Je e-mailadres is gewijzigd",
            english: "Important: Your email address has been changed"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Je e-mailadres voor \(business.name) is gewijzigd",
                english: "Your email address for \(business.name) has been changed"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Je e-mailadres is gewijzigd",
                                english: "Your email address has been changed"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We willen je informeren dat het e-mailadres voor je \(business.name) account is gewijzigd van \(currentEmail.rawValue) naar \(newEmail.rawValue).",
                                english:
                                    "We're informing you that the email address for your \(business.name) account has been changed from \(currentEmail.rawValue) to \(newEmail.rawValue)."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Als je deze wijziging hebt aangevraagd, kun je deze e-mail als bevestiging beschouwen. Je kunt nu inloggen met je nieuwe e-mailadres.",
                                english:
                                    "If you requested this change, please consider this email as confirmation. You can now log in using your new email address."
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
            to: [currentEmail],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Email Change Success Notification (to new email)

extension Mailgun.Messages.Send.Request {
    public static func emailChangeSuccessToNewEmail(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Je nieuwe e-mailadres is bevestigd",
            english: "Your new email address is confirmed"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Je nieuwe e-mailadres voor \(business.name) is bevestigd",
                english: "Your new email address for \(business.name) is confirmed"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Je nieuwe e-mailadres is bevestigd",
                                english: "Your new email address is confirmed"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Welkom! We bevestigen dat dit e-mailadres (\(newEmail.rawValue)) nu is gekoppeld aan je \(business.name) account. Je vorige e-mailadres was \(currentEmail.rawValue).",
                                english:
                                    "Welcome! We confirm that this email address (\(newEmail.rawValue)) is now associated with your \(business.name) account. Your previous email address was \(currentEmail.rawValue)."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Je kunt nu inloggen op je account met dit nieuwe e-mailadres. Al je accountgegevens en voorkeuren blijven ongewijzigd.",
                                english:
                                    "You can now log in to your account using this new email address. All your account details and preferences remain unchanged."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je deze wijziging niet hebt aangevraagd of als je vragen hebt, neem dan contact op met ons via \(business.supportEmail).",
                                english:
                                    "If you didn't request this change or if you have any questions, please contact us at \(business.supportEmail)."
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
            to: [newEmail],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}
