//
//  UITicketShape.swift
//  Chaos
//
//  Created by Fu Lam Diep on 29.11.20.
//

import UIKit
import ChaosGraphics

public extension UIBezierPath {
    static func ticketShape (frame: CGRect, axis: NSLayoutConstraint.Axis = .vertical, cornerRadius: CGFloat = 14.0, tearOffOffset: CGFloat = 18.0, tearOffRadius: CGFloat = 4.0) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.0, y: cornerRadius))

        // Top left corner
        bezierPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .circleLeftAngle, endAngle: .circleTopAngle, clockwise: true)

        // Horizontal leading tearoff
        if axis == .horizontal {
            bezierPath.addArc(withCenter: CGPoint(x: tearOffRadius, y: 0.0), radius: tearOffRadius, startAngle: .circleLeftAngle, endAngle: .circleRightAngle, clockwise: false)
        }

        // Top right corner
        bezierPath.addArc(withCenter: CGPoint(x: frame.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .circleTopAngle, endAngle: .circleRightAngle, clockwise: true)

        // Vertical trailing tearoff
        if axis == .vertical {
            bezierPath.addArc(withCenter: CGPoint(x: frame.width, y: tearOffOffset), radius: tearOffRadius, startAngle: .circleTopAngle, endAngle: .circleBottomAngle, clockwise: false)
        }

        // Bottom right corner
        bezierPath.addArc(withCenter: CGPoint(x: frame.width - cornerRadius, y: frame.height - cornerRadius), radius: cornerRadius, startAngle: .circleRightAngle, endAngle: .circleBottomAngle, clockwise: true)

        // Horizontal trailing tearoff
        if axis == .horizontal {
            bezierPath.addArc(withCenter: CGPoint(x: tearOffRadius, y: frame.height), radius: tearOffRadius, startAngle: .circleRightAngle, endAngle: .circleLeftAngle, clockwise: false)
        }

        // Bottom left corner
        bezierPath.addArc(withCenter: CGPoint(x: cornerRadius, y: frame.height - cornerRadius), radius: cornerRadius, startAngle: .circleBottomAngle, endAngle: .circleLeftAngle, clockwise: true)

        // Vertical leading tearoff
        if axis == .vertical {
            bezierPath.addArc(withCenter: CGPoint(x: 0.0, y: tearOffOffset), radius: tearOffRadius, startAngle: .circleBottomAngle, endAngle: .circleTopAngle, clockwise: false)
        }

        bezierPath.close()

        return bezierPath
    }

    static func circle (radius: CGFloat,
                        center: CGPoint? = nil,
                        startAngle: CGFloat = 0.0,
                        clockwise: Bool = true) -> UIBezierPath {
        let center = center ?? CGPoint(x: radius, y: radius)
        let bezierPath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: startAngle + 2.0 * .pi,
                                      clockwise: clockwise)
        return bezierPath
    }


    static func circleSegment (startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat = 1.0, center: CGPoint = .zero, clockwise: Bool = true) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: center)
        bezierPath.addArc(withCenter: center,
                          radius: radius,
                          startAngle: startAngle,
                          endAngle: endAngle,
                          clockwise: clockwise)
        bezierPath.close()
        return bezierPath
    }

    static func donutSegment (startAngle: CGFloat, endAngle: CGFloat, innerRadius: CGFloat = 1.0, outerRadius: CGFloat = 2.0, center: CGPoint = .zero, clockwise: Bool = true) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        bezierPath.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        bezierPath.close()
        return bezierPath
    }
}
