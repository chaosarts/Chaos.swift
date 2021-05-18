//
//  FloatingPointVector.swift
//  Enlighted
//
//  Created by Fu Lam Diep on 08.04.21.
//

import Foundation

public protocol FloatingPointVector: Vector where Component: FloatingPoint {
    var length: Component { get }
    
    @inlinable static func / (_ lhs: Self, _ rhs: Component) -> Self
}

public extension FloatingPointVector {
    var length: Component { sqrt(dot(self)) }

    @inlinable static func / (_ lhs: Self, _ rhs: Component) -> Self {
        lhs * (1 / rhs)
    }
}

public protocol StaticFloatingPointVector: StaticVector & FloatingPointVector {

}


// MARK: Float Component Vector

@inlinable public func angle<Vec: FloatingPointVector> (_ lhs: Vec, _ rhs: Vec) -> Vec.Component where Vec.Component == Float {
    acos(lhs.dot(rhs) / (lhs.length * rhs.length))
}


// MARK: Double Component Vector

@inlinable public func angle<Vec: FloatingPointVector> (_ lhs: Vec, _ rhs: Vec) -> Vec.Component where Vec.Component == Double {
    acos(lhs.dot(rhs) / (lhs.length * rhs.length))
}
