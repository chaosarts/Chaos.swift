//
//  UITimelineViewMilestoneCell.swift
//  Chaos
//
//  Created by Fu Lam Diep on 04.11.20.
//

import UIKit

/// Defines a protocol that requires to have a milestone property.
internal protocol UITimelineViewMilestoneCellProtocol: AnyObject, NSObjectProtocol {
    var milestone: UITimelineViewMilestone { get }
}

/// Defines a collection view that requires to implement the
/// `UITimlineViewMilestoneCellProtocoll`.
internal typealias UITimelineViewMilestoneCell = UITimelineViewMilestoneCellProtocol & UICollectionViewCell


// MARK: -

/// A collection view cell class that implements the
/// `UITimelineViewMilestoneCellProtocol` and used for the internal collection
/// view of the timeline.
///
/// In order to register different milestone classes as reusable in the timeline
/// view, this implementation uses generics.
internal class UITimelineViewMilestoneCellImpl<Milestone: UITimelineViewMilestone>: UITimelineViewMilestoneCell {

    // MARK: Properties

    /// Provides the milestone, that is contained within the collection view cell.
    let milestone: UITimelineViewMilestone = Milestone.init()


    // MARK: Initialization

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    private func prepare () {
        milestone.translatesAutoresizingMaskIntoConstraints = false
        addSubview(milestone)
        addConstraints(milestone.constraintsToSuperviewEdges()!)
    }

    // MARK: Layout Methods
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        let calculated = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        switch milestone.axis {
        case .horizontal:
            targetSize.height = calculated.height
        case .vertical:
            targetSize.width = calculated.width
        @unknown default:
            fatalError("Unknown NSLayoutConstraint.Axis")
        }
        return targetSize
    }
}
