//
//  UITimelineViewConnectorArtist.swift
//  Chaos
//
//  Created by Fu Lam Diep on 06.11.20.
//

import Foundation

@objc public protocol UITimelineViewMilestoneConnector: class, NSObjectProtocol {
    var width: CGFloat { get }
    func path (in rect: CGRect, axis: NSLayoutConstraint.Axis) -> CGPath
}

@objc public class UITimelineViewMilestoneDashedConnector: NSObject, UITimelineViewMilestoneConnector {

    public var width: CGFloat

    public var lineCap: CGLineCap

    public var pattern: [CGFloat]

    public var phase: CGFloat

    public var dashCap: CGLineCap


    public init (width: CGFloat, lineCap: CGLineCap = .butt, pattern: [CGFloat] = [], phase: CGFloat = 0.0, dashCap: CGLineCap = .butt) {
        self.width = width
        self.lineCap = lineCap
        self.pattern = (pattern.count % 2) == 0 ? pattern : Array(pattern[0..<(pattern.count - 1)])
        self.phase = phase
        self.dashCap = dashCap
    }

    public func path (in rect: CGRect, axis: NSLayoutConstraint.Axis) -> CGPath {
        let bezierPath = UIBezierPath()
        

        return bezierPath.cgPath
    }
}
