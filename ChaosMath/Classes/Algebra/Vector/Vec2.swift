//
//  CMvec2.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 07.02.21.
//

import Foundation

public struct t_vec2<Component: CodableSignedNumeric>: StaticVector {

    public static var dimension: Int { 2 }

    public private(set) var components: [Component]

    public var x: Component {
        get { components[0] }
        set { components[0] = newValue }
    }

    public var y: Component {
        get { components[1] }
        set { components[1] = newValue }
    }

    public init (components: [Component]) {
        self.init()
        for index in 0..<min(dimension, components.count) {
            self.components[index] = components[index]
        }
    }

    public init<P>(from p1: P, to p2: P) where P : Point, Component == P.Component {
        self.init(components: p2.components)
        for index in 0..<min(dimension, p1.dimension) {
            self.components[index] -= p1.components[index]
        }
    }

    public init (_ x: Component = 0, _ y: Component = 0) {
        components = [x, y]
    }

    public init (from p1: t_point2<Component>, to p2: t_point2<Component>) {
        self.init(p2.components[0] - p1.components[0], p2.components[1] - p1.components[1])
    }

    public subscript(_ index: Int) -> Component {
        get { components[index] }
        set { components[index] = newValue }
    }

    public func dot(_ other: t_vec2<Component>) -> Component {
        components[0] * other.components[0] + components[1] * other.components[1]
    }

    public func normal (clockwise: Bool = true) -> Self {
        if clockwise {
            return t_vec2(y, -x)
        } else {
            return t_vec2(-y, x)
        }
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(lhs.components[0] + rhs.components[0], lhs.components[1] + rhs.components[1])
    }

    @inlinable public static prefix func - (_ vector: Self) -> Self {
        Self(-vector.components[0], -vector.components[1])
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Component) -> Self {
        Self(lhs.components[0] * rhs, lhs.components[1] * rhs)
    }
}

extension t_vec2: FloatingPointVector where Component: FloatingPoint {

}

extension t_vec2: StaticFloatingPointVector where Component: FloatingPoint {

}

public extension t_vec2 {
    static var zero: Self { t_vec2() }
}

public typealias Vec2f = t_vec2<Float>
public typealias Vec2d = t_vec2<Double>
public typealias Vec2 = Vec2f
