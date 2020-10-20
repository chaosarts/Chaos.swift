//
//  UITimelineViewDataSource.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 17.10.20.
//

import Foundation

public protocol UITimelineViewDataSource: class {
    func numberOfMilestones (_ timelineView: UITimelineView) -> Int
    func timelineView (_ timelineView: UITimelineView, milestoneAt index: Int) -> UITimelineMilestone
}
