//
//  UIPieChart.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 10.02.21.
//

import UIKit
import ChaosAnimation

@IBDesignable
open class UIPieChart: UIView, CAAnimationDelegate {

    // MARK: Data and Delegate

    /// Provides information about the chart data.
    @IBOutlet public weak var dataSource: UIPieChartDataSource?

    /// Provides the delegate of this pie chart
    @IBOutlet public weak var delegate: UIPieChartDelegate?

    /// Provides the list of segments to render. Segment objects are generated by
    /// loading. Segments contain the ground truth data.
    private var segments: [SegmentData] = []

    /// Provides the number of segments contained in the pie chart.
    public var numberOfSegments: Int { return segments.count }

    /// Calculates the total value of all segments contained in this chart.
    public var totalValue: Double { segments.reduce(0.0, { $0 + $1.value }) }

    /// Provides the list of segment values relative to the total value.
    private var relativeValues: [Double] {
        let totalValue = self.totalValue
        return segments.map({ $0.value / totalValue })
    }

    /// Provides the start angle of each
    private var startAngles: [CGFloat] {
        let fullCircle: CGFloat = .pi * 2.0
        var lastValue: CGFloat = 0
        var angles: [CGFloat] = []
        for value in relativeValues {
            let angle = lastValue * fullCircle
            lastValue += CGFloat(value)
            angles.append(angle)
        }
        return angles
    }

    private var endAngles: [CGFloat] {
        let fullCircle: CGFloat = .pi * 2.0
        var lastValue: CGFloat = 0
        var angles: [CGFloat] = []
        for value in relativeValues {
            let angle = lastValue + CGFloat(value) * fullCircle
            lastValue = angle
            angles.append(angle)
        }
        return angles
    }

    private var colors: [UIColor] {
        segments.map({ $0.color })
    }

    // MARK: Appearance Properties

    /// Provides the angle in the chart at which the first segment should start
    @IBInspectable open dynamic var startAngle: CGFloat = 0.0

    /// Indicates whether the segments are clockwise or counter-clockwise oriented.
    @IBInspectable open dynamic var clockwise: Bool = true

    /// Provides the inner radius of the pie chart. Values greater than zero
    /// result in a donut chart.
    @IBInspectable open dynamic var innerRadius: CGFloat = .zero

    /// Provides the thickness of the donut. This value is an implicit value. It
    /// is calculated by the radius and inner radius of the chart. Setting this
    /// value implicitly changes the inner radius.
    open dynamic var donutThickness: CGFloat {
        get { radius - innerRadius }
        set { innerRadius = radius - newValue }
    }

    /// Provides the outer radius of the pie chart.
    public var radius: CGFloat { min(bounds.width, bounds.height) / 2 }

    /// Provides the center of the chart within the bounds of this view
    public var chartCenter: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }


    // MARK: Internal Properties

    /// Provides the layer added to the root layer displaying the segments
    private var segmentLayers: [CACircleSegmentLayer] = []


    // MARK: Initialisation

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    private func prepare () {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }


    // MARK: Lifecycle

    open override func layoutSubviews() {
        super.layoutSubviews()

        let frame = bounds
        let center = chartCenter
        let radius = self.radius

        segmentLayers.forEach({
            $0.frame = frame
            $0.center = center
            $0.radius = radius
            $0.clockwise = self.clockwise
            $0.innerRadius = self.innerRadius
        })
    }


    // MARK: Data Control

    /// Reloads the data from data source and invokes the view to draw the
    /// segments. Call this function after setting the data source or when the
    /// data source has changed.
    public func reloadData (animated: Bool = false) {
        let numberOfSegments = dataSource?.numberOfSegments(self) ?? 0
        while numberOfSegments > segments.count {
            segments.append(SegmentData())

            let sublayer = CACircleSegmentLayer()
            segmentLayers.append(sublayer)
            layer.addSublayer(sublayer)
        }

        while numberOfSegments < segments.count {
            segments.removeFirst()
            segmentLayers.removeFirst().removeFromSuperlayer()
        }

        if let dataSource = dataSource {
            for index in 0..<numberOfSegments {
                reloadSegmentData(at: index, from: dataSource)
                segmentLayers[index].minAngle = 0.0
                segmentLayers[index].maxAngle = 0.0
            }

            if totalValue == 0.0 {
                fatalError("The total value of all segments must be greater than 0.")
            }

            reloadSegmentLayers(animated: animated)
        }

        layer.setNeedsDisplay()
    }

    /// Reloads the segment data for the given index from given data source.
    /// - Parameter index: The index for which to reload the data
    /// - Parameter dataSource: The data source from which to fetch the data
    private func reloadSegmentData (at index: Int, from dataSource: UIPieChartDataSource) {
        let segment = segments[index]

        let value = dataSource.pieChart(self, valueForSegmentAt: index)
        guard value >= 0.0 else { fatalError("Value for segment (\(index)) nust not be negative.") }

        segment.value = value
        segment.title = dataSource.pieChart?(self, titleForSegmentAt: index)
        segment.color = dataSource.pieChart(self, colorForSegmentAt: index)
    }


    // MARK: View Control

    /// Inserts a new segment from the data source at given indices.
    open func insertSegment (at indices: [Int], animated: Bool) {
        guard let dataSource = dataSource else {
            fatalError("No data source set for pie chart.")
        }

        let numberOfSegments = dataSource.numberOfSegments(self)
        guard segments.count + indices.count == numberOfSegments else {
            fatalError("The number of existing values (\(segments.count)) " +
                        "plus the number of values to insert " +
                        "(\(indices.count)) must be equal to the number of " +
                        "values in the data source (\(numberOfSegments)).")
        }

        let startAngles = self.startAngles

        indices.sorted().forEach({
            segments.insert(SegmentData(), at: $0)
            reloadSegmentData(at: $0, from: dataSource)

            segmentLayers.insert(CACircleSegmentLayer(), at: $0)
            segmentLayers[$0].minAngle = startAngles[$0]
            segmentLayers[$0].maxAngle = startAngles[$0]
        })

        reloadSegmentLayers(animated: animated)
    }

    /// Removes the segment from the chart at given index.
    open func deleteSegment (at indices: [Int]) {
        guard let dataSource = dataSource else {
            fatalError("No data source set for pie chart.")
        }

        let numberOfSegments = dataSource.numberOfSegments(self)
        guard segments.count - indices.count == numberOfSegments else {
            fatalError("The number of existing values (\(segments.count)) " +
                        "minus the number of values to remove " +
                        "(\(indices.count)) must be equal to the number of " +
                        "values in the data source (\(numberOfSegments)).")
        }


    }

    /// Iterates through the segment layers and updates their appearance
    /// corresponding to the segment data in this pie chart.
    private func reloadSegmentLayers (animated: Bool) {
        let startAngles = self.startAngles
        let endAngles = self.endAngles
        segmentLayers.enumerated()
            .forEach({
                self.transform(layer: $0.element,
                               toMinAngle: startAngles[$0.offset],
                               maxAngle: endAngles[$0.offset],
                               animated: animated)
            })
    }

    private func transform (layer: CACircleSegmentLayer, toMinAngle minAngle: CGFloat, maxAngle: CGFloat, animated: Bool) {
        if animated {
            let animation = CAAnimationGroup()
            animation.animations = CABasicAnimation.animations(for: layer, toValues: ["minAngle": minAngle, "maxAngle": maxAngle])
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.2, 1)
            animation.duration = 0.5
            animation.isRemovedOnCompletion = true
            layer.add(animation, forKey: "animation")
        }

        layer.minAngle = minAngle
        layer.maxAngle = maxAngle
    }



    // MARK: State Methods

    /// Returns the title for the value of the segment at given index.
    public func title (at index: Int) -> String? {
        return segments[index].title
    }

    /// Returns the absolute value of the segment at given index.
    public func value (at index: Int) -> Double {
        return segments[index].value
    }

    /// Returns the relative value of the segment at given index.
    public func relativeValue (at index: Int) -> Double {
        return segments[index].value / totalValue
    }

    /// Returns the relative value of the segment at given index.
    public func color (at index: Int) -> UIColor {
        return segments[index].color
    }

    /// Returns the start angle of the segment at given index
    public func startAngle (at index: Int) -> CGFloat {
        CGFloat((0..<index).reduce(0.0, { $0 + self.relativeValue(at: $1) })) * .pi * 2.0
    }

    /// Returns the end angle of the segment at given index
    public func endAngle (at index: Int) -> CGFloat {
        startAngle(at: index) + CGFloat(relativeValue(at: index)) * .pi * 2.0
    }

    /// Returns the index of the segment for which the angle is greater or equal
    /// the start angle and less than the end angle.
    public func index (ofAngle angle: CGFloat) -> Int {
        let rad360 = CGFloat.pi * 2
        let angle = angle - floor(angle / rad360) * rad360

        let startAngles = self.startAngles
        let endAngles = self.endAngles

        var output: Int = -1
        for index in 0..<numberOfSegments {
            guard startAngles[index] <= angle, endAngles[index] > angle else {
                continue
            }
            output = index
            break
        }
        return output
    }


    // MARK: Interaction

    @objc private func didTap (_ tapGesutreRecognizer: UITapGestureRecognizer) {
        let point = tapGesutreRecognizer.location(in: self)
        let distance = point.distance(to: chartCenter)
        guard distance <= radius && distance >= innerRadius else { return }

        let v1 = CGVector(from: chartCenter, to: point)
        guard v1.length > 0 else { return }

        let v2 = CGVector(dx: 1, dy: 0)

        var angle = v2.angle(other: v1)
        if point.y < chartCenter.y {
            angle = 2 * .pi - angle
        }

        delegate?.pieChart?(self, didSelectSegmentAt: index(ofAngle: angle))
    }
}

