//
//  Copyright © 2023 Chaosarts. All rights reserved.
//

import Foundation
import SwiftSyntax
import SwiftDiagnostics

public struct DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {
    public let message: String

    public let diagnosticID: MessageID

    public let severity: DiagnosticSeverity

    internal init(message: String, diagnosticID: MessageID, severity: DiagnosticSeverity) {
        self.message = message
        self.diagnosticID = diagnosticID
        self.severity = severity
    }

    public init(_ message: String, id: String, severity: DiagnosticSeverity) {
        self.init(message: message, diagnosticID: MessageID(domain: "de.chaosarts", id: id), severity: severity)
    }

    public init<ID>(_ message: String, id: ID, severity: DiagnosticSeverity) 
    where ID: RawRepresentable, ID.RawValue == String {
        self.init(message, id: id.rawValue, severity: severity)
    }
}

extension DiagnosticMessage: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value, id: "error", severity: .error)
    }
}

extension SwiftDiagnostics.DiagnosticMessage where Self == DiagnosticMessage {
    public static func error(_ message: String, id: String = "error") -> Self {
        self.init(message, id: id, severity: .error)
    }

    public static func error<ID>(_ message: String, id: ID) -> Self
    where ID: RawRepresentable, ID.RawValue == String {
        error(message, id: id.rawValue)
    }

    public static func warning(_ message: String, id: String = "warning") -> Self {
        self.init(message, id: id, severity: .warning)
    }

    public static func warning<ID>(_ message: String, id: ID) -> Self
    where ID: RawRepresentable, ID.RawValue == String {
        warning(message, id: id.rawValue)
    }

    public static func note(_ message: String, id: String = "note") -> Self {
        self.init(message, id: id, severity: .note)
    }

    public static func note<ID>(_ message: String, id: ID) -> Self
    where ID: RawRepresentable, ID.RawValue == String {
        note(message, id: id.rawValue)
    }
}
