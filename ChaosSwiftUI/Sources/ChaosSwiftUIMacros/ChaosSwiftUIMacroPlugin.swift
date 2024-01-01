//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ChaosSwiftUIMacroPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        EnvironmentValueMacro.self
    ]
}
