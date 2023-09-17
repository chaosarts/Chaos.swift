//
//  File.swift
//  
//
//  Created by fu.lam.diep on 01.09.23.
//

import Foundation

public struct IsEqual<Context, Value>: Rule where Value: Equatable {

    private let reference: Reference<Context, Value>

    internal init(to reference: Reference<Context, Value>) {
        self.reference = reference
    }

    public init(to keyPath: KeyPath<Context, Value>) {
        self.init(to: .keyPath(keyPath))
    }

    public func eval(_ value: Value, with context: Context) -> Bool {
        switch reference {
        case .keyPath(let keyPath):
            return value == context[keyPath: keyPath]
        case .value(let reference):
            return value == reference
        }
    }
}

extension IsEqual where Context == Never {
    public init(to value: Value) {
        self.init(to: .value(value))
    }
}
