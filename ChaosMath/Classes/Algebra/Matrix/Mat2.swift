//
//  Mat2.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 10.04.21.
//

import Foundation

public struct t_mat2<Component: CodableSignedNumeric>: StaticSquareMatrix {

    public typealias Component = Component

    public typealias TransposedMatrix = Self

    public typealias RowVector = t_vec2<Component>

    public typealias ColVector = RowVector

    public static var dimension: Int { 2 }

    public private(set) var components: [Component]

    public var transposed: Self {
        Self(components: [
            components[0], components[2],
            components[1], components[3]
        ])
    }

    public var determinant: Component {
        components[0] * components[3] - components[1] * components[2]
    }

    public init (components: [Component]) {
        self.init()
        for index in 0..<min(dimension, components.count) {
            self.components[index] = components[index]
        }
    }

    public init (a11: Component = 0, a12: Component = 0, a21: Component = 0, a22: Component = 0) {
        self.components = [a11, a12, a21, a22]
    }

    public func component(at index: Int) -> Component {
        components[index]
    }

    public mutating func setComponent(_ component: Component, at index: Int) -> Self {
        components[index] = component
        return self
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        t_mat2(components: [
            lhs.components[0] + rhs.components[0], lhs.components[1] + rhs.components[1],
            lhs.components[2] + rhs.components[2], lhs.components[3] + rhs.components[3]
        ])
    }

    @inlinable public static prefix func - (_ mat: Self) -> Self {
        t_mat2(components: [
            -mat.components[0], -mat.components[1],
            -mat.components[2], -mat.components[3]
        ])
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Component) -> Self {
        t_mat2(components: [
            lhs.components[0] * rhs, lhs.components[1] * rhs,
            lhs.components[2] * rhs, lhs.components[3] * rhs
        ])
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Self) -> Self {
        t_mat2(
            a11: lhs.components[0] * rhs.components[0] + lhs.components[1] * rhs.components[2],
            a12: lhs.components[0] * rhs.components[1] + lhs.components[1] * rhs.components[3],
            a21: lhs.components[2] * rhs.components[0] + lhs.components[3] * rhs.components[2],
            a22: lhs.components[2] * rhs.components[1] + lhs.components[3] * rhs.components[3]
        )
    }
}

extension t_mat2: FloatingPointMatrix where Component: FloatingPoint {

}

extension t_mat2: StaticFloatingPointMatrix where Component: FloatingPoint {

}

public typealias Mat2f = t_mat2<Float>
public typealias Mat2d = t_mat2<Double>
public typealias Mat2i = t_mat2<Int>
public typealias Mat2 = Mat2f
