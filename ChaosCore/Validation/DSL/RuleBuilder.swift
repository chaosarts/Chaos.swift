//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

@resultBuilder
public struct RuleBuilder {

    public static func buildBlock() -> EmptyRule {
        EmptyRule()
    }

    public static func buildExpression<R>(_ expression: R) -> R where R: RuleElement {
        expression
    }

    public static func buildBlock<each T>(_ component: repeat each T) -> TupleRule<(repeat each T)> {
        TupleRule(value: (repeat each component))
    }

    public static func buildPartialBlock<R>(first: R) -> R where R: RuleElement {
        first
    }

    public static func buildEither<R>(first component: R) -> R where R: RuleElement {
        component
    }

    public static func buildEither<R>(second component: R) -> R where R: RuleElement {
        component
    }
}
