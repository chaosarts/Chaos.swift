//
//  UITimelineView.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 02.11.20.
//

import UIKit

@objc open class UITimelineView: UIView {

    /// Provides the object, that serves the list of milestones to the timeline
    /// view.
    open weak var dataSource: UITimelineViewDataSource?

    /// Provides the collection view, that displays the milestones
    private var collectionView: UICollectionView = UICollectionView()


    // MARK:  Initialization

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    private func prepare () {
        collectionView.dataSource = self
        collectionView.register(UITimelineViewMilestone.self, forCellWithReuseIdentifier: "Default")
    }


    // MARK: Managing reusable milestones

    public func register (_ type: UITimelineViewMilestone.Type, forMilestoneReuseIdentifier identifier: String) {
        collectionView.register(type, forCellWithReuseIdentifier: identifier)
    }

    public func dequeueReusableMilestone (withReuseIdentifier identifier: String, for index: Int) -> UITimelineViewMilestone? {
        collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0)) as? UITimelineViewMilestone
    }


    // MARK: Control Data

    public func reloadData () {
        collectionView.reloadData()
    }
}


// MARK: -

extension UITimelineView: UICollectionViewDataSource {
    final public func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    final public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfMilestones(self) ?? 0
    }

    final public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let milestone = dataSource?.timelineView(self, milestoneForItemAt: indexPath.row) else {
            fatalError("No UITimelineViewMilestone found")
        }
        return milestone
    }
}


@objc public protocol UITimelineViewDataSource: class, NSObjectProtocol {
    func numberOfMilestones (_ timelineView: UITimelineView) -> Int
    func timelineView (_ timelineView: UITimelineView, milestoneForItemAt index: Int) -> UITimelineViewMilestone
}
