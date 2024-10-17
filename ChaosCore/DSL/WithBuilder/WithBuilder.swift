//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import Foundation

public struct Assignment<T> {

    private let block: (inout T) -> Void

    public init(block: @escaping (inout T) -> Void) {
        self.block = block
    }

    public func assign(to object: inout T) {
        block(&object)
    }
}

@resultBuilder
public enum WithBuilder<T> {
    public static func buildBlock(_ components: [Assignment<T>]...) -> [Assignment<T>] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[Assignment<T>]]) -> [Assignment<T>] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Assignment<T>]?) -> [Assignment<T>] {
        component ?? []
    }

    public static func buildEither(first component: [Assignment<T>]) -> [Assignment<T>] {
        component
    }

    public static func buildEither(second component: [Assignment<T>]) -> [Assignment<T>] {
        component
    }

    public static func buildExpression(_ expression: Assignment<T>) -> [Assignment<T>] {
        [expression]
    }
}

infix operator ~

public func ~<T, V>(_ keyPath: WritableKeyPath<T, V>, value: V) -> Assignment<T> {
    Assignment<T> {
        $0[keyPath: keyPath] = value
    }
}

@discardableResult
public func with<T>(_ object: T, @WithBuilder<T> work: () -> [Assignment<T>]) -> T {
    var object = object
    let assignments = work()
    assignments.forEach { a in
        a.assign(to: &object)
    }

    return object
}

public func with<T>(_ object: inout T, @WithBuilder<T> work: () -> [Assignment<T>]) {
    let assignments = work()
    assignments.forEach { a in
        a.assign(to: &object)
    }
}

