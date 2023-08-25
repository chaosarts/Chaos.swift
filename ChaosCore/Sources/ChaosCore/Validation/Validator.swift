//
//  Validator.swift
//  Chaos
//
//  Created by Fu Lam Diep on 20.11.20.
//

import Foundation

public class Validator {

    public let key: String

    public let required: Bool

    public let validationRule: ValidationRule

    public var message: String?

    public init (_ key: String, required: Bool = true, rule: ValidationRule) {
        self.key = key
        self.required = required
        self.validationRule = rule
    }
}
