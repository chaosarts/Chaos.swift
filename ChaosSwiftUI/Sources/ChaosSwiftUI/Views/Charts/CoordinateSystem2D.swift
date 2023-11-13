//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//
import SwiftUI
import ChaosMath

public struct CoordinateSystem2D: View {

    @State var trimProgress: CGFloat = 0

    private let graphs: [Graph2D]

    private var bounds: CGRect = .zero

    private var insets: EdgeInsets = .zero

    private var xtics: [Tic] = []

    private var ytics: [Tic] = []

//    private var tics: []

    public init(_ graphs: [Graph2D]) {
        self.graphs = graphs

        // X Bounds

        let minX = graphs.min { $0.bounds.minX < $1.bounds.minX }?.bounds.minX ?? .zero
        let maxX = graphs.max { $0.bounds.maxX < $1.bounds.maxX }?.bounds.maxX ?? .zero
        let width = maxX - minX

        // Y Bounds

        let minY = graphs.min { $0.bounds.minY < $1.bounds.minY }?.bounds.minY ?? .zero
        let maxY = graphs.max { $0.bounds.maxY < $1.bounds.maxY }?.bounds.maxY ?? .zero
        let height = maxY - minY

        self.bounds = CGRect(x: minX, y: minY, width: width, height: height)
    }

    public var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            let transform = affineTransform(in: frame)
            xaxis()
                .transform(transform)
                .stroke(Color.black, lineWidth: 1)
            yaxis()
                .transform(transform)
                .stroke(Color.black, lineWidth: 1)
            ForEach(ytics) { tic in
                Text(tic.label)
                    .offset(y: tic.position * transform.d + transform.ty - 11)
                Path { path in
                    path.move(to: CGPoint(x: bounds.minX, y: tic.position))
                    path.addLine(to: CGPoint(x: bounds.maxX, y: tic.position))
                }
                .transform(transform)
                .stroke(Color.gray, lineWidth: 1)
            }
            ForEach(graphs) { graph in
                graph
                    .trim(to: trimProgress)
                    .transform(transform)
                    .stroke(Color.black, lineWidth: 1)
                    .animation(.easeIn.delay(0.2).speed(0.3), value: trimProgress)
                    .onAppear {
                        trimProgress = 1
                    }
            }
        }
    }

    public func inset(_ insets: EdgeInsets) -> Self {
        var this = self
        this.insets = insets
        return this
    }

    public func inset(top: CGFloat? = nil,
                      bottom: CGFloat? = nil,
                      leading: CGFloat? = nil,
                      trailing: CGFloat? = nil) -> Self {
        var this = self
        this.insets.top = top ?? insets.top
        this.insets.bottom = bottom ?? insets.bottom
        this.insets.leading = leading ?? insets.leading
        this.insets.trailing = trailing ?? insets.trailing
        return this
    }

    public func range(x xrange: Range<CGFloat>? = nil, y yrange: Range<CGFloat>? = nil) -> Self {
        var this = self
        if let xrange {
            this.bounds.origin.x = xrange.lowerBound
            this.bounds.size.width = xrange.upperBound - xrange.lowerBound
        }

        if let yrange {
            this.bounds.origin.y = yrange.lowerBound
            this.bounds.size.height = yrange.upperBound - yrange.lowerBound
        }

        return this
    }

    public func tics(x xtics: [Tic]? = nil, y ytics: [Tic]? = nil) -> Self {
        var this = self
        this.xtics = xtics ?? this.xtics
        this.ytics = ytics ?? this.ytics
        return this
    }

    private func affineTransform(in frame: CGRect) -> CGAffineTransform {
        let frame = frame.insetBy(
            dx: (insets.leading + insets.trailing) / 2,
            dy: (insets.top + insets.bottom) / 2
        )
        .offsetBy(dx: insets.top, dy: insets.leading)

        let scale = CGPoint(x: frame.width / bounds.width, y: frame.height / bounds.height)

        return .identity
            .translatedBy(x: insets.leading, y: insets.top)
            .scaledBy(x: scale.x, y: -scale.y)
            .translatedBy(x: -bounds.minX, y: -bounds.minY)
            .translatedBy(x: 0, y: -bounds.height)
    }

    private func xaxis() -> Path {
        Path { path in
            path.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        }
    }

    private func yaxis() -> Path {
        Path { path in
            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        }
    }
}

extension CoordinateSystem2D {
    public struct Tic: Identifiable {
        public var id: String { label }
        public let label: String
        public let position: CGFloat
        public init(label: String, position: CGFloat) {
            self.label = label
            self.position = position
        }
    }

    public enum Space {
        case data
        case pixel
    }
}


#Preview {
    let graphs = [
        Graph2D(
            (1..<101).map {
                let y = log(CGFloat($0))
                let random = CGFloat(Float.random(in: 0..<50)) * 0.01
                return CGPoint(x: CGFloat($0) * 20, y: y + random)
            }
        ),
        Graph2D(
            (1..<101).map {
                let y = log(CGFloat($0)) * 0.5
                let random = CGFloat(Float.random(in: 0..<10)) * 0.02
                return CGPoint(x: CGFloat($0) * 20, y: y + random)
            }
        )
    ]
    let padding = EdgeInsets(top: 0, leading: 50, bottom: 50, trailing: 0)
    return CoordinateSystem2D(graphs)
        .inset(leading: 20)
        .range(x: -2..<2104)
        .tics(
            y: [
                .init(label: "1", position: 1.5),
                .init(label: "2", position: 3)
            ]
        )
        .frame(height: 300)
        .background(Color.red.opacity(0.1))
        .padding()
}
