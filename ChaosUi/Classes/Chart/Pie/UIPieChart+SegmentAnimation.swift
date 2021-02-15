//
//  UIPieChart+SegmentAnimation.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 13.02.21.
//

import Foundation

public extension UIPieChart {
    @objc public class SegmentAnimation: NSObject {
        public var initialStartAngle: CGFloat?
        public var initialEndAngle: CGFloat?
        public var initialColor: UIColor?
        public var initialAlpha: CGFloat?
    }
}
