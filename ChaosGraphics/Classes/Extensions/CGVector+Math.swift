//
//  CGVector+Math.swift
//  ChaosGraphics
//
//  Created by Fu Lam Diep on 25.03.21.
//

import CoreGraphics

public extension CGVector {

    var length: CGFloat {
        sqrt(scalar(other: self))
    }

    init (from p1: CGPoint, to p2: CGPoint) {
        self.init(dx: p2.x - p1.x, dy: p2.y - p1.y)
    }

    init (radius: CGFloat, angle: CGFloat) {
        self.init(dx: radius * cos(angle), dy: radius * sin(angle))
    }

    /// Returns the scalar product between this vector and the other vector.
    /// - Parameter other: The other vector to calculate the scalar product.
    ///
    func scalar (other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }

    /// Returns the angle between this vector and the given other vector in
    /// radian.
    /// - Parameter other: The other vector to put in relation to this vector
    ///     to calculate the angle.
    /// - Returns: The angle between this and the other vector
    func angle (other: CGVector) -> CGFloat {
        acos(scalar(other: other) / (length * other.length))
    }

    /// Returns the vector pointing to the opposite direction of given vector.
    static prefix func - (_ vector: CGVector) -> CGVector {
        CGVector(dx: -vector.dx, dy: -vector.dy)
    }

    /// Returns the sum of the two given vectors
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    /// Returns the difference of the two given vectors, where lhs is the minute
    /// and rhs is the subtrahend.
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        lhs + -rhs
    }

    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        rhs * lhs
    }
}
