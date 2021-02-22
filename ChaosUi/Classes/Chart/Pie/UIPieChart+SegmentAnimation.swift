//
//  UIPieChart+SegmentAnimation.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 13.02.21.
//

import CoreGraphics
import QuartzCore

public extension UIPieChart {
    @objc public class SegmentAnimation: NSObject {
        @objc public dynamic let minAngle: CGFloat

        @objc public dynamic let maxAngle: CGFloat

        @objc public dynamic let color: CGColor


        public init (minAngle: CGFloat, maxAngle: CGFloat, color: CGColor) {
            self.minAngle = minAngle
            self.maxAngle = maxAngle
            self.color = color
        }
    }
}
