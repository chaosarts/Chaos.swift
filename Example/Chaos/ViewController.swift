//
//  ViewController.swift
//  Chaos
//
//  Created by [1;35;40m[Kacct[m[K<blob>=chaosarts on 10/17/2020.
//  Copyright (c) 2020 [1;35;40m[Kacct[m[K<blob>=chaosarts. All rights reserved.
//

import UIKit
import Chaos

class ViewController: UIViewController, UITimelineViewDataSource,
                      UITimelineViewDelegate {

    @IBOutlet
    private weak var timelineView: UITimelineView?

    private var items: [(date: Date, uuid: UUID)] = [(Date(), UUID()), (Date(), UUID()), (Date(), UUID())]

    private var dateFormatter: DateFormatter = DateFormatter()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timelineView?.delegate = self
        timelineView?.dataSource = self
        timelineView?.register(UITimelineViewMilestone.self, forMilestoneReuseIdentifier: "Default")
        timelineView?.alignment = .leading
        timelineView?.reloadData()

        dateFormatter.dateFormat = "HH:mm:ss"

        drawBezier()
    }

    func drawBezier () {
        let mainPath = UIBezierPath()
        for index in 0..<4 {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 3.0 * (1.0 + 2.5 * CGFloat(index))), radius: 3, startAngle: 0, endAngle: 2.0 * .pi, clockwise: true)
            mainPath.append(circlePath)
        }

        let shapeLayer = CAShapeLayer(layer: view.layer)
        shapeLayer.path = mainPath.cgPath
        shapeLayer.frame = CGRect(x: 100, y: 200, width: 6, height: 4 * 6 + 3 * 0.2)
        shapeLayer.fillColor = UIColor.black.cgColor

        view.layer.addSublayer(shapeLayer)
    }

    func numberOfMilestones(_ timelineView: UITimelineView) -> Int {
        items.count
    }

    func timelineView(_ timelineView: UITimelineView, milestoneForItemAt index: Int) -> UITimelineViewMilestone {
        let timelineViewMilestone = timelineView.dequeueReusableMilestone(withReuseIdentifier: "Default", for: index)

        let item = items[index]

        let leadingView = UILabel()
        leadingView.textAlignment = .right
        leadingView.text = dateFormatter.string(from: item.date)
        leadingView.lineBreakMode = .byTruncatingHead

        let trailingView = UILabel()
        trailingView.textAlignment = .left
        trailingView.text = item.uuid.uuidString
        trailingView.lineBreakMode = .byTruncatingTail

        timelineViewMilestone.leadingView = leadingView
        timelineViewMilestone.trailingView = trailingView

        timelineViewMilestone.accessoryView = UIImageView(image: UIImage(named: "Test"))
        timelineViewMilestone.accessoryView?.contentMode = .scaleAspectFit

        timelineView.alignment = .leading
        return timelineViewMilestone
    }

    @IBAction
    func didTapButton (sender: UIButton) {
        guard let timelineView = timelineView else { return }
        items.insert((Date(), UUID()), at: 0)
        timelineView.insertMilestones(at: [0])
    }
}

