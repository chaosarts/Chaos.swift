//
//  Mat4.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 08.04.21.
//

import Foundation

public struct t_mat4<Component: CodableSignedNumeric>: StaticSquareMatrix {

    public typealias Component = Component

    public typealias TransposedMatrix = t_mat4<Component>

    public typealias RowVector = t_vec4<Component>

    public typealias ColVector = RowVector

    public private(set) var components: [Component]

    public static var shape: Shape { Shape(rows: dimension, columns: dimension) }

    public static var dimension: Int { 4 }

    public var shape: Shape { Self.shape }

    public var dimension: Int { Self.dimension }

    public var transposed: Self {
        Self(
            a11: components[0], a12: components[4], a13: components[8], a14: components[12],
            a21: components[1], a22: components[5], a23: components[9], a24: components[13],
            a31: components[2], a32: components[6], a33: components[10], a34: components[14],
            a41: components[3], a42: components[7], a43: components[11], a44: components[15]
        )
    }

    public var determinant: Component {
        let a = components[0] * submatrix(row: 0, col: 0).determinant
        let b = components[4] * submatrix(row: 1, col: 0).determinant
        let c = components[8] * submatrix(row: 2, col: 0).determinant
        let d = components[12] * submatrix(row: 3, col: 0).determinant
        return a - b + c - d
    }

    public init (components: [Component]) {
        self.init()
        for index in 0..<min(components.count, self.components.count) {
            self.components[index] = components[index]
        }
    }

    public init (
        a11: Component = 0, a12: Component = 0, a13: Component = 0, a14: Component = 0,
        a21: Component = 0, a22: Component = 0, a23: Component = 0, a24: Component = 0,
        a31: Component = 0, a32: Component = 0, a33: Component = 0, a34: Component = 0,
        a41: Component = 0, a42: Component = 0, a43: Component = 0, a44: Component = 0
    ) {
        self.components = [
            a11, a12, a13, a14,
            a21, a22, a23, a24,
            a31, a32, a33, a34,
            a41, a42, a43, a44
        ]
    }

    public func component(at index: Int) -> Component {
        components[index]
    }

    public mutating func setComponent(_ component: Component, at index: Int) -> t_mat4<Component> {
        components[index] = component
        return self
    }

    public func submatrix (row: Int, col: Int) -> t_mat3<Component> {
        var components: [Component] = []
        for r in 0..<dimension {
            if r == row { continue }
            for c in 0..<dimension {
                if c == col { continue }
                components.append(self[r, c])
            }
        }

        return t_mat3<Component>(components: components)
    }

    @inlinable public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(
            a11: lhs.components[0] + rhs.components[0],
            a12: lhs.components[1] + rhs.components[1],
            a13: lhs.components[2] + rhs.components[2],
            a14: lhs.components[3] + rhs.components[3],

            a21: lhs.components[4] + rhs.components[4],
            a22: lhs.components[5] + rhs.components[5],
            a23: lhs.components[6] + rhs.components[6],
            a24: lhs.components[7] + rhs.components[7],

            a31: lhs.components[8] + rhs.components[8],
            a32: lhs.components[9] + rhs.components[9],
            a33: lhs.components[10] + rhs.components[10],
            a34: lhs.components[11] + rhs.components[11],

            a41: lhs.components[12] + rhs.components[12],
            a42: lhs.components[13] + rhs.components[13],
            a43: lhs.components[14] + rhs.components[14],
            a44: lhs.components[15] + rhs.components[15]
        )
    }


    @inlinable public static prefix func - (_ matrix: Self) -> Self {
        Self(
            a11: -matrix.components[0],
            a12: -matrix.components[1],
            a13: -matrix.components[2],
            a14: -matrix.components[3],

            a21: -matrix.components[4],
            a22: -matrix.components[5],
            a23: -matrix.components[6],
            a24: -matrix.components[7],

            a31: -matrix.components[8],
            a32: -matrix.components[9],
            a33: -matrix.components[10],
            a34: -matrix.components[11],

            a41: -matrix.components[12],
            a42: -matrix.components[13],
            a43: -matrix.components[14],
            a44: -matrix.components[15]
        )
    }

    @inlinable public static func * (_ matrix: Self, _ scalar: Component) -> Self {
        Self(
            a11: matrix.components[0] * scalar,
            a12: matrix.components[1] * scalar,
            a13: matrix.components[2] * scalar,
            a14: matrix.components[3] * scalar,

            a21: matrix.components[4] * scalar,
            a22: matrix.components[5] * scalar,
            a23: matrix.components[6] * scalar,
            a24: matrix.components[7] * scalar,

            a31: matrix.components[8] * scalar,
            a32: matrix.components[9] * scalar,
            a33: matrix.components[10] * scalar,
            a34: matrix.components[11] * scalar,

            a41: matrix.components[12] * scalar,
            a42: matrix.components[13] * scalar,
            a43: matrix.components[14] * scalar,
            a44: matrix.components[15] * scalar
        )
    }

    @inlinable public static func * (_ lhs: Self, _ rhs: Self) -> Self {
        let a11_1 = lhs.components[0] * rhs.components[0]
        let a11_2 = lhs.components[1] * rhs.components[4]
        let a11_3 = lhs.components[2] * rhs.components[8]
        let a11_4 = lhs.components[3] * rhs.components[12]

        let a12_1 = lhs.components[0] * rhs.components[1]
        let a12_2 = lhs.components[1] * rhs.components[5]
        let a12_3 = lhs.components[2] * rhs.components[9]
        let a12_4 = lhs.components[3] * rhs.components[13]

        let a13_1 = lhs.components[0] * rhs.components[2]
        let a13_2 = lhs.components[1] * rhs.components[6]
        let a13_3 = lhs.components[2] * rhs.components[10]
        let a13_4 = lhs.components[3] * rhs.components[14]

        let a14_1 = lhs.components[0] * rhs.components[3]
        let a14_2 = lhs.components[1] * rhs.components[7]
        let a14_3 = lhs.components[2] * rhs.components[11]
        let a14_4 = lhs.components[3] * rhs.components[15]

        let a21_1 = lhs.components[4] * rhs.components[0]
        let a21_2 = lhs.components[5] * rhs.components[4]
        let a21_3 = lhs.components[6] * rhs.components[8]
        let a21_4 = lhs.components[7] * rhs.components[12]

        let a22_1 = lhs.components[4] * rhs.components[1]
        let a22_2 = lhs.components[5] * rhs.components[5]
        let a22_3 = lhs.components[6] * rhs.components[9]
        let a22_4 = lhs.components[7] * rhs.components[13]

        let a23_1 = lhs.components[4] * rhs.components[2]
        let a23_2 = lhs.components[5] * rhs.components[6]
        let a23_3 = lhs.components[6] * rhs.components[10]
        let a23_4 = lhs.components[7] * rhs.components[14]

        let a24_1 = lhs.components[4] * rhs.components[3]
        let a24_2 = lhs.components[5] * rhs.components[7]
        let a24_3 = lhs.components[6] * rhs.components[11]
        let a24_4 = lhs.components[7] * rhs.components[15]

        let a31_1 = lhs.components[8] * rhs.components[0]
        let a31_2 = lhs.components[9] * rhs.components[4]
        let a31_3 = lhs.components[10] * rhs.components[8]
        let a31_4 = lhs.components[11] * rhs.components[12]

        let a32_1 = lhs.components[8] * rhs.components[1]
        let a32_2 = lhs.components[9] * rhs.components[5]
        let a32_3 = lhs.components[10] * rhs.components[9]
        let a32_4 = lhs.components[11] * rhs.components[13]

        let a33_1 = lhs.components[8] * rhs.components[2]
        let a33_2 = lhs.components[9] * rhs.components[6]
        let a33_3 = lhs.components[10] * rhs.components[10]
        let a33_4 = lhs.components[11] * rhs.components[14]

        let a34_1 = lhs.components[8] * rhs.components[3]
        let a34_2 = lhs.components[9] * rhs.components[7]
        let a34_3 = lhs.components[10] * rhs.components[11]
        let a34_4 = lhs.components[11] * rhs.components[15]

        let a41_1 = lhs.components[12] * rhs.components[0]
        let a41_2 = lhs.components[13] * rhs.components[4]
        let a41_3 = lhs.components[14] * rhs.components[8]
        let a41_4 = lhs.components[15] * rhs.components[12]

        let a42_1 = lhs.components[12] * rhs.components[1]
        let a42_2 = lhs.components[13] * rhs.components[5]
        let a42_3 = lhs.components[14] * rhs.components[9]
        let a42_4 = lhs.components[15] * rhs.components[13]

        let a43_1 = lhs.components[12] * rhs.components[2]
        let a43_2 = lhs.components[13] * rhs.components[6]
        let a43_3 = lhs.components[14] * rhs.components[10]
        let a43_4 = lhs.components[15] * rhs.components[14]

        let a44_1 = lhs.components[12] * rhs.components[3]
        let a44_2 = lhs.components[13] * rhs.components[7]
        let a44_3 = lhs.components[14] * rhs.components[11]
        let a44_4 = lhs.components[15] * rhs.components[15]

        return Self(
            a11: a11_1 + a11_2 + a11_3 + a11_4,
            a12: a12_1 + a12_2 + a12_3 + a12_4,
            a13: a13_1 + a13_2 + a13_3 + a13_4,
            a14: a14_1 + a14_2 + a14_3 + a14_4,

            a21: a21_1 + a21_2 + a21_3 + a21_4,
            a22: a22_1 + a22_2 + a22_3 + a22_4,
            a23: a23_1 + a23_2 + a23_3 + a23_4,
            a24: a24_1 + a24_2 + a24_3 + a24_4,

            a31: a31_1 + a31_2 + a31_3 + a31_4,
            a32: a32_1 + a32_2 + a32_3 + a32_4,
            a33: a33_1 + a33_2 + a33_3 + a33_4,
            a34: a34_1 + a34_2 + a34_3 + a34_4,

            a41: a41_1 + a41_2 + a41_3 + a41_4,
            a42: a42_1 + a42_2 + a42_3 + a42_4,
            a43: a43_1 + a43_2 + a43_3 + a43_4,
            a44: a44_1 + a44_2 + a44_3 + a44_4
        )
    }
}

public extension t_mat4 {
    static var zero: t_mat4<Component> { t_mat4() }
}

extension t_mat4: FloatingPointMatrix where Component: FloatingPoint {
    
}

extension t_mat4: StaticFloatingPointMatrix where Component: FloatingPoint {

}

public typealias Mat4f = t_mat4<Float>
public typealias Mat4d = t_mat4<Double>
public typealias Mat4i = t_mat4<Int>
public typealias Mat4 = Mat4f
