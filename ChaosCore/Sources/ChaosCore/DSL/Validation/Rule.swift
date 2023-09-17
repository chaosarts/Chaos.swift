//
//  File.swift
//  
//
//  Created by fu.lam.diep on 26.08.23.
//

import Foundation

public protocol Rule<Context, Value> {
    associatedtype Value
    associatedtype Context
    func eval(_ value: Value, with context: Context) -> Bool
}

public enum Reference<Context, Value> {
    case keyPath(KeyPath<Context, Value>)
    case value(Value)
}
