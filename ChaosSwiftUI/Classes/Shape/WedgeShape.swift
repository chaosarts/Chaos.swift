//
//  WedgeShape.swift
//  ChaosSwiftUI
//
//  Created by Fu Lam Diep on 09.10.21.
//

import SwiftUI

public struct WedgeShape: Shape {

    public var center: CGPoint = .zero

    public var startAngle: CGFloat = .zero

    public var endAngle: CGFloat = .zero

    public var radius: CGFloat = 50

    public var innerRadius: CGFloat = 0

    public var clockwise: Bool = true

    public var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(AnimatablePair(startAngle, endAngle), AnimatablePair(radius, innerRadius))
        }
        set {
            startAngle = newValue.first.first
            endAngle = newValue.first.second
            radius = newValue.second.first
            innerRadius = newValue.second.second
        }
    }

    public func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: Angle(radians: Double(startAngle)),
                        endAngle: Angle(radians: Double(endAngle)),
                        clockwise: !clockwise)

            path.addArc(center: center,
                        radius: innerRadius,
                        startAngle: Angle(radians: Double(endAngle)),
                        endAngle: Angle(radians: Double(startAngle)),
                        clockwise: clockwise)
            path.closeSubpath()
        }
    }
}

struct WedgeShape_Previews: PreviewProvider {
    static var previews: some View {
        WedgeShape(endAngle: .pi)
    }
}
