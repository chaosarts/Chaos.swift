//
//  UITimelineViewMilestoneCell.swift
//  Chaos
//
//  Created by Fu Lam Diep on 04.11.20.
//

import Foundation

internal protocol UITimelineViewMilestoneCellProtocol {
    var milestone: UITimelineViewMilestone { get }
}

internal typealias UITimelineViewMilestoneCell = UITimelineViewMilestoneCellProtocol & UICollectionViewCell


internal class UITimelineViewMilestoneCellImpl<M: UITimelineViewMilestone>: UITimelineViewMilestoneCell {

    let milestone: UITimelineViewMilestone = M.init()


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

    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        let calculated = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        switch milestone.axis {
        case .horizontal:
            targetSize.height = calculated.height
        case .vertical:
            targetSize.width = calculated.width
        }
        return targetSize
    }
}
