//
//  UIPieChart.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 10.02.21.
//

import UIKit
import ChaosAnimation

@IBDesignable
open class UIPieChart: UIView {

    @objc public enum ValueDisplayType: Int {
        case relative, absolute, both
    }

    // MARK: Data and Delegate

    /// Provides information about the chart data.
    @IBOutlet public weak var dataSource: UIPieChartDataSource?

    /// Provides the delegate of this pie chart
    @IBOutlet public weak var delegate: UIPieChartDelegate?

    /// Provides the list of segments to render. Segment objects are generated by
    /// loading
    private var segments: [Segment] = []

    /// Provides the number of segments contained in the pie chart.
    public var numberOfSegments: Int { return segments.count }

    // MARK: Appearance Properties

    /// Provides the angle in the chart at which the first segment should start
    @IBInspectable open dynamic var startAngle: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable open dynamic var spacing: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }

    /// Indicates whether the segments are clockwise or counter-clockwise oriented.
    @IBInspectable open dynamic var clockwise: Bool = true {
        didSet { setNeedsDisplay() }
    }

    /// Indicates what to display on the labels of the segments.
    @IBInspectable open dynamic var valueDisplayType: ValueDisplayType = .relative {
        didSet { setNeedsDisplay() }
    }

    /// Specifies the precision on displaying the relative value of a sgement.
    @IBInspectable open dynamic var relativeValuePrecision: Int = 2 {
        didSet { setNeedsDisplay() }
    }

    /// Specifies the precision when displaying the absolute value of segment.
    @IBInspectable open dynamic var absoluteValuePrecision: Int = 2 {
        didSet { setNeedsDisplay() }
    }

    /// Specifies the unit to display beside the absolute value.
    @IBInspectable open dynamic var absoluteValueUnit: String = "" {
        didSet { setNeedsDisplay() }
    }

    /// Provides the inner radius of the pie chart. Values greater than zero
    /// result in a donut chart.
    @IBInspectable open dynamic var innerRadius: CGFloat = .zero {
        didSet { setNeedsDisplay() }
    }

    /// Provides the thickness of the donut. This value is an implicit value. It
    /// is calculated by the radius and inner radius of the chart. Setting this
    /// value implicitly changes the inner radius.
    open dynamic var donutThickness: CGFloat {
        get { radius - innerRadius }
        set { innerRadius = radius - newValue }
    }

    /// Provides the outer radius of the pie chart.
    public var radius: CGFloat {
        return min(bounds.width, bounds.height) / 2
    }


    // MARK: Internal Properties

    /// Provides the format string for relative values.
    private var relativeValueFormat: String { return "%f.\(relativeValuePrecision)%" }

    /// Provides the format string for absolute values.
    private var absoluteValueFormat: String { return "%f.\(absoluteValuePrecision)\(absoluteValueUnit)" }

    /// Provides the layer added to the root layer displaying the segments
    private var circleSegmentLayers: [CACircleSegmentLayer] = []


    // MARK: Data Control

    /// Reloads the data from data source and invokes the view to draw the
    /// segments. Call this function after setting the data source or when the
    /// data source has changed.
    public func reloadData () {
        segments = []
        while circleSegmentLayers.count > 0 {
            circleSegmentLayers.removeFirst().removeFromSuperlayer()
        }
        guard let dataSource = dataSource else { return }
        segments = collectData(from: dataSource)
        circleSegmentLayers = segments.map({ segment -> CACircleSegmentLayer in
            let layer = CACircleSegmentLayer()
            self.layer.addSublayer(layer)
            return layer
        })
        setNeedsDisplay()
    }

    /// Separate function to collect data from the data source and return a list
    /// of objects containing information for each segment to draw.
    private func collectData (from dataSource: UIPieChartDataSource) -> [Segment] {
        let numberOfSegments = dataSource.numberOfSegments(self)

        var values: [Double] = []
        for index in 0..<numberOfSegments {
            values.append(dataSource.pieChart(self, valueForSegmentAt: index))
        }

        let totalValue = values.reduce(0.0, { $0 + $1 })
        var startAngle: CGFloat = self.startAngle
        return values.enumerated().map({ index, value -> Segment in
            let segment = Segment()
            segment.title = dataSource.pieChart?(self, titleForSegmentAt: index)
            segment.color = dataSource.pieChart(self, colorForSegmentAt: index)
            segment.absoluteValue = value
            segment.relativeValue = value / totalValue
            segment.startAngle = startAngle
            startAngle = segment.endAngle
            return segment
        })
    }


    // MARK: Draw and Display Control

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        for index in 0..<segments.count {
            updateSegmentLayer(at: index, forFrame: rect)
            let segment = segments[index]
            layer.frame = rect
            layer.isHidden = segment.isHidden
            layer.setNeedsDisplay()
        }
    }

    private func updateSegmentLayer (at index: Int, forFrame frame: CGRect) {
        let segment = segments[index]
        let layer = circleSegmentLayers[index]

        let offsetAngle = spacing / 2.0
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let radius = min(frame.width, frame.height) / 2.0

        layer.center = center
        layer.clockwise = clockwise
        layer.radius = radius
        layer.innerRadius = innerRadius

        layer.startAngle = segment.startAngle + offsetAngle
        layer.endAngle = segment.endAngle - offsetAngle
        layer.fillColor = segment.color.cgColor
    }
}

