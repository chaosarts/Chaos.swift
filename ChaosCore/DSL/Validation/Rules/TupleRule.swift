//
//  File.swift
//  
//
//  Created by fu.lam.diep on 01.09.23.
//
import Foundation

public struct TupleRule<Context, Value, T>: Rule {
    public func eval(_ value: Value, with context: Context) -> Bool {
        true
    }
}

extension TupleRule {
    internal init<each R: Rule>(_ rules: (repeat each R)) where T == (repeat each R) {

    }
}
