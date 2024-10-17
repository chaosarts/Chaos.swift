//
//  CGPoint+Func.swift
//  ChaosGraphics
//
//  Created by Fu Lam Diep on 22.02.21.
//

import CoreGraphics
import ChaosMath

public extension CGPoint {

    init (radius: CGFloat, angle: CGFloat) {
        self.init(x: radius * cos(angle), y: radius * sin(angle))
    }

    func distance(to point: CGPoint) -> CGFloat {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(x * x + y * y)
    }

    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.x + rhs.dy)
    }
}
