//
//  DeletionEmails.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Email_HTML_Rendering
import Foundation
import HTML
import IdentitiesTypes
// Normalized from `Mailgun_Messages` (the Live-re-exporting module) to
// `Mailgun_Messages_Types` on 2026-07-14: this file only names
// `Mailgun.Messages.Send.Request`, a Types-layer type, exactly as the other
// three templates do. The old import dragged the Live closure into a
// Types-only file.
import Mailgun_Messages_Types
import ServerFoundation

// MARK: - Deletion Request Notification

extension Mailgun.Messages.Send.Request {
    public static func deletionRequestNotification(
        email: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Belangrijk: Verzoek tot accountverwijdering ontvangen",
            english: "Important: Account Deletion Request Received"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch:
                    "Er is een verzoek ingediend om je \(business.name) account te verwijderen",
                english: "A request has been made to delete your \(business.name) account"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Verzoek tot accountverwijdering ontvangen",
                                english: "Account Deletion Request Received"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We hebben een verzoek ontvangen om je \(business.name) account permanent te verwijderen. Dit verzoek wordt binnen 30 dagen verwerkt.",
                                english:
                                    "We received a request to permanently delete your \(business.name) account. This request will be processed within 30 days."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Let op: Deze actie kan niet ongedaan worden gemaakt. Alle accountgegevens, instellingen en bijbehorende informatie zullen permanent worden verwijderd.",
                                english:
                                    "Please note: This action cannot be undone. All account data, settings, and associated information will be permanently deleted."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)
                        .color(.text.warning)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Als je dit verzoek hebt gedaan, hoef je verder niets te doen. Je ontvangt een bevestiging zodra je account is verwijderd.",
                                english:
                                    "If you made this request, no further action is needed. You will receive a confirmation once your account has been deleted."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je dit verzoek niet hebt gedaan of als je van gedachten bent veranderd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om het verwijderingsproces te stoppen.",
                                english:
                                    "If you didn't request this or if you've changed your mind, please contact us immediately at \(business.supportEmail) to stop the deletion process."
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
            to: [email],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}

// MARK: - Deletion Confirmation Notification

extension Mailgun.Messages.Send.Request {
    public static func deletionConfirmationNotification(
        email: EmailAddress,
        business: BusinessDetails
    ) throws(HTML.Context.Configuration.Error) -> Self {
        let subject = TranslatedString(
            dutch: "Je account is verwijderd",
            english: "Your account has been deleted"
        )

        let document = Email.Document(
            preheader: TranslatedString(
                dutch: "Je \(business.name) account is permanent verwijderd",
                english: "Your \(business.name) account has been permanently deleted"
            ).description
        ) {
            tr {
                td {
                    Email.VStack(alignment: .start) {
                        Email.Header(3) {
                            TranslatedString(
                                dutch: "Je account is verwijderd",
                                english: "Your account has been deleted"
                            ).description
                        }

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We bevestigen dat je \(business.name) account en alle bijbehorende gegevens permanent zijn verwijderd volgens je verzoek.",
                                english:
                                    "We confirm that your \(business.name) account and all associated data have been permanently deleted as requested."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "Alle persoonlijke informatie, instellingen en accountgegevens zijn verwijderd uit onze systemen.",
                                english:
                                    "All personal information, settings, and account data have been removed from our systems."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph {
                            TranslatedString(
                                dutch:
                                    "We vinden het jammer je te zien gaan. Als je in de toekomst weer gebruik wilt maken van \(business.name), ben je altijd welkom om een nieuw account aan te maken.",
                                english:
                                    "We're sorry to see you go. If you'd like to use \(business.name) again in the future, you're always welcome to create a new account."
                            ).description
                        }
                        .padding(bottom: .extraSmall)
                        .font(.body)

                        Email.Paragraph(.small) {
                            TranslatedString(
                                dutch:
                                    "Als je vragen hebt of als je dit verzoek niet hebt gedaan, neem dan contact op met ons via \(business.supportEmail).",
                                english:
                                    "If you have any questions or if you didn't make this request, please contact us at \(business.supportEmail)."
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
            to: [email],
            subject: "\(business.name) | \(subject)",
            html: try String(document, configuration: .email),
            text: nil
        )
    }
}
