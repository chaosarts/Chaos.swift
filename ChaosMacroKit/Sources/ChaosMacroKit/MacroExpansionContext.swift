//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension MacroExpansionContext {
    public func error(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) {
        diagnose(
            .error(
                message,
                node: node,
                position: position,
                highlights: highlights,
                notes: notes,
                fixIts: fixIts
            )
        )
    }

    public func warning(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) {
        diagnose(
            .warning(
                message,
                node: node,
                position: position,
                highlights: highlights,
                notes: notes,
                fixIts: fixIts
            )
        )
    }

    public func note(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) {
        diagnose(
            .note(
                message,
                node: node,
                position: position,
                highlights: highlights,
                notes: notes,
                fixIts: fixIts
            )
        )
    }
}
