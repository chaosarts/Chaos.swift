//
//  CGFloat+Angle.swift
//  Chaos
//
//  Created by Fu Lam Diep on 29.11.20.
//

import CoreGraphics

public extension CGFloat {
    static let circleTopAngle: CGFloat = .pi * 1.5
    static let circleRightAngle: CGFloat = 0.0
    static let circleBottomAngle: CGFloat = .pi * 0.5
    static let circleLeftAngle: CGFloat = .pi

    /// Calculates the degree of an angle corresponding to the given radian
    static func degree (_ rad: CGFloat) -> CGFloat {
        return rad / .pi * 180
    }

    /// Calculates the radian of an angle corresponding to the given degree
    static func radian (_ deg: CGFloat) -> CGFloat {
        return deg / 180 * .pi
    }
}
