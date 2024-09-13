//
//  Created by Fu Lam Diep on 05.09.24.
//

import SwiftUI

extension Angle {
    /**
     The angle that corresponds to the north in SwiftUI coordinate space.
     */
    public static var north: Angle { .radians(3 / 2 * .pi) }

    /**
     The angle that corresponds to the east in SwiftUI coordinate space.
     */
    public static var east: Angle { .zero }

    /**
     The angle that corresponds to the south in SwiftUI coordinate space.
     */
    public static var south: Angle { .radians(1 / 2 * .pi) }

    /**
     The angle that corresponds to the west in SwiftUI coordinate space.
     */
    public static var west: Angle { .radians(.pi) }

    /**
     Returns an angle that is equivalent to this angle within the range between 0° and 360° (or 0 and 2π radians).

     In fact this method is simply performing a modulo 360 operation.
     */
    public func normalized() -> Angle {
        let degrees = self.degrees.truncatingRemainder(dividingBy: 360)
        return if degrees < 0 {
            .degrees(360 + degrees)
        } else {
            .degrees(degrees)
        }
    }

    /**
     Mutates the angle to it's equivalent angle within the range between 0° and 360° (or 0 and 2π radians).
     */
    public mutating func normalize() {
        self = self.normalized()
    }

    /**
     Returns the angle between the normalized equivalents of this angle and the passed `other` angle consediring,
     whether to measure clockwise or counter clockwise. This will always return a positive angle.
     */
    public func normalizedDistance(to other: Angle, clockwise: Bool = true) -> Angle {
        let this = self.normalized()
        let other = other.normalized()

        return if this < other {
            if clockwise {
                other - this
            } else {
                this - (other - .degrees(360))
            }
        } else {
            if clockwise {
                (other + .degrees(360)) - this
            } else {
                this - other
            }
        }
    }
}

extension Angle: VectorArithmetic {
    public mutating func scale(by rhs: Double) {
        animatableData *= rhs
    }
    
    public var magnitudeSquared: Double {
        0
    }
    
    static public func +(lhs: Self, rhs: Self) -> Self {
        Angle(radians: lhs.radians + rhs.radians)
    }

    static public func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static public func -(lhs: Self, rhs: Self) -> Self {
        Angle(radians: lhs.radians - rhs.radians)
    }

    static public func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}
