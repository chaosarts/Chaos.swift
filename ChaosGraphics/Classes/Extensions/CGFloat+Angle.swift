//
//  CGFloat+Angle.swift
//  Chaos
//
//  Created by Fu Lam Diep on 29.11.20.
//

import CoreGraphics

public extension CGFloat {

    // MARK: Constant Angles

    /// Represents the angle pointing north on a circle in UIKit
    static let circleTopAngle: CGFloat = .pi * 1.5

    /// Represents the angle pointing east on a circle in UIKit
    static let circleRightAngle: CGFloat = 0.0

    /// Represents the angle pointing south on a circle in UIKit
    static let circleBottomAngle: CGFloat = .pi * 0.5

    /// Represents the angle pointing west on a circle in UIKit
    static let circleLeftAngle: CGFloat = .pi


    // MARK: Conversion

    /// Calculates the degree of an angle corresponding to the given radian
    static func degree (_ rad: CGFloat) -> CGFloat {
        return rad / .pi * 180
    }

    /// Calculates the radian of an angle corresponding to the given degree
    static func radian (_ deg: CGFloat) -> CGFloat {
        return deg / 180 * .pi
    }
}
