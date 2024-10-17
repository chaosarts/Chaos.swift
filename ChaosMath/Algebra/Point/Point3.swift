//
//  Point3.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 13.04.21.
//

import Foundation

/// A generic static point implementation for points in 3d space.
public struct t_point3<Component: CodableSignedNumeric>: StaticPoint {
    public static var dimension: Int { 3 }

    public private(set) var components: [Component] = [0, 0, 0]

    /// Conventional name for component at index 0
    public var x: Component {
        get { components[0] }
        set { components[0] = newValue }
    }

    /// Conventional name for component at index 1
    public var y: Component {
        get { components[1] }
        set { components[1] = newValue }
    }

    /// Conventional name for component at index 2
    public var z: Component {
        get { components[2] }
        set { components[2] = newValue }
    }

    public init (components: [Component] = []) {
        guard components.count > 0 else { return }
        self.components[0] = components[0]
        guard components.count > 1 else { return }
        self.components[1] = components[1]
        guard components.count > 2 else { return }
        self.components[2] = components[2]
    }

    public init (_ x: Component, _ y: Component, _ z: Component) {
        self.components = [x, y, z]
    }
}

public extension t_point3 {
    static var zero: Self { t_point3() }
}

public extension t_point3 where Component: FloatingPoint {
    static var infinity: Self { t_point3(.infinity, .infinity, .infinity) }
}

extension t_point3: Equatable where Component: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

public typealias Point3f = t_point3<Float>
public typealias Point3d = t_point3<Double>
public typealias Point3i = t_point3<Int>
public typealias Point3 = Point3f

