//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public protocol Rule<Value> {
    associatedtype Value
    func accepts(_ value: Value!) async -> Bool
}

public struct AnyRule: Rule {
    public typealias Value = Any

    public func accepts(_ value: Value!) -> Bool {
        true
    }
}


extension Rule where Self == AnyRule {
    public static func pattern<Output>(_ regex: Regex<Output>) -> some Rule {
        PatternRule(regex: regex)
    }

    public static func comparison<Value>(to value: Value, with operator: @escaping (Value, Value) -> Bool) -> some Rule
    where Value: Comparable {
        ComparisonRule(value: value, operator: `operator`)
    }

    public static func containment<Value, Data>(_ data: Data) -> some Rule
    where Data: RandomAccessCollection, Data.Element == Value, Value: Equatable {
        CollectionContainmentRule(data: data)
    }

    public static func containment<Value, Range>(_ range: Range) -> some Rule
    where Range: RangeExpression, Range.Bound == Value, Value: Comparable {
        RangeContainmentRule(range: range)
    }

    public static func inline<Value>(_ rule: @escaping (Value) -> Bool) -> some Rule {
        InlineRule(callback: rule)
    }

    public static func `required`<Value>(_ type: Value.Type) -> some Rule {
        InlineRule<Value?> {
            $0 != nil
        }
    }
}

struct PatternRule<Output>: Rule {

    typealias Value = String

    let regex: Regex<Output>

    func accepts(_ value: Value!) -> Bool {
        (try? regex.wholeMatch(in: String(value))) != nil
    }
}

struct ComparisonRule<Value>: Rule where Value: Comparable {

    let value: Value

    let `operator`: (Value, Value) -> Bool

    func accepts(_ value: Value!) -> Bool {
        `operator`(self.value, value)
    }
}

struct CollectionContainmentRule<Value, Data>: Rule where Data: RandomAccessCollection, Data.Element == Value, Value: Equatable {

    let data: Data

    func accepts(_ value: Value!) -> Bool {
        data.contains(value)
    }
}

struct RangeContainmentRule<Value, Range>: Rule where Range: RangeExpression, Range.Bound == Value {

    let range: Range

    func accepts(_ value: Value!) -> Bool {
        range.contains(value)
    }
}

struct InlineRule<Value>: Rule {
    let callback: (Value) -> Bool

    func accepts(_ value: Value!) -> Bool {
        callback(value)
    }
}
