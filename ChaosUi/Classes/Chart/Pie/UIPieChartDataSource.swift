//
//  UIPieChartDataSource.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 10.02.21.
//

import UIKit

/// A protocol describing the data source for a pie chart view.
@objc public protocol UIPieChartDataSource: class {

    /// Asks the the data source for the number of segments to draw in the pie
    /// chart.
    /// - parameter pieChart: The pie chart view asking for the value.
    /// - returns: The number of segments to draw.
    func numberOfSegments (_ piaChart: UIPieChart) -> Int

    /// Asks the data source for the value of the segment at the given index.
    /// - parameter pieChart: The pie chart view asking for the value.
    /// - parameter index: Specifies the index of the segment.
    /// - returns: The value of the segment
    func pieChart (_ pieChart: UIPieChart, valueForSegmentAt index: Int) -> Double

    /// Asks the data source for the color of the segment at given index.
    /// - parameter pieChart: The pie chart view asking for the color.
    /// - parameter index: Specifies the index of the segment.
    /// - returns: The color of the segment
    func pieChart (_ pieChart: UIPieChart, colorForSegmentAt index: Int) -> UIColor

    /// Asks the data source for the title of the segment at given index.
    /// - parameter pieChart: The pie chart view asking for the title.
    /// - parameter index: Specifies the index of the segment.
    /// - returns: The title of the segment
    @objc optional func pieChart (_ pieChart: UIPieChart, titleForSegmentAt index: Int) -> String?
}
