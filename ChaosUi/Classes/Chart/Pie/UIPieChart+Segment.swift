//
//  UIPieChart+Segment.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 11.02.21.
//

import Foundation
import ChaosAnimation


internal extension UIPieChart {
    internal class Segment {
        var title: String?
        var absoluteValue: Double = 0.0
        var relativeValue: Double = 0.0
        var startAngle: CGFloat = 0.0
        var endAngle: CGFloat { startAngle + .pi * 2 * CGFloat(relativeValue) }
        var color: UIColor = UIView.appearance().tintColor
        var isHidden: Bool = true
    }
}
