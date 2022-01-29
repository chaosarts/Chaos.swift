//
//  CMvec4.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 07.04.21.
//

import Foundation

public struct t_vec4<Component: SignedNumeric>: StaticVector {

    public static var dimension: Int { 4 }

    public private(set) var components: [Component]

    public var x: Component { components[0] }

    public var y: Component { components[1] }

    public var z: Component { components[2] }

    public var w: Component { components[3] }

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

    public init (_ x: Component = 0, _ y: Component = 0, _ z: Component = 0, _ w: Component = 0) {
        components = [x, y, z, w]
    }

    public init (from p1: t_point4<Component>, to p2: t_point4<Component>) {
        self.init(
            p2.components[0] - p1.components[0],
            p2.components[1] - p1.components[1],
            p2.components[2] - p1.components[2],
            p2.components[3] - p1.components[3]
        )
    }

    public subscript(_ index: Int) -> Component {
        get { components[index] }
        set { components[index] = newValue }
    }

    public func dot(_ other: t_vec4<Component>) -> Component {
        let a = components[0] * other.components[0]
        let b = components[1] * other.components[1]
        let c = components[2] * other.components[2]
        let d = components[3] * other.components[3]
        return a + b + c + d
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(
            lhs.components[0] + rhs.components[0],
            lhs.components[1] + rhs.components[1],
            lhs.components[2] + rhs.components[2],
            lhs.components[3] + rhs.components[3]
        )
    }

    @inlinable public static prefix func - (_ vector: Self) -> Self {
        Self(
            -vector.components[0],
            -vector.components[1],
            -vector.components[2],
            -vector.components[3]
        )
    }

    @inlinable public static func * (_ vector: Self, _ scalar: Component) -> Self {
        Self(
            vector.components[0] * scalar,
            vector.components[1] * scalar,
            vector.components[2] * scalar,
            vector.components[3] * scalar
        )
    }
}

extension t_vec4: FloatingPointVector where Component: FloatingPoint {
    
}

extension t_vec4: StaticFloatingPointVector where Component: FloatingPoint {
    
}

public extension t_vec4 {
    static var zero: Self { t_vec4() }
}

public typealias Vec4f = t_vec4<Float>
public typealias Vec4d = t_vec4<Double>
public typealias Vec4 = Vec4f
