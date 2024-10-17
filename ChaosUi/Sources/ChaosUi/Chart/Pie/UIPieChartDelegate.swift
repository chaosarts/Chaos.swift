#if canImport(UIKit)
//
//  UIPieChartDelegate.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 13.02.21.
//

import Foundation

@objc public protocol UIPieChartDelegate: AnyObject {
    @objc optional func pieChart (_ pieChart: UIPieChart, didSelectSegmentAt index: Int)
}

#endif