//
//  Box3.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 10.09.21.
//

import Foundation

/// A struct describing a box by its origin and size. This struct corresponds to `CGRect` but for the 3d space.
public struct t_box3<Component: SignedNumeric> {

    public typealias Point3 = t_point3<Component>

    public typealias Size3 = t_size3<Component>


    // MARK: Main Properties

    /// The front left bottom of the box.
    public var origin: Point3

    /// The size of the box extending to the back upper right of the box.
    public var size: Size3


    // MARK: Size Properties

    public var width: Component {
        get { size.width }
        set { size.width = newValue }
    }

    public var height: Component {
        get { size.height }
        set { size.height = newValue }
    }

    public var depth: Component {
        get { size.depth }
        set { size.depth = newValue }
    }

    public var volume: Component {
        get { size.volume }
    }

    public var isEmpty: Bool { size.volume == 0 }


    // MARK: Origin Properties

    public var minX: Component { origin.x }

    public var minY: Component { origin.y }

    public var minZ: Component { origin.z }


    // MARK: Implicit Properties

    public var maxX: Component { origin.x + size.width }

    public var maxY: Component { origin.y + size.height }

    public var maxZ: Component { origin.z + size.depth }


    // MARK: Initialization

    public init (origin: Point3, size: Size3) {
        self.origin = origin
        self.size = size
    }

    public init (minX: Component, minY: Component, minZ: Component, maxX: Component, maxY: Component, maxZ: Component) {
        self.init(origin: Point3(minX, minY, minZ), size: t_size3(width: maxX - minX, height: maxY - minY, depth: maxZ - minZ))
    }


    // MARK: Modification Methods

    /// Translates the box component-wise by the values.
    /// - Parameter x: The value by which to translate the box along the x-axis
    /// - Parameter y: The value by which to translate the box along the y-axis
    /// - Parameter z: The value by which to translate the box along the z-axis
    /// - Returns: The box itself for method chaining.
    @discardableResult
    public mutating func offsetBy (x: Component = 0, y: Component = 0, z: Component = 0) -> Self {
        origin = origin + t_vec3(x, y, z)
        return self
    }

    /// Insets the box component-wise by the values `2 * width`, `2 * height` and `2 * depth` around the center of box.
    /// - Parameter width: The value by which to inset the box along the x-axis
    /// - Parameter height: The value by which to inset the box along the y-axis
    /// - Parameter depth: The value by which to inset the box along the z-axis
    /// - Returns: The box itself for method chaining.
    @discardableResult
    public mutating func insetBy (width: Component = 0, height: Component = 0, depth: Component = 0) -> Self {
        size.insetBy(width: 2 * width, height: 2 * height, depth: 2 * depth)
        return offsetBy(x: width, y: height, z: depth)
    }
}


// MARK: - Predefined Instances

public extension t_box3 {
    static var zero: Self { Self(origin: .zero, size: .zero) }
    static var null: Self { Self(origin: .zero, size: .null) }
}


// MARK: - Additional Properties for Floating Point Components

public extension t_box3 where Component: FloatingPoint {

    /// Provides the center of the box implied by `origin` and `size`.
    public var center: Point3 { Point3(midX, midY, midZ) }

    /// Provides the x-component of `center`
    public var midX: Component { origin.x + size.width / 2 }

    /// Provides the y-component of `center`
    public var midY: Component { origin.y + size.height / 2 }

    /// Provides the z-component of `center`
    public var midZ: Component { origin.z + size.depth / 2 }

    /// Determines if the given point is inside the box.
    public func contains (_ point: Point3) -> Bool {
        !(point.x > maxX || point.x < minX || point.y > maxY || point.y < minY || point.z > maxZ || point.z < minZ)
    }
}

extension t_box3: Equatable where Component: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.origin == rhs.origin && lhs.size == rhs.size
    }
}

extension t_box3: Comparable where Component: Comparable {

    public static func < (lhs: t_box3<Component>, rhs: t_box3<Component>) -> Bool {
        lhs.size < rhs.size
    }

    public var isNull: Bool { size.isNull }

    public func union (_ other: Self) -> Self {
        let minX = min(minX, other.minX)
        let minY = min(minY, other.minY)
        let minZ = min(minZ, other.minZ)

        let maxX = max(maxX, other.maxX)
        let maxY = max(maxY, other.maxY)
        let maxZ = max(maxZ, other.maxZ)

        return Self(minX: minX, minY: minY, minZ: minZ, maxX: maxX, maxY: maxY, maxZ: maxZ)
    }

    public func intersect (_ other: Self) -> Self {
        let minX = max(minX, other.minX)
        let minY = max(minY, other.minY)
        let minZ = max(minZ, other.minZ)

        let maxX = min(maxX, other.maxX)
        let maxY = min(maxY, other.maxY)
        let maxZ = min(maxZ, other.maxZ)
        return Self(minX: minX, minY: minY, minZ: minZ, maxX: maxX - minX, maxY: maxY - minY, maxZ: maxZ - minZ)
    }

    public func contains (_ other: Self) -> Bool {
        union(other) == self
    }
}

public typealias Box3i = t_box3<Int>
public typealias Box3f = t_box3<Float>
public typealias Box3d = t_box3<Double>
public typealias Box3 = Box3f
