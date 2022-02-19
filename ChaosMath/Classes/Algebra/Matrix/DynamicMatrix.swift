//
//  Mat.swift
//  ChaosMath
//
//  Created by Fu Lam Diep on 14.04.21.
//

import ChaosCore

public struct DynamicMatrix<Component: CodableSignedNumeric>: Matrix {

    public typealias TransposedMatrix = Self

    public typealias RowVector = t_dynamic_vector<Component>

    public typealias ColVector = t_dynamic_vector<Component>

    public private(set) var components: [Component] = []

    public private(set) var shape: Shape

    public var transposed: Self {
        var components: [Component] = []
        for col in 0..<shape.columns {
            for row in 0..<shape.rows {
                components.append(self.components[row * shape.rows + col])
            }
        }
        return Self(components: components, shape: shape.swapped)
    }

    public init (components: [Component], shape: Shape) {
        self.shape = shape
        self.components = Array(repeating: 0, count: shape.volume)
        for index in 0..<min(self.components.count, components.count) {
            self.components[index] = components[index]
        }
    }

    public func component(at index: Int) -> Component {
        components[index]
    }

    public mutating func setComponent(_ component: Component, at index: Int) -> Self {
        components[index] = component
        return self
    }


    public static func + (_ lhs: Self, _ rhs: Self) -> Self {
        guard lhs.shape == rhs.shape else {
            fatalError("Unable to calculate sum between two matrices of different shape.")
        }

        let components = lhs.components.zip(rhs.components).map({ $0.0 + $0.1 })
        return Self(components: components, shape: lhs.shape)
    }

    public static prefix func - (_ matrix: Self) -> Self {
        Self(components: matrix.components.map({ -$0 }), shape: matrix.shape)
    }

    public static func * (_ matrix: Self, _ scalar: Component) -> Self {
        Self(components: matrix.components.map({ $0 * scalar }), shape: matrix.shape)
    }

    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.components == rhs.components && lhs.shape == rhs.shape
    }
}
