//
//  File.swift
//  
//
//  Created by fu.lam.diep on 30.08.22.
//

import Foundation

public extension Double {

    // MARK: Constant Angles

    /// Represents the angle pointing north on a circle in UIKit
    static let circleTopAngle: Double = .pi * 1.5

    /// Represents the angle pointing east on a circle in UIKit
    static let circleRightAngle: Double = 0.0

    /// Represents the angle pointing south on a circle in UIKit
    static let circleBottomAngle: Double = .pi * 0.5

    /// Represents the angle pointing west on a circle in UIKit
    static let circleLeftAngle: Double = .pi


    // MARK: Conversion

    /// Calculates the degree of an angle corresponding to the given radian
    static func degree (_ rad: Double) -> Double {
        return rad / .pi * 180
    }

    /// Calculates the radian of an angle corresponding to the given degree
    static func radian (_ deg: Double) -> Double {
        return deg / 180 * .pi
    }
}
