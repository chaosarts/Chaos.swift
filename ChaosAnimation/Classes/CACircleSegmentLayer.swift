//
//  CAPieSliceLayer.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 11.02.21.
//

import QuartzCore
import ChaosGraphics

open class CACircleSegmentLayer: CAShapeLayer {

    // MARK: Static Methods

    open override class func needsDisplay(forKey key: String) -> Bool {
        if ["center", "minAngle", "maxAngle", "midAngle", "radius", "innerRadius"].contains(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }


    // MARK: Appearance Properties

    /// Provides the center of the slice.
    @NSManaged open dynamic var center: CGPoint 

    /// Provides the angle at which to start the slice.
    @NSManaged open dynamic var minAngle: CGFloat

    /// Provides the angle at which to end the slice.
    @NSManaged open dynamic var maxAngle: CGFloat

    /// Provides the radius of the slice.
    @NSManaged open dynamic var radius: CGFloat

    /// Provides the inner radius of the segment for donut presentation.
    @NSManaged open dynamic var innerRadius: CGFloat

    /// Indicates whether the segment is clockwise or counter-clockwise oriented.
    @NSManaged open dynamic var clockwise: Bool

    /// Provides the center angle of the segment
    @objc open dynamic var midAngle: CGFloat {
        get { (minAngle + maxAngle) / 2.0 }
        set { offset(by: newValue - midAngle) }
    }


    // MARK: Layer Lifecycle

    open override func draw(in ctx: CGContext) {
        let segment = CGMutablePath()

        let minAngle = clockwise ? self.minAngle : -self.minAngle
        let maxAngle = clockwise ? self.maxAngle : -self.maxAngle
        
        if abs(maxAngle - minAngle) >= 2 * .pi {
            var path = CGMutablePath()
            path.addArc(center: center, radius: radius, startAngle: minAngle, endAngle: maxAngle, clockwise: !clockwise)
            ctx.addPath(path)

            path = CGMutablePath()
            path.addArc(center: center, radius: innerRadius, startAngle: minAngle, endAngle: maxAngle, clockwise: !clockwise)
            ctx.addPath(path)
        } else {
            var path = CGMutablePath()

            if innerRadius <= 0 {
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: minAngle, endAngle: maxAngle, clockwise: !clockwise)
            } else {
                path.addArc(center: center, radius: radius, startAngle: minAngle, endAngle: maxAngle, clockwise: !clockwise)
                if lineCap == CAShapeLayerLineCap.round {
                    let vector = CGVector(radius: (radius + innerRadius) / 2, angle: maxAngle)
                    path.addArc(center: center + vector, radius: (radius - innerRadius) / 2, startAngle: maxAngle, endAngle: maxAngle + .pi, clockwise: !clockwise)
                }

                path.addArc(center: center, radius: innerRadius, startAngle: maxAngle, endAngle: minAngle, clockwise: clockwise)
                if lineCap == CAShapeLayerLineCap.round {
                    let vector = CGVector(radius: (radius + innerRadius) / 2, angle: minAngle)
                    path.addArc(center: center + vector, radius: (radius - innerRadius) / 2, startAngle: minAngle + .pi, endAngle: minAngle, clockwise: !clockwise)
                }
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

    // MARK: Convenient Methods

    /// Offsets the segment by the given angle.
    public func offset(by angle: CGFloat) {
        minAngle += angle
        maxAngle += angle
    }
}
