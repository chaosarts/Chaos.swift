//
//  File.swift
//  
//
//  Created by fu.lam.diep on 19.09.23.
//

import SwiftDiagnostics
import SwiftSyntax

public struct ChaosDiagnosticMessage: DiagnosticMessage {
    /// The diagnostic message that should be displayed in the client.
    public let message: String

    /// See ``MessageID``.
    public let diagnosticID: MessageID

    public let severity: DiagnosticSeverity

    public init(message: String, id: String, severity: DiagnosticSeverity) {
        self.message = message
        self.diagnosticID = MessageID(domain: "ChaosCore", id: id)
        self.severity = severity
    }
}

extension DiagnosticMessage where Self == ChaosDiagnosticMessage {
    public static func error(_ message: String, id: String) -> Self {
        Self.init(message: message, id: id, severity: .error)
    }

    public static func warning(_ message: String, id: String) -> Self {
        Self.init(message: message, id: id, severity: .warning)
    }

    public static func note(_ message: String, id: String) -> Self {
        Self.init(message: message, id: id, severity: .note)
    }
}
