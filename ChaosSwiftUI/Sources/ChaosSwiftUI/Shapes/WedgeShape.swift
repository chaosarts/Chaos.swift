//
//  WedgeShape.swift
//  ChaosSwiftUI
//
//  Created by Fu Lam Diep on 09.10.21.
//

import SwiftUI

public struct WedgeShape: Shape {

    public typealias AnimatableData = AnimatablePair<AnimatablePair<Angle, Angle>, CGFloat>

    public var startAngle: Angle

    public var endAngle: Angle

    public var innerRadius: CGFloat

    public let clockwise: Bool

    public var animatableData: AnimatableData {
        get { 
            AnimatablePair(
                AnimatablePair(startAngle, endAngle),
                innerRadius
            )
        }
        set {
            startAngle = newValue.first.first
            endAngle = newValue.first.second
            innerRadius = newValue.second
        }
    }

    public init(from startAngle: Angle = .zero,
                to endAngle: Angle = .zero,
                innerRadius: CGFloat = 0,
                clockwise: Bool = true) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.innerRadius = innerRadius
        self.clockwise = clockwise
    }

    public func path(in rect: CGRect) -> Path {
        return Path { path in
            let radius = min(rect.width, rect.height) / 2
            let center = CGPoint(x: rect.minX + rect.width / 2,
                                 y: rect.minY + rect.height / 2)
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: !clockwise)

            if innerRadius > 0 {
                path.addArc(center: center,
                            radius: innerRadius,
                            startAngle: endAngle,
                            endAngle: startAngle,
                            clockwise: clockwise)
            }
            path.addLine(to: center)
            path.closeSubpath()
        }
    }
}

#Preview {
    struct ExampleView: View {
        @State var isExpanded = false

        var body: some View {
            ZStack {
                Button("Press me") {
                    isExpanded.toggle()
                }
                WedgeShape(from: .east,
                           to: isExpanded ? .east + .degrees(360) : .south,
                           innerRadius: isExpanded ? 150 : 50)
                    .animation(.easeInOut, value: isExpanded)
            }
        }
    }

    return ExampleView()
}
