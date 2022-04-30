//
//  PieChartView.swift
//  ChaosSwiftUI
//
//  Created by Fu Lam Diep on 08.10.21.
//

import SwiftUI
import ChaosCore
import ChaosGraphics

public struct PieChartView: View {

    public struct Segment: Identifiable {
        public var id = UUID().uuidString
        public var value: CGFloat
        public var visible: Bool = true
        public var color: Color = .black

        public init (id: String = UUID().uuidString,
                     value: CGFloat,
                     visible: Bool = true,
                     color: Color = .black) {
            self.id = id
            self.value = value
            self.visible = visible
            self.color = color
        }

        static var zero: Segment { Segment(value: 0, visible: true, color: .clear) }
    }

    @Binding public var segments: [Segment]

    private var radius: CGFloat = 50

    private var innerRadius: CGFloat = 0

    private var startAngle: CGFloat = .circleTopAngle

    private var clockwise: Bool = true

    private var totalValue: CGFloat { segments.map({ $0.value }).sum }

    private var angles: [CGFloat] {
        let totalValue = totalValue

        guard totalValue > 0 else { return [] }

        let doublePi = 2 * CGFloat.pi
        let radiansPerPercent = 1 / totalValue * doublePi

        var angle = startAngle
        var angles: [CGFloat] = [angle]

        for segment in segments.filter({ $0.visible }) {
            angle += segment.value * radiansPerPercent
            angles.append(angle)
        }

        return angles
    }

    public init (segments: Binding<[Segment]>) {
        self._segments = segments
    }

    public var body: some View {
        ZStack {
            let center = CGPoint(x: radius, y: radius)
            let size = 2 * radius
            var angles = angles
            let segments = segments.filter { $0.visible }
            ForEach(segments) { segment in
                let startAngle = angles.removeFirst()
                WedgeShape(center: center,
                           startAngle: startAngle,
                           endAngle: angles[0],
                           radius: radius,
                           innerRadius: innerRadius,
                           clockwise: clockwise)
                    .fill(segment.color)
                    .frame(width: size, height: size, alignment: .center)
            }
        }
    }

    public func radius (_ radius: CGFloat) -> Self {
        var pie = self
        pie.radius = radius
        return pie
    }

    public func innerRadius (_ innerRadius: CGFloat) -> Self {
        var pie = self
        pie.innerRadius = innerRadius
        return pie
    }

    public func startAngle (_ startAngle: CGFloat) -> Self {
        var pie = self
        pie.startAngle = startAngle
        return pie
    }

    public func clockwise (_ clockwise: Bool) -> Self {
        var pie = self
        pie.clockwise = clockwise
        return pie
    }
}

// MARK: - Preview

public struct PieChartView_Preview: PreviewProvider {
    public static var previews: some View {
        PieChartView(segments: .constant([]))
            .radius(10)
            .innerRadius(1)
    }
}


