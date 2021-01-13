//
//  ValidationRuleError.swift
//  Chaos
//
//  Created by Fu Lam Diep on 20.11.20.
//

import Foundation

@objc public class ValidationRuleError: NSObject, CustomNSError {

    public let code: Code

    public let key: String

    public let previous: Error?

    public var errorCode: Int { code.rawValue }

    public init (code: Code, key: String, previous: Error? = nil) {
        self.code = code
        self.key = key
        self.previous = previous
    }
}


public extension ValidationRuleError {
    @objc enum Code: Int {
        case invalidValueType
        case invalidKey
        case childFailed
    }
}
