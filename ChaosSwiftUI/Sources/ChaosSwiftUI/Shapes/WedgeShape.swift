//
//  WedgeShape.swift
//  ChaosSwiftUI
//
//  Created by Fu Lam Diep on 09.10.21.
//

import SwiftUI

public struct WedgeShape: Shape {

    public let center: CGPoint

    public var startAngle: Double

    public var endAngle: Double

    public var radius: CGFloat

    public var innerRadius: CGFloat

    public let clockwise: Bool

    public var animatableData: AnimatablePair<AnimatablePair<Double, Double>, AnimatablePair<CGFloat, CGFloat>> {
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

    public init(center: CGPoint = .zero,
                startAngle: Double = .zero,
                endAngle: Double = .zero,
                radius: CGFloat = 50,
                innerRadius: CGFloat = 0,
                clockwise: Bool = true) {
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.innerRadius = innerRadius
        self.clockwise = clockwise
    }

    public func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: Angle(radians: startAngle),
                        endAngle: Angle(radians: endAngle),
                        clockwise: !clockwise)

            path.addArc(center: center,
                        radius: innerRadius,
                        startAngle: Angle(radians: endAngle),
                        endAngle: Angle(radians: startAngle),
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
