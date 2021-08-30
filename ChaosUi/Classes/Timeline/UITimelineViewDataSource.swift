//
//  UITimelineViewDataSource.swift
//  Chaos
//
//  Created by Fu Lam Diep on 06.11.20.
//

import UIKit

/// Protocol to describe a data source for a timeline view.
@objc public protocol UITimelineViewDataSource: AnyObject, NSObjectProtocol {

    /// Asks the data source for the total number of milestones it keeps.
    @objc func numberOfMilestones (_ timelineView: UITimelineView) -> Int

    /// Asks the data source for the milestone for the item at given index.
    ///
    /// The implementing class must dequeue a milestone from the timeline view and
    /// configure it. Otherwise the timeline view invokes an fatal error.
    @objc func timelineView (_ timelineView: UITimelineView, milestoneForItemAt index: Int) -> UITimelineViewMilestone

    @objc optional func timelineView (_ timelineView: UITimelineView, connectorForItemAt index: Int) -> UITimelineViewConnector?
}
