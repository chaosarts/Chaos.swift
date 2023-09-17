//
//  File.swift
//  
//
//  Created by fu.lam.diep on 26.08.23.
//

import Foundation

public struct Validator<Context, R> where R: Rule {

    private let context: Context.Type

    private let rule: R

    public init(_ context: Context.Type, @RuleBuilder<Context> rule: @escaping () -> R) {
        self.context = context
        self.rule = rule()
    }
}

extension Validator where Context == Never {
    public init(@RuleBuilder<Never> rule: @escaping () -> R) {
        self.init(Never.self, rule: rule)
    }
}
