//
//  CAPieSliceLayer.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 11.02.21.
//

import QuartzCore

open class CACircleSegmentLayer: CAShapeLayer {

    // MARK: Static Methods

    open override class func needsDisplay(forKey key: String) -> Bool {
        if ["center", "startAngle", "endAngle", "radius", "innerRadius"].contains(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }


    // MARK: Appearance Properties

    /// Provides the center of the slice.
    @NSManaged open dynamic var center: CGPoint

    /// Provides the angle at which to start the slice.
    @NSManaged open dynamic var startAngle: CGFloat

    /// Provides the angle at which to end the slice.
    @NSManaged open dynamic var endAngle: CGFloat

    /// Provides the radius of the slice.
    @NSManaged open dynamic var radius: CGFloat

    /// Provides the inner radius of the segment for donut presentation.
    @NSManaged open dynamic var innerRadius: CGFloat

    /// Indicates whether the segment is clockwise or counter-clockwise oriented.
    @NSManaged open dynamic var clockwise: Bool


    // MARK: Layer Lifecycle

    open override func draw(in ctx: CGContext) {
        let segment = CGMutablePath()

        if endAngle - startAngle >= 2 * .pi {
            var path = CGMutablePath()
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
            ctx.addPath(path)

            path = CGMutablePath()
            path.addArc(center: center, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
            ctx.addPath(path)
        } else {
            var path = CGMutablePath()

            if innerRadius <= 0 {
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
            } else {
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
                path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: clockwise)
            }
            
            path.closeSubpath()
            ctx.addPath(path)
        }

        var modeMask = 0
        if let fillColor = fillColor {
            ctx.setFillColor(fillColor)
            modeMask = 1
        }

        if let strokeColor = strokeColor {
            ctx.setStrokeColor(strokeColor)
            modeMask = modeMask | 2
        }

        switch modeMask {
        case 1:
            ctx.drawPath(using: .eoFill)
        case 2:
            ctx.drawPath(using: .stroke)
        case 3:
            ctx.drawPath(using: .eoFillStroke)
        default:
            break
        }
    }
}
