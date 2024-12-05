//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public protocol RuleElement {
    associatedtype Body: RuleElement
    @RuleBuilder var body: Body { get }
}

extension RuleElement where Body == Never {
    public var body: Never {
        fatalError()
    }
}

extension Never: RuleElement {
    public typealias Body = Never
}

public struct EmptyRule: RuleElement {
    public typealias Body = Never
}

public struct TupleRule<T>: RuleElement {
    public typealias Body = Never

    public let value: T

    public init(value: T) {
        self.value = value
    }
}

public struct AND<Content>: RuleElement where Content: RuleElement {
    public let content: () -> Content

    public var body: some RuleElement {
        content()
    }
}

public struct OR<Content>: RuleElement where Content: RuleElement {
    public let content: () -> Content

    public var body: some RuleElement {
        content()
    }
}

public struct IS<Value>: RuleElement where Value: Equatable {
    public typealias Body = Never
    public let value: Value
}
