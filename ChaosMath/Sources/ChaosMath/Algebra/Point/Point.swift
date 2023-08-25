//
//  Point.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 13.04.21.
//

import Foundation

// MARK: - Point

/// A protocol describing the structure for a algebra point object
public protocol Point: Equatable, Codable {

    /// The type of the components of a point.
    associatedtype Component: SignedNumeric

    /// Provides the ordered list of components of a point
    var components: [Component] { get }

    /// Indicates the dimension of the point. This must be equal to the count of
    /// components.
    var dimension: Int { get }

    /// Initializes the point with a list of components.
    init (components: [Component])

    /// Returns the additive inverse of the point.
    @inlinable static prefix func - (_ point: Self) -> Self

    static func *(lhs: Component, rhs: Self) -> Self

    static func *(lhs: Self, rhs: Component) -> Self
}


// MARK: Default Point Implementations

public extension Point {
    var dimension: Int { components.count }

    @inlinable static prefix func - (_ point: Self) -> Self {
        let components = point.components.map({ -$0 })
        return Self(components: components)
    }

    @inlinable static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.components == rhs.components
    }

    static func * (lhs: Component, rhs: Self) -> Self {
        Self.init(components: rhs.components.map { $0 * lhs })
    }

    static func * (lhs: Self, rhs: Component) -> Self {
        rhs * lhs
    }
}

public extension Point where Component: FloatingPoint {
    static func / (lhs: Self, rhs: Component) -> Self {
        Self.init(components: lhs.components.map{ $0 / rhs })
    }
}


// MARK: - StaticPoint

/// A protocol for point types of fixed dimension
public protocol StaticPoint: Point {

    /// The static property indicating the dimension for each instance of this
    /// type. This must be equal to the instance property `dimension` of a point.
    static var dimension: Int { get }
}


// MARK: Default StaticPoint Implementation

public extension StaticPoint {
    var dimension: Int { Self.dimension }
}
