//
//  Mat3.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 09.04.21.
//

import Foundation

public struct t_mat3<Component: SignedNumeric>: StaticSquareMatrix {

    public typealias TransposedMatrix = Self

    public typealias RowVector = t_vec3<Component>

    public typealias ColVector = RowVector

    public static var dimension: Int { 3 }

    public static var shape: Shape { (3, 3) }

    public var components: [Component]

    public var transposed: Self {
        Self(
            a11: components[0], a12: components[3], a13: components[6],
            a21: components[1], a22: components[4], a23: components[7],
            a31: components[2], a32: components[5], a33: components[8]
        )
    }

    public var determinant: Component {
        let a = components[0] * components[4] * components[8]
        let b = components[1] * components[5] * components[6]
        let c = components[2] * components[3] * components[7]

        let d = components[0] * components[5] * components[7]
        let e = components[1] * components[3] * components[8]
        let f = components[2] * components[4] * components[6]
        return a + b + c - d - e - f
    }

    public init (components: [Component]) {
        self.init()
        for index in 0..<min(dimension, components.count) {
            self.components[index] = components[index]
        }
    }

    public init (
        a11: Component = 0, a12: Component = 0, a13: Component = 0,
        a21: Component = 0, a22: Component = 0, a23: Component = 0,
        a31: Component = 0, a32: Component = 0, a33: Component = 0
    ) {
        self.components = [
            a11, a12, a13,
            a21, a22, a23,
            a31, a32, a33
        ]
    }

    public func component(at index: Int) -> Component {
        components[index]
    }

    public mutating func setComponent(_ component: Component, at index: Int) -> t_mat3<Component> {
        components[index] = component
        return self
    }

    public func submatrix (row: Int, col: Int) -> t_mat2<Component> {
        var components: [Component] = []
        for r in 0..<dimension {
            if r == row { continue }
            for c in 0..<dimension {
                if c == col { continue }
                components.append(self[r, c])
            }
        }

        return t_mat2<Component>(components: components)
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        t_mat3(
            a11: lhs.components[0] + rhs.components[0],
            a12: lhs.components[1] + rhs.components[1],
            a13: lhs.components[2] + rhs.components[2],

            a21: lhs.components[3] + rhs.components[3],
            a22: lhs.components[4] + rhs.components[4],
            a23: lhs.components[5] + rhs.components[5],

            a31: lhs.components[6] + rhs.components[6],
            a32: lhs.components[7] + rhs.components[7],
            a33: lhs.components[8] + rhs.components[8]
        )
    }

    @inlinable public static prefix func - (_ mat: Self) -> Self {
        t_mat3(
            a11: -mat.components[0], a12: -mat.components[1], a13: -mat.components[2],
            a21: -mat.components[3], a22: -mat.components[4], a23: -mat.components[5],
            a31: -mat.components[6], a32: -mat.components[7], a33: -mat.components[8]
        )
    }

    @inlinable public static func * (_ lhs: Self, rhs: Component) -> Self {
        t_mat3(
            a11: lhs.components[0] * rhs, a12: lhs.components[1] * rhs, a13: lhs.components[2] * rhs,
            a21: lhs.components[3] * rhs, a22: lhs.components[4] * rhs, a23: lhs.components[5] * rhs,
            a31: lhs.components[6] * rhs, a32: lhs.components[7] * rhs, a33: lhs.components[8] * rhs
        )
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Self) -> Self {
        let a11_1 = lhs.components[0] * rhs.components[0]
        let a11_2 = lhs.components[1] * rhs.components[3]
        let a11_3 = lhs.components[2] * rhs.components[6]

        let a12_1 = lhs.components[0] * rhs.components[1]
        let a12_2 = lhs.components[1] * rhs.components[4]
        let a12_3 = lhs.components[2] * rhs.components[7]

        let a13_1 = lhs.components[0] * rhs.components[2]
        let a13_2 = lhs.components[1] * rhs.components[5]
        let a13_3 = lhs.components[2] * rhs.components[8]

        let a21_1 = lhs.components[3] * rhs.components[0]
        let a21_2 = lhs.components[4] * rhs.components[3]
        let a21_3 = lhs.components[5] * rhs.components[6]

        let a22_1 = lhs.components[3] * rhs.components[1]
        let a22_2 = lhs.components[4] * rhs.components[4]
        let a22_3 = lhs.components[5] * rhs.components[7]

        let a23_1 = lhs.components[3] * rhs.components[2]
        let a23_2 = lhs.components[4] * rhs.components[5]
        let a23_3 = lhs.components[5] * rhs.components[8]

        let a31_1 = lhs.components[6] * rhs.components[0]
        let a31_2 = lhs.components[7] * rhs.components[3]
        let a31_3 = lhs.components[8] * rhs.components[6]

        let a32_1 = lhs.components[6] * rhs.components[1]
        let a32_2 = lhs.components[7] * rhs.components[4]
        let a32_3 = lhs.components[8] * rhs.components[7]

        let a33_1 = lhs.components[6] * rhs.components[2]
        let a33_2 = lhs.components[7] * rhs.components[5]
        let a33_3 = lhs.components[8] * rhs.components[8]

        return Self(
            a11: a11_1 + a11_2 + a11_3,
            a12: a12_1 + a12_2 + a12_3,
            a13: a13_1 + a13_2 + a13_3,
            a21: a21_1 + a21_2 + a21_3,
            a22: a22_1 + a22_2 + a22_3,
            a23: a23_1 + a23_2 + a23_3,
            a31: a31_1 + a31_2 + a31_3,
            a32: a32_1 + a32_2 + a32_3,
            a33: a33_1 + a33_2 + a33_3
        )
    }
}

extension t_mat3: FloatingPointMatrix where Component: FloatingPoint {

}

extension t_mat3: StaticFloatingPointMatrix where Component: FloatingPoint {

}

public typealias Mat3f = t_mat3<Float>
public typealias Mat3d = t_mat3<Double>
public typealias Mat3i = t_mat3<Int>
public typealias Mat3 = Mat3f
