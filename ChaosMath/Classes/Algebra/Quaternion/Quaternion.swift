//
//  t_quaternion.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 08.04.21.
//

import Foundation

public struct t_quaternion<Component: FloatingPoint & Codable>: Codable {

    public typealias Component = Component

    public typealias Vec3 = t_vec3<Component>

    public private(set) var components: [Component]

    public var r: Component {
        get { components[0] }
        set { components[0] = newValue }
    }

    public var i: Component {
        get { components[1] }
        set { components[1] = newValue }
    }

    public var j: Component {
        get { components[2] }
        set { components[2] = newValue }
    }

    public var k: Component {
        get { components[3] }
        set { components[3] = newValue }
    }

    public var real: Component {
        get { components[0] }
        set { components[0] = newValue }
    }

    public var imaginary: Vec3 {
        get { t_vec3(components[1], components[2], components[3]) }
        set {
            components[1] = newValue.x
            components[2] = newValue.y
            components[3] = newValue.z
        }
    }

    public var length: Component {
        sqrt(dot(self))
    }

    public var inverse: Self {
        ~self / (length * length)
    }

    public var normalized: Self {
        self / length
    }

    public var rotationMatrix: t_mat4<Component> {
        var matrix: t_mat4<Component> = .zero
        let vector = self.imaginary
        let real = self.real

        let x2 = 2 * vector.x * vector.x
        let y2 = 2 * vector.y * vector.y
        let z2 = 2 * vector.z * vector.z

        let xy = 2 * vector.x * vector.y
        let xz = 2 * vector.x * vector.z
        let yz = 2 * vector.y * vector.z

        let real_x = 2 * real * vector.x
        let real_y = 2 * real * vector.y
        let real_z = 2 * real * vector.z

        matrix[0, 0] = 1 - y2 - z2
        matrix[0, 1] = xy - real_z
        matrix[0, 2] = xz + real_y

        matrix[1, 0] = xy + real_z
        matrix[1, 1] = 1 - x2 - z2
        matrix[1, 2] = yz - real_x

        matrix[2, 0] = xz - real_y
        matrix[2, 1] = yz + real_x
        matrix[2, 2] = 1 - x2 - y2

        matrix[3, 3] = 1

        return matrix
    }

    public init (_ r: Component = 0, _ i: Component = 0, _ j: Component = 0, _ k: Component = 0) {
        components = [r, i, j, k]
    }

    public init (real: Component = 0, imaginary: Vec3 = Vec3()) {
        components = [real, imaginary.x, imaginary.y, imaginary.z]
    }

    public subscript (_ index: Int) -> Component {
        get { components[index] }
        set { components[index] = newValue }
    }

    public func dot (_ other: Self) -> Component {
        let result = components[0] * other.components[0] + components[1] * other.components[1]
        return result + components[2] * other.components[2] + components[3] * other.components[3]
    }

    public mutating func invert () {
        self = self.inverse
    }

    public mutating func normalize () {
        self = self.normalized
    }

    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        Self(
            lhs.components[0] + rhs.components[0],
            lhs.components[1] + rhs.components[1],
            lhs.components[2] + rhs.components[2],
            lhs.components[3] + rhs.components[3]
        )
    }

    public static func * (_ lhs: Self, _ rhs: Component) -> Self {
        Self(
            lhs.components[0] * rhs,
            lhs.components[1] * rhs,
            lhs.components[2] * rhs,
            lhs.components[3] * rhs
        )
    }

    public static func * (_ lhs: Component, _ rhs: Self) -> Self {
        rhs * lhs
    }

    public static func * (_ lhs: Self,  _ rhs: Self) -> Self {
        var r = lhs.components[0] * rhs.components[0]
        r -= lhs.components[1] * rhs.components[1]
        r -= lhs.components[2] * rhs.components[2]
        r -= lhs.components[3] * rhs.components[3]

        var i = lhs.components[0] * rhs.components[1]
        i += lhs.components[1] * rhs.components[0]
        i += lhs.components[2] * rhs.components[3]
        i -= lhs.components[3] * rhs.components[2]

        var j = lhs.components[0] * rhs.components[2]
        j -= lhs.components[1] * rhs.components[3]
        j += lhs.components[2] * rhs.components[0]
        j += lhs.components[3] * rhs.components[1]

        var k = lhs.components[0] * rhs.components[3]
        k += lhs.components[1] * rhs.components[2]
        k -= lhs.components[2] * rhs.components[1]
        k += lhs.components[3] * rhs.components[0]

        return Self(r, i, j, k)
    }

    public static prefix func ~ (_ quaternion: Self) -> Self {
        Self(real: quaternion.real, imaginary: -quaternion.imaginary)
    }

    public static func / (_ lhs: Self, _ rhs: Component) -> Self {
        lhs * (1 / rhs)
    }
}

public extension t_quaternion {
    static var zero: Self { t_quaternion(0, 0, 0, 0) }
}

public typealias Quaternion = t_quaternion<Float>
