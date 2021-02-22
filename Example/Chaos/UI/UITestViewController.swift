//
//  UITestViewController.swift
//  Chaos_Example
//
//  Created by Fu Lam Diep on 30.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ChaosCore
import ChaosAnimation
import ChaosUi
import QuartzCore

public class UITestViewController: UIViewController, UIPieChartDataSource {

    private var pieChart: UIPieChart = UIPieChart()

    private var values: [Double] = [1, 2, 3, 4, 5]
    private var colors: [UIColor] = [.systemBlue, .systemRed, .systemGray, .systemTeal, .systemGreen]

    public override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.dataSource = self
        pieChart.frame = CGRect(x: 50, y: 400, width: 100, height: 100)
        pieChart.innerRadius = 40
        view.addSubview(pieChart)
        pieChart.reloadData()
    }

    @IBAction private func didTouchDownButton () {
        let index = Int.random(in: 0..<values.count)
        values[index] = 1 * pieChart.totalValue
        pieChart.reloadSegments(at: [index], animated: true)
    }

    public func numberOfSegments(_ piaChart: UIPieChart) -> Int { 5 }

    public func pieChart(_ pieChart: UIPieChart, valueForSegmentAt index: Int) -> Double {
        values[index]
    }

    public func pieChart(_ pieChart: UIPieChart, colorForSegmentAt index: Int) -> UIColor {
        colors[index]
    }
}
