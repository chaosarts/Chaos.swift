//
//  Size3.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 12.07.21.
//

import Foundation

public struct t_size3<Component: SignedNumeric & Comparable> {

    /// Provides the measure along the x-axis.
    public var width: Component

    /// Provides the measure along the y-axis.
    public var height: Component

    /// Provides the measure along the z-axis.
    public var depth: Component

    /// Provides the volume of the size indicated by the three measures.
    public var volume: Component { width * height * depth }

    /// Indicates whether the size is 0 or not
    public var isZero: Bool { volume == 0 }

    /// Indicates whether the size has valid components or not. An invalid size is present, when width, height or depth
    /// is less than zero.
    public var isValid: Bool {
        width >= Component.zero &&
        height >= Component.zero &&
        depth >= Component.zero
    }

    /// Modifies the measures of the size by subtracting the values component wise
    public mutating func insetBy (width: Component = 0, height: Component = 0, depth: Component = 0) {
        self.width -= width
        self.height -= height
        self.depth -= depth
    }

    /// Returns a new size that has the measures of this size subtracted by the given values at corresponding
    /// components.
    public func insetedBy (width: Component = 0, height: Component = 0, depth: Component = 0) -> Self {
        var size = self
        size.insetBy(width: width, height: height, depth: depth)
        return size
    }
}

public extension t_size3 {
    static var zero: Self { Self(width: 0, height: 0, depth: 0) }
    static var null: Self { Self(width: -1, height: -1, depth: -1) }
}

public extension t_size3 where Component: FloatingPoint {
    static var infinite: Self { Self(width: .infinity, height: .infinity, depth: .infinity) }
}

extension t_size3: Equatable where Component: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height && lhs.depth == rhs.depth
    }
}

extension t_size3: Comparable where Component: Comparable {

    public var isNull: Bool { width < 0 || height < 0 || depth < 0 }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.volume < rhs.volume
    }
}

public typealias Size3i = t_size3<Int>
public typealias Size3f = t_size3<Float>
public typealias Size3d = t_size3<Double>
public typealias Size3 = Size3f

