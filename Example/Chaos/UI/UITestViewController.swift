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


    public override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.dataSource = self
        pieChart.frame = CGRect(x: 50, y: 400, width: 100, height: 100)
        pieChart.innerRadius = 45
        pieChart.spacing = .radian(10)
        view.addSubview(pieChart)
        pieChart.reloadData()
    }

    @IBAction private func didTouchDownButton () {
        pieChart.reloadData()
    }

    public func numberOfSegments(_ piaChart: UIPieChart) -> Int { 5 }

    public func pieChart(_ pieChart: UIPieChart, valueForSegmentAt index: Int) -> Double {
        return 1
    }

    public func pieChart(_ pieChart: UIPieChart, colorForSegmentAt index: Int) -> UIColor {
        let gray = CGFloat(index) / 5.0
        return UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
    }
}
