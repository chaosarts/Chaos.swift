//
//  Dictionary+default.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 03.02.21.
//

import Foundation

public extension Dictionary {

    /// "Convenient" method for `value = dict[key] ?? Value()`. 
    func value (forKey key: Key, _ fallback: @autoclosure () -> Value) -> Value {
        return self[key] ?? fallback()
    }

    /// Inserts the value resulting from the closure if there is none for the
    /// given key and returns either the created new value or the value in the
    /// dictionary if it exists.
    mutating func insertIfNotExists (_ work: @autoclosure () -> Value, forKey key: Key) -> Value {
        let value = self[key] ?? work()
        self[key] = value
        return value
    }
}
