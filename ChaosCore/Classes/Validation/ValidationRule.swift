//
//  ValidationRule.swift
//  Chaos
//
//  Created by Fu Lam Diep on 20.11.20.
//

import Foundation

/// Protocol for a validation rule used by a validator.
public protocol ValidationRule: class {
    func validate (key: String, in decoder: Decoder) -> Bool
}

public extension ValidationRule {

    static var email: ValidationRule {
        regex("^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$")!
    }

    static func and (_ rules: [ValidationRule]) -> AndRule {
        AndRule(children: rules)
    }

    static func and (_ rules: ValidationRule...) -> AndRule {
        and(rules)
    }

    static func or (_ rules: [ValidationRule]) -> OrRule {
        OrRule(children: rules)
    }

    static func or (_ rules: ValidationRule...) -> OrRule {
        or(rules)
    }

    static func not (_ rule: ValidationRule) -> NotRule {
        NotRule(rule)
    }

    static func xor (_ lhs: ValidationRule, _ rhs: ValidationRule) -> XorRule {
        XorRule(lhs, rhs)
    }

    static func regex (_ pattern: String, options: NSRegularExpression.Options = []) -> RegexRule? {
        RegexRule(pattern, options: options)
    }

    static func lt<C: Comparable> (_ value: C) -> ComparisonRule<C> {
        ComparisonRule(<, reference: value)
    }

    static func lteq<C: Comparable> (_ value: C) -> ComparisonRule<C> {
        ComparisonRule(<=, reference: value)
    }

    static func gt<C: Comparable> (_ value: C) -> ComparisonRule<C> {
        ComparisonRule(>, reference: value)
    }

    static func gteq<C: Comparable> (_ value: C) -> ComparisonRule<C> {
        ComparisonRule(>=, reference: value)
    }

    static func eq<C: Comparable> (_ value: C) -> ComparisonRule<C> {
        ComparisonRule(==, reference: value)
    }

    static func lt<C: Collection> (_ value: Int) -> CountRule<C> {
        CountRule(<, reference: value)
    }

    static func lteq<C: Collection> (_ value: Int) -> CountRule<C> {
        CountRule(<=, reference: value)
    }

    static func gt<C: Collection> (_ value: Int) -> CountRule<C> {
        CountRule(>, reference: value)
    }

    static func gteq<C: Collection> (_ value: Int) -> CountRule<C> {
        CountRule(>=, reference: value)
    }

    static func eq<C: Collection> (_ value: Int) -> CountRule<C> {
        CountRule(==, reference: value)
    }

    static func lt<Value: Comparable & Decodable> (_ type: Value.Type, key: String) -> ReferenceRule<Value> {
        ReferenceRule<Value>(<, foreignKey: key)
    }

    static func lteq<Value: Comparable & Decodable> (_ type: Value.Type, key: String) -> ReferenceRule<Value> {
        ReferenceRule(<=, foreignKey: key)
    }

    static func gt<Value: Comparable & Decodable> (_ type: Value.Type, key: String) -> ReferenceRule<Value> {
        ReferenceRule(>, foreignKey: key)
    }

    static func gteq<Value: Comparable & Decodable> (_ type: Value.Type, key: String) -> ReferenceRule<Value> {
        ReferenceRule(>=, foreignKey: key)
    }

    static func eq<Value: Comparable & Decodable> (_ type: Value.Type, key: String) -> ReferenceRule<Value> {
        ReferenceRule(==, foreignKey: key)
    }

    static func custom (_ validationBlock: @escaping CustomRule.ValidationBlock) -> CustomRule {
        CustomRule(validationBlock)
    }
}

// MARK: -

/**
 Class for validation rules, that validate through child rules. The class itself
 does not conform the `ValidationRule` protocol. It contains only logic for
 managing the child rules.
 */
public class RuleContainer: NSObject, ExpressibleByArrayLiteral {

    /// Provides the list of child rules to validate.
    public private(set) var children: [ValidationRule]

    // MARK: Initialization

    public init (children: [ValidationRule]) {
        self.children = children
    }

    public required convenience init(arrayLiteral elements: ValidationRule...) {
        self.init(children: elements)
    }

    public convenience init (_ children: ValidationRule...) {
        self.init(children: children)
    }
}


// MARK: -

/// Describes the requirement for a validation rule container, that validates
/// through child rules.
public typealias ValidationRuleContainer = RuleContainer & ValidationRule


// MARK: - Predefined Rule Classes

/// Rule container that requires all its children to validate to true.
public class AndRule: ValidationRuleContainer {
    public func validate(key: String, in decoder: Decoder) -> Bool {
        children.allSatisfy { $0.validate(key: key, in: decoder) }
    }
}

/// Rule container that satisfies when one child validates to true.
public class OrRule: ValidationRuleContainer {
    public func validate(key: String, in decoder: Decoder) -> Bool {
        children.contains(where: { $0.validate(key: key, in: decoder) })
    }
}

/// Rule that validates to true when exactly one of the two validation rules
/// passed to the initializers validates to true.
public class XorRule: NSObject, ValidationRule {

    /// The first subrule to validate
    private let lhs: ValidationRule

    /// The second subrule to validate
    private let rhs: ValidationRule

    public init (_ lhs: ValidationRule, _ rhs: ValidationRule) {
        self.lhs = lhs
        self.rhs = rhs
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        let lhsValidation = lhs.validate(key: key, in: decoder)
        let rhsValidation = rhs.validate(key: key, in: decoder)
        return lhsValidation && !rhsValidation || !lhsValidation && rhsValidation
    }
}

/// Class to negate a nested rule.
/// The rule validates to true, when the nested rule validates to false, otherwise
/// false.
public class NotRule: NSObject, ValidationRule {

    /// The nested rule to negate.
    private let child: ValidationRule

    public init (_ child: ValidationRule) {
        self.child = child
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        !child.validate(key: key, in: decoder)
    }
}


/// Class to validate a string against a regular expression.
public class RegexRule: NSObject, ValidationRule {

    /// The regular expression to use for the validation.
    private let regex: NSRegularExpression

    public init (regex: NSRegularExpression) {
        self.regex = regex
    }

    public convenience init? (_ pattern: String, options: NSRegularExpression.Options = []) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return nil }
        self.init(regex: regex)
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        do {
            let container = try decoder.container(keyedBy: String.self)
            let string = try container.decode(String.self, forKey: key)
            return regex.numberOfMatches(in: string, options: [], range: NSRange(0..<string.count)) > 0
        } catch {
            return false
        }
    }
}


/// A rule class that validates to true, when the value compare with a given
/// operator validates to true against a fixed value.
public class ComparisonRule<C: Comparable & Decodable>: NSObject, ValidationRule {

    /// Describes the signature of a comparator operation.
    public typealias Comparator = (C, C) -> Bool

    /// Provides the fixed value to compare against.
    private let reference: C

    /// Provides the comparator function to use to compare the values.
    private let comparator: Comparator

    public init (_ comparator: @escaping Comparator, reference: C) {
        self.reference = reference
        self.comparator = comparator
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        do {
            let container = try decoder.container(keyedBy: String.self)
            let value = try container.decode(C.self, forKey: key)
            return comparator(value, reference)
        } catch {
            return false
        }
    }
}


/// A class that validates the count of a collection object against a fixed value.
///
/// The fixed reference value is interpreted as the right hand side of the
/// comparison.
public class CountRule<C: Collection & Decodable>: NSObject, ValidationRule {

    /// The signature of the comparator function.
    public typealias Comparator = (Int, Int) -> Bool

    /// The reference value to compare the count of th collection against.
    private let reference: Int

    /// The comparator function to use to compare the fixed value and the count of
    /// the collection.
    private let comparator: Comparator


    public init (_ comparator: @escaping Comparator, reference: Int) {
        self.reference = reference
        self.comparator = comparator
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        do {
            let container = try decoder.container(keyedBy: String.self)
            let value = try container.decode(C.self, forKey: key)
            return comparator(value.count, reference)
        } catch {
            return false
        }
    }
}


/// A rule class to validate an incoming value against a value in the decoder
/// with fixed key.
public class ReferenceRule<Value: Comparable & Decodable>: ValidationRule {

    public typealias Comparator = (Value, Value) -> Bool

    private let foreignKey: String

    private let comparator: Comparator

    public init (_ comparator: @escaping Comparator, foreignKey: String) {
        self.comparator = comparator
        self.foreignKey = foreignKey
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        do {
            let container = try decoder.container(keyedBy: String.self)
            let value = try container.decode(Value.self, forKey: key)
            let foreignValue = try container.decode(Value.self, forKey: foreignKey)
            return comparator(value, foreignValue)
        } catch {
            return false
        }
    }
}


public class CustomRule: ValidationRule {

    public typealias ValidationBlock = (String, Decoder) -> Bool

    private let validationBlock: ValidationBlock

    public init (_ validationBlock: @escaping ValidationBlock) {
        self.validationBlock = validationBlock
    }

    public func validate(key: String, in decoder: Decoder) -> Bool {
        validationBlock(key, decoder)
    }
}
