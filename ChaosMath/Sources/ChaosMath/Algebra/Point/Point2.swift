//
//  Point2.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 13.04.21.
//

import Foundation

/// A generic static point implementation for points in 2d space.
public struct t_point2<Component: CodableSignedNumeric>: StaticPoint {

    public static var dimension: Int { 2 }

    public private(set) var components: [Component] = [0, 0]

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


    public init (components: [Component] = []) {
        guard components.count > 0 else { return }
        self.components[0] = components[0]
        guard components.count > 1 else { return }
        self.components[1] = components[1]
    }

    /// A init with arguments representing the two components of this point.
    public init (_ x: Component, _ y: Component) {
        self.components = [x, y]
    }
}

public typealias Point2f = t_point2<Float>
public typealias Point2d = t_point2<Double>
public typealias Point2i = t_point2<Int>
public typealias Point2 = Point2f

