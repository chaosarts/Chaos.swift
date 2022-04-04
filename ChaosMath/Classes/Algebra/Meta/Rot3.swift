//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 19.02.22.
//

import Foundation

public protocol t_rot3: Codable {
    associatedtype Component: FloatingPoint & Codable

    var axis: t_vec3<Component> { get set }

    var angle: Component { get set }

    var quaternion: t_quaternion<Component> { get }

    var matrix: t_mat4<Component> { get }
}

public extension t_rot3 {

    var matrix: t_mat4<Component> {
        quaternion.rotationMatrix
    }
}

public struct Rot3f: t_rot3 {

    public static var zero: Rot3f { Rot3f() }

    public var axis: Vec3

    public var angle: Vec3.Component

    public var quaternion: Quaternion {
        let halfAngle = angle / 2
        return t_quaternion(real: cos(halfAngle), imaginary: sin(halfAngle) * axis)
    }

    public init(axis: Vec3 = .zero, angle: Vec3.Component = .zero) {
        self.axis = axis
        self.angle = angle
    }
}

public struct Rot3d: t_rot3 {

    public static var zero: Rot3d { Rot3d() }

    public var axis: Vec3d

    public var angle: Vec3d.Component

    public var quaternion: t_quaternion<Double> {
        let halfAngle = angle / 2
        return t_quaternion(real: cos(halfAngle), imaginary: sin(halfAngle) * axis)
    }

    public init(axis: Vec3d = .zero, angle: Vec3d.Component = .zero) {
        self.axis = axis
        self.angle = angle
    }
}

public typealias Rot3 = Rot3f
