//
//  Vector.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 07.04.21.
//

import Foundation

// MARK: - Vector

public protocol Vector: CustomStringConvertible, Hashable, Codable, ExpressibleByArrayLiteral {

    /// Describes the data type of the components of this vector
    associatedtype Component: SignedNumeric & Codable

    /// Provides the dimension of the vector, which is equal to the count of
    /// components.
    var dimension: Int { get }

    /// Provides the list of components.
    var components: [Component] { get }

    /// Initializes the vector with the list of components.
    /// - Parameter components: The ordered list of components of this vector
    init (components: [Component])

    /// Initializes a vector that goes from `p1` to `p2`. By default, this is the
    /// vector with components resulting from `p2 - p1`.
    /// - Parameter p1: The origin of the vector
    /// - Parameter p2: The point to which the vector points coming from `p1`
    init<P: Point> (from p1: P, to p2: P) where P.Component == Component

    /// Convenient access to single components of this vector.
    /// - Parameter index: The index to the corresponding component in the
    /// `components` list
    subscript (_ index: Int) -> Component { get set }

    /// Calculates the dot product between this vector and a given other vector.
    /// In general this is the sum of the component-wise products.
    func dot (_ other: Self) -> Component

    /// Calculates and returns the component-wise sum of two given vectors.
    @inlinable static func + (_ lhs: Self, _ rhs: Self) -> Self

    /// Calculates and returns the invers of a given vector.
    @inlinable static prefix func - (_ vector: Self) -> Self

    /// Calculates and returns the component-wise substraction of two given
    /// vectors.
    @inlinable static func - (_ lhs: Self, rhs: Self) -> Self

    /// Calculates and returns the component-wise product of the given vector and
    /// scalar.
    @inlinable static func * (_ lhs: Self, rhs: Component) -> Self

    /// Calculates and returns the product of the given vector and scalar
    @inlinable static func * (_ lhs: Component, rhs: Self) -> Self
}


// MARK: Default Implementation

public extension Vector {

    var description: String {
        components.description
    }

    var dimension: Int { components.count }

    func hash(into hasher: inout Hasher) {
        hasher.combine(components.map({ "\($0)" }).joined(separator: ","))
    }

    init(_ components: Component...) {
        self.init(components: components)
    }

    init(arrayLiteral elements: Component...) {
        self.init(components: elements)
    }

    @inlinable static func - (_ lhs: Self, rhs: Self) -> Self {
        lhs + -rhs
    }

    @inlinable static func * (_ lhs: Component, rhs: Self) -> Self {
        rhs * lhs
    }
}

public protocol StaticVector: Vector {
    static var dimension: Int { get }
}

public extension StaticVector {
    var dimension: Int { Self.dimension }
}
