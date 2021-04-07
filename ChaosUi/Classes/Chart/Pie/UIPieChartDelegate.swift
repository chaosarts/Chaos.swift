//
//  UIPieChartDelegate.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 13.02.21.
//

import Foundation

@objc public protocol UIPieChartDelegate: class {
    @objc optional func pieChart (_ pieChart: UIPieChart, didSelectSegmentAt index: Int)
}
