//
//  Array+func.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 18.04.21.
//

import Foundation

public extension Array {

    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    func zip<T> (_ other: [T]) -> [(Element, T)] {
        var result: [(Element, T)] = []
        for index in 0..<Swift.min(count, other.count) {
            result.append((self[index], other[index]))
        }
        return result
    }
}

public extension Array where Element: SignedNumeric {
    var sum: Element { reduce(0) { $0 + $1 } }
}
