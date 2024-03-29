//
//  Matrix.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 08.04.21.
//

import Foundation

// MARK: - Matrix

public struct MatrixShape: Equatable, Codable {

    public var rows: Int

    public var columns: Int

    public var volume: Int {
        rows * columns
    }

    public var swapped: MatrixShape {
        MatrixShape(rows: columns, columns: rows)
    }
}

/// A protocol to describe the structur of a matrix type.
public protocol Matrix: Equatable, Codable {

    /// Represents the type to indicate the shape of a matrix
    typealias Shape = MatrixShape

    /// The data type of the components of this matrix.
    associatedtype Component

    /// The data type of the matrix the results from transposing a matrix type.
    associatedtype TransposedMatrix: Matrix where TransposedMatrix.Component == Component

    /// The vector type representing a row of a matrix.
    associatedtype RowVector: Vector where RowVector.Component == Component

    /// The vector type representing a col of a matrix.
    associatedtype ColVector: Vector where ColVector.Component == Component


    /// The list of components of the matrix in row-major order.
    var components: [Component] { get }

    /// The shape describing the matrix row and column count. The product of both
    /// numbers must fit the count of `components`.
    var shape: Shape { get }

    /// Provides the transposed matrix of this matrix.
    var transposed: TransposedMatrix { get }

    /// Subscript access to the row vector corresponding to the given index.
    subscript(row index: Int) -> RowVector { get set }

    /// Subscript access to the col vector corresponding to the given index.
    subscript(col index: Int) -> ColVector { get set }

    /// Subscript access to the component corresponding to the given row and
    /// column index.
    subscript (row: Int, col: Int) -> Component { get set }

    /// Returns the component that corresponds to the given `components` index.
    func component(at index: Int) -> Component

    /// Sets the value for the component that corresponds to the given
    /// `components` index.
    @discardableResult
    mutating func setComponent(_ component: Component, at index: Int) -> Self

    /// Calculates the component-wise sum of two given matrices.
    @inlinable static func + (_ lhs: Self, _ rhs: Self) -> Self

    /// Calculates the component-wise additive inverse of a given matrix. Not to
    /// be confused with the inverse of a matrix.
    @inlinable static prefix func - (_ mat: Self) -> Self

    /// Calculates the component-wise substraction of two given matrices.
    @inlinable static func - (_ lhs: Self, _ rhs: Self) -> Self

    /// Calculates the product of a given matrix and a given scalar.
    @inlinable static func * (_ lhs: Self, _ rhs: Component) -> Self

    /// Calculates the product of a given matrix and a given scalar.
    @inlinable static func * (_ lhs: Component, _ rhs: Self) -> Self
}

// MARK: Default Matrix Implementation

public extension Matrix {

    subscript(row index: Int) -> RowVector {
        get {
            let offset = index * shape.rows
            return RowVector(components: Array(components[offset..<(offset + shape.rows)]))
        }
        set {
            let offset = index * shape.rows
            for i in 0..<shape.rows {
                setComponent(newValue[i], at: offset + i)
            }
        }
    }

    subscript(col index: Int) -> ColVector {
        get {
            var components: [Component] = []
            var offset = index
            for _ in 0..<shape.columns {
                components.append(self.components[offset])
                offset += shape.columns
            }
            return ColVector(components: components)
        }
        set {
            var offset = index
            for i in 0..<shape.columns {
                setComponent(newValue[i], at: offset)
                offset += shape.columns
            }
        }
    }

    subscript(row: Int, col: Int) -> Component {
        get {
            components[row * shape.rows + col]
        }
        set {
            setComponent(newValue, at: row * shape.rows + col)
        }
    }

    @inlinable static func - (_ lhs: Self, _ rhs: Self) -> Self {
        lhs + -rhs
    }

    @inlinable static func * (_ lhs: Component, rhs: Self) -> Self {
        rhs * lhs
    }

    func map<T> (_ transform: (Component) throws -> T) rethrows -> [T] {
        try components.map(transform)
    }
}


// MARK: - Static Matrix

public protocol StaticMatrix: Matrix {
    static var shape: Shape { get }
}

public extension StaticMatrix {
    var shape: Shape { Self.shape }
}


// MARK: - Square Matrix

public protocol SquareMatrix: Matrix where RowVector == ColVector {
    var dimension: Int { get }
    var determinant: Component { get }

    @inlinable static func * (_ lhs: Self, rhs: Self) -> Self
}


// MARK: - Static Square Matrix

public protocol StaticSquareMatrix: StaticMatrix & SquareMatrix {
    static var dimension: Int { get }
}

public extension StaticSquareMatrix {
    static var shape: Shape { Shape(rows: dimension, columns: dimension) }
    var dimension: Int { Self.dimension }
}


// MARK: - Floating Point Matrix

public protocol FloatingPointMatrix: Matrix where Component: FloatingPoint {
    @inlinable static func / (_ lhs: Self, _ rhs: Component) -> Self
}

public extension FloatingPointMatrix {
    @inlinable static func / (_ lhs: Self, _ rhs: Component) -> Self {
        lhs * (1 / rhs)
    }
}

public protocol StaticFloatingPointMatrix: FloatingPointMatrix & StaticMatrix {
    
}
