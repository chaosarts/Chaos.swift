//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 05.09.24.
//

import SwiftUI

extension Angle {
    public static var north: Angle { .radians(3 / 2 * .pi) }
    public static var east: Angle { .zero }
    public static var south: Angle { .radians(1 / 2 * .pi) }
    public static var west: Angle { .radians(.pi) }
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
