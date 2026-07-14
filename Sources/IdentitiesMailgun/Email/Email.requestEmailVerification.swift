//
//  Email.requestEmailVerification.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Email_HTML_Rendering
import Foundation
import HTML
import IdentitiesTypes
import Mailgun_Messages_Types
import ServerFoundation

extension Mailgun.Messages.Send.Request {
    public static func requestEmailVerification(
        verificationUrl: URL,
        business: BusinessDetails,
        to user: EmailAddress
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Verifieer je e-mailadres",
            english: "Verify your email address"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Verifiëer je emailadres voor \(business.name)",
                english: "Verify your email for \(business.name)"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Verifiëer je emailadres",
                                english: "Verify your email address"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Om de setup van je \(business.name) account te voltooien, bevestig alsjeblieft dat dit je e-mailadres is.",
                                english:
                                    "To continue setting up your \(business.name) account, please verify that this is your email address."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Link(href: .init(value: verificationUrl.absoluteString)) {
                            TranslatedString(
                                dutch: "Verifieer e-mailadres",
                                english: "Verify email address"
                            ).description
                        }
                        .color(.text.primary.reverse())
                        .padding(bottom: .medium)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Om veiligheidsredenen verloopt deze verificatielink binnen 24 uur.",
                                english:
                                    "This verification link will expire in 24 hours for security reasons."
                            ).description
                        }
                        .font(.footnote)
                        .color(.text.secondary)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je deze aanvraag niet hebt gedaan, kun je deze e-mail negeren.",
                                english:
                                    "If you did not make this request, please disregard this email."
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
            text: verificationUrl.absoluteString
        )
    }
}
