//
//  Point4.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 13.04.21.
//

import Foundation

/// A generic static point implementation for points in 4d space.
public struct t_point4<Component: SignedNumeric>: StaticPoint {
    public static var dimension: Int { 4 }

    public private(set) var components: [Component] = [0, 0, 0, 0]

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

    /// Conventional name for component at index 3
    public var w: Component {
        get { components[3] }
        set { components[3] = newValue }
    }

    public init (components: [Component] = []) {
        guard components.count > 0 else { return }
        self.components[0] = components[0]
        guard components.count > 1 else { return }
        self.components[1] = components[1]
        guard components.count > 2 else { return }
        self.components[2] = components[2]
        guard components.count > 3 else { return }
        self.components[3] = components[3]
    }

    public init (_ x: Component, _ y: Component, _ z: Component, _ w: Component) {
        self.components = [x, y, z, w]
    }
}

public typealias Point4f = t_point4<Float>
public typealias Point4d = t_point4<Double>
public typealias Point4i = t_point4<Int>
public typealias Point4 = Point4f

