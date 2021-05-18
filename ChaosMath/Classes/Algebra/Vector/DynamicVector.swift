//
//  Vec.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 14.04.21.
//

import Foundation

/// A `Vector` implementation for vectors of dynamic dimension.
public struct t_dynamic_vector<Component: SignedNumeric>: Vector {

    public private(set) var components: [Component]

    public init(components: [Component] = []) {
        self.components = components
    }

    public init<P>(from p1: P, to p2: P) where P : Point, Component == P.Component {
        self.init(dimension: max(p1.dimension, p2.dimension), components: p2.components)
        for index in 0..<min(dimension, p1.dimension) {
            self.components[index] -= p1.components[index]
        }
    }

    public init(dimension: Int, components: [Component]) {
        var list = components
        if list.count < dimension {
            list.append(contentsOf: Array(repeating: 0, count: dimension - list.count))
        }
        self.init(components: Array(list[0..<dimension]))
    }

    public init (fill component: Component, of dimension: Int) {
        self.init(components: Array(repeating: component, count: dimension))
    }

    public subscript(index: Int) -> Component {
        get { components[index] }
        set { components[index] = newValue }
    }

    public func dot(_ other: Self) -> Component {
        var result: Component = 0
        for index in 0..<min(dimension, other.dimension) {
            result += components[index] * other.components[index]
        }
        return result
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        let minComponents: [Component]
        var maxComponents: [Component]

        if lhs.dimension > rhs.dimension {
            minComponents = rhs.components
            maxComponents = lhs.components
        } else {
            minComponents = lhs.components
            maxComponents = rhs.components
        }

        for index in 0..<minComponents.count {
            maxComponents[index] += minComponents[index]
        }
        return Self(components: maxComponents)
    }

    @inlinable public static prefix func - (_ vector: Self) -> Self {
        Self(components: vector.components.map({ -$0 }))
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Component) -> Self {
        Self(components: lhs.components.map({ $0 * rhs }))
    }
}

extension t_dynamic_vector: FloatingPointVector where Component: FloatingPoint {

}

public typealias DynamicVector = t_dynamic_vector<Float>
