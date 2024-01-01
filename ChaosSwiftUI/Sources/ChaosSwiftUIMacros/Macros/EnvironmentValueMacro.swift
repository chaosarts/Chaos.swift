//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import ChaosCore
import ChaosMacroKit
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

struct EnvironmentValueMacro: Macro {}

extension EnvironmentValueMacro: AccessorMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some  MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            context.error("Macro can only be applied to variable declaration", node: node)
            return []
        }

        guard let binding = varDecl.bindings.first else {
            context.error("Binding must be a pattern binding.", node: node)
            return []
        }

        guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
            context.error("Pattern must be an identifier pattern", node: node)
            return []
        }

        let baseName = pattern.identifier.text.ucfirst()
        return [
            "get { self[\(raw: baseName)EnvironmentKey.self] }",
            "set { self[\(raw: baseName)EnvironmentKey.self] = newValue }"
        ]
    }
}

extension EnvironmentValueMacro: PeerMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            context.error("Macro can only be applied to variable declaration", node: node)
            return []
        }

        guard let binding = varDecl.bindings.first else {
            context.error("Binding must be a pattern binding.", node: node)
            return []
        }

        guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
            context.error("Pattern must be an identifier pattern", node: node)
            return []
        }

        guard let typeAnnotation = binding.typeAnnotation else {
            context.error("Macro does not support indirect type inference.", node: node)
            return []
        }

        guard let initializer = binding.initializer else {
            context.error("Binding must be an initialization.", node: node)
            return []
        }

        let baseName = pattern.identifier.text.ucfirst()

        return [
            """
struct \(raw: baseName)EnvironmentKey: EnvironmentKey {
    static var defaultValue: \(raw: typeAnnotation.type.description) { \(initializer.value) }
}
"""
        ]
    }
}
