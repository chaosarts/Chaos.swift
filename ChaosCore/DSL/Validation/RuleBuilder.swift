//
//  File.swift
//  
//
//  Created by fu.lam.diep on 26.08.23.
//

import Foundation

@resultBuilder
struct RuleBuilder<Context> {
    static func buildBlock<R: Rule>(_ rule: R) -> R where R.Context == Context {
        rule
    }

    static func buildEither<R: Rule>(first rule: R) -> R {
        rule
    }

    static func buildEither<R: Rule>(second rule: R) -> R {
        rule
    }
}
