//
//  UITimelineViewConnector.swift
//  Chaos
//
//  Created by Fu Lam Diep on 13.11.20.
//

import UIKit

@objc public protocol UITimelineViewConnector: AnyObject, NSObjectProtocol {
    @objc optional var weight: CGFloat { get }
    @objc optional var inset: Bool { get }
    @objc optional var fillColor: CGColor { get }
    @objc func path (in frame: CGRect, axis: NSLayoutConstraint.Axis) -> CGPath
}

public extension UITimelineViewConnector {
    static func solid (weight: CGFloat,
                       inset: Bool = false,
                       fillColor: UIColor = .black,
                       lineCap: CGLineCap = .square) -> UITimelineViewSolidConnector {
        return UITimelineViewSolidConnector(weight: weight,
                                            inset: inset,
                                            fillColor: fillColor,
                                            lineCap: lineCap)
    }
}


public class UITimelineViewSolidConnector: NSObject, UITimelineViewConnector {

    public var weight: CGFloat
    public var inset: Bool
    public var fillColor: UIColor
    public var lineCap: CGLineCap

    public init (weight: CGFloat,
                 inset: Bool = false,
                 fillColor: UIColor = .black,
                 lineCap: CGLineCap = .square) {
        self.weight = weight
        self.inset = inset
        self.fillColor = fillColor
        self.lineCap = lineCap
    }

    public func path(in frame: CGRect, axis: NSLayoutConstraint.Axis) -> CGPath {
        let radius: CGFloat
        switch axis {
        case .horizontal:
            radius = frame.height / 2.0
        case.vertical:
            radius = frame.width / 2.0
        @unknown default:
            fatalError("Unknown NSLayoutConstraint.Axis")
        }
        return UIBezierPath(roundedRect: frame, cornerRadius: radius).cgPath
    }
}


public class UITimelineViewDottedConnector: NSObject, UITimelineViewConnector {

    public var radius: CGFloat
    public var spacing: CGFloat
    public var phase: CGFloat
    public var inset: Bool
    public var fillColor: UIColor

    public var weight: CGFloat { return radius * 2.0 }

    public init (radius: CGFloat,
                 spacing: CGFloat,
                 phase: CGFloat = 0.0,
                 inset: Bool = false,
                 fillColor: UIColor = .black) {
        self.radius = radius
        self.spacing = spacing
        self.phase = phase
        self.inset = inset
        self.fillColor = fillColor
    }

    public func path(in frame: CGRect, axis: NSLayoutConstraint.Axis) -> CGPath {
        let bezierPath = UIBezierPath()
        let stride = 2.0 * radius + spacing
        let normalizedPhase = phase - stride * floor(phase / stride)
        let offset = normalizedPhase - spacing

        return bezierPath.cgPath
    }

    private func contributeVDot (to bezierPath: UIBezierPath, in frame: CGRect, stride: CGFloat, normalizedPhase: CGFloat) {
        
    }
}

//public extension UITimelineViewConnector {
//    static var solid: UITimelineViewConnector { UITimelineViewSolidConnector() }
//}
//
//@objc public class UITimelineViewSolidConnector: NSObject, UITimelineViewConnector {
//    
//}

