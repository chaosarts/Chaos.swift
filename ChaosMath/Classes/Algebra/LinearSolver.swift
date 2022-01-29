//
//  LinearTransformation.swift
//  Pods
//
//  Created by Fu Lam Diep on 23.12.21.
//

import Foundation

public struct LinearSolver<M: Matrix> {

    public var matrix: M

    public func solve<V: Vector, R: Vector>(rhs vector: V) throws -> R? {
        guard vector.dimension != matrix.shape.1 else {
            return nil
        }
    }
}
