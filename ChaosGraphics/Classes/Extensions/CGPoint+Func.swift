//
//  CGPoint+Func.swift
//  ChaosGraphics
//
//  Created by Fu Lam Diep on 22.02.21.
//

import Foundation

public extension CGPoint {

    func distance(to point: CGPoint) -> CGFloat {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(x * x + y * y)
    }
}
