//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftSyntax
import SwiftDiagnostics

extension Diagnostic {
    public static func error(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) -> Diagnostic {
        self.init(
            node: node,
            position: position,
            message: .error(message),
            highlights: highlights,
            notes: notes,
            fixIts: fixIts
        )
    }

    public static func warning(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) -> Diagnostic {
        self.init(
            node: node,
            position: position,
            message: .warning(message),
            highlights: highlights,
            notes: notes,
            fixIts: fixIts
        )
    }

    public static func note(
        _ message: String,
        node: SyntaxProtocol,
        position: AbsolutePosition? = nil,
        highlights: [Syntax]? = nil,
        notes: [Note] = [],
        fixIts: [FixIt] = []
    ) -> Diagnostic {
        self.init(
            node: node,
            position: position,
            message: .note(message),
            highlights: highlights,
            notes: notes,
            fixIts: fixIts
        )
    }
}
