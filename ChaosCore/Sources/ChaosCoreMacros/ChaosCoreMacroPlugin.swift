//
//  File.swift
//  
//
//  Created by fu.lam.diep on 17.09.23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ChaosCoreMacroPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        StringifyMacro.self
    ]
}
