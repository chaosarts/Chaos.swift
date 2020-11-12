//
//  UITimelineView.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 02.11.20.
//

import UIKit

@IBDesignable
open class UITimelineView: UIView {

    // MARK: Providing the Timeline View Data

    /// Object that provides the data for this timeline view.
    open weak var dataSource: UITimelineViewDataSource?


    // MARK: Managing Timeline View Interaction

    /// Provides the object, that act as the delegate of this view.
    open weak var delegate: UITimelineViewDelegate?


    // MARK: Getting the State of the Timeline View

    /// Provides the number of milestone contained in this timeline view.
    public var numberOfMilestones: Int { collectionView.numberOfItems(inSection: 0) }


    // MARK: Internal View Hierarchy

    /// Provides the layout for vertical presentation.
    private var verticalCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    /// Provides the layout for horizontal presentation.
    private var horizontalCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    /// The internal view, that arranges the timeline view according to the
    /// appearance properties of this timeline view.
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalCollectionViewLayout)

    /// Provides the dictionary of dequeued collection view cells due to
    /// `dequeueReusableMilestone`.
    ///
    /// When the collection view ask the timeline view for a cell, the timeline
    /// view ask its data source for a timeline milestone, where
    /// `dequeueReusableMilestone` should have been called. Therefore we preserve
    /// the collection view cell in `dequeueReusableMilestone` in this dictionary
    /// , so when returning from the data source, we can fetch this dequeued cell
    /// from this dictionary. Otherwise an error will occur, telling us, that the
    /// returned collection view cell has not been dequeued from the collection
    /// view.
    private var dequeuedMilestoneCells: [IndexPath: UITimelineViewMilestoneCell] = [:]


    // MARK: Manipulating the Appearance of the Timeline View

    /// Indicates the axis along which to arrange the milestones. Setting this
    /// value, requires to reload the data in order to take effect.
    @IBInspectable
    public dynamic var axis: NSLayoutConstraint.Axis = .vertical {
        didSet { didSetAxis() }
    }

    /// Indicates the alignment of the internal milestone views along the axis
    /// perpendicular to the axis of the timeline view.
    @IBInspectable
    public dynamic var alignment: Alignment = .leading {
        didSet { setNeedsLayout() }
    }

    /// Provides the spacing between milestones. Setting this value requires to
    /// reload the data in order to take effect.
    @IBInspectable
    public dynamic var milestoneSpacing: CGFloat {
        get { verticalCollectionViewLayout.minimumInteritemSpacing }
        set { verticalCollectionViewLayout.minimumInteritemSpacing = newValue }
    }

    /// Provides the size for the leading view of a milestone to set.
    ///
    /// This size is only used, when the alignment, perpendicular to the timeline
    /// view axis, is set to `.leading`.
    @IBInspectable
    public dynamic var leadingViewSize: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    /// Provides the size for the accessory view of a milestone to set.
    ///
    /// This size is always used for the accessory view, since the accessory has
    /// the highest priority for hugging and compression.
    @IBInspectable
    public dynamic var accessoryViewSize: CGFloat = 20 {
        didSet { setNeedsLayout() }
    }

    /// Provides the size for the trailing view of a milestone to set.
    ///
    /// This size is only used, when the alignment, perpendicular to the timeline
    /// view axis, is set to `.trailing`.
    @IBInspectable
    public dynamic var trailingViewSize: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    /// Provides the space between the leading and the accessory view of each
    /// milestone.
    @IBInspectable
    public dynamic var leadingViewSpacing: CGFloat = 8.0 {
        didSet { setNeedsLayout() }
    }

    /// Provides the space between the accessory and the trailing view of each
    /// milestone.
    @IBInspectable
    public dynamic var trailingViewSpacing: CGFloat = 8.0 {
        didSet { setNeedsLayout() }
    }


    // MARK:  Initialization

    public convenience init () {
        self.init(frame: .zero)
        prepare()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    /// Executes some default settings for this view and its internal subviews.
    /// Should be called by any init method.
    private func prepare () {
        verticalCollectionViewLayout.scrollDirection = .vertical
        verticalCollectionViewLayout.sectionInset = .zero
        horizontalCollectionViewLayout.scrollDirection = .horizontal
        horizontalCollectionViewLayout.sectionInset = .zero

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
        addConstraints(collectionView.constraintsToSuperviewEdges()!)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        verticalCollectionViewLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 50)
        horizontalCollectionViewLayout.estimatedItemSize = CGSize(width: 50, height: collectionView.bounds.height)

        collectionView.visibleCells.forEach({
            guard let milestone = ($0 as? UITimelineViewMilestoneCell)?.milestone else { return }
            milestone.axis = self.axis.perpendicular
            milestone.orthogonalAlignment = alignment
            milestone.leadingViewSize = self.leadingViewSize
            milestone.accessoryViewSize = self.accessoryViewSize
            milestone.trailingViewSize = self.trailingViewSize

            milestone.leadingViewSpacing = self.leadingViewSpacing
            milestone.trailingViewSpacing = self.trailingViewSpacing
        })

    }


    // MARK: Control Data

    /// Reloads the timeline view according to the informations of the data
    /// source.
    public func reloadData () {
        collectionView.reloadData()
    }


    // MARK: Managing reusable milestones

    /// Registers a class for use in creating new timeline view milestone.
    public func register<M: UITimelineViewMilestone> (_ type: M.Type, forMilestoneReuseIdentifier identifier: String) {
        collectionView.register(UITimelineViewMilestoneCellImpl<M>.self, forCellWithReuseIdentifier: identifier)
    }

    /// Dequeues a reusable timeline milestone object located by its identifier.
    public func dequeueReusableMilestone (withReuseIdentifier identifier: String, for index: Int) -> UITimelineViewMilestone {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
            as! UITimelineViewMilestoneCell
        dequeuedMilestoneCells[IndexPath(row: index, section: 0)] = collectionViewCell
        return collectionViewCell.milestone
    }

    public func reloadMilestones (at indices: [Int]) {
        collectionView.reloadItems(at: indices.map({ IndexPath(row: $0, section: 0) }))
    }

    public func insertMilestones (at indices: [Int]) {
        collectionView.insertItems(at: indices.map({ IndexPath(row: $0, section: 0) }))
    }

    public func deleteMilestones (_ milestone: UITimelineViewMilestone, at indices: [Int]) {
        collectionView.deleteItems(at: indices.map({ IndexPath(row: $0, section: 0) }))
    }

    public func moveMilestone (from originIndex: Int, to destinationIndex: Int) {
        collectionView.moveItem(at: IndexPath(row: originIndex, section: 0), to: IndexPath(row: destinationIndex, section: 0))
    }

    public func performUpdates (_ update: () -> Void, completion: @escaping (Bool) -> Void) {
        collectionView.performBatchUpdates(update, completion: completion)
    }

    // MARK: Control Appearance

    open func setAxis (_ axis: NSLayoutConstraint.Axis, animated: Bool = false) {
        switch axis {
        case .vertical:
            collectionView.setCollectionViewLayout(verticalCollectionViewLayout, animated: animated)
        case .horizontal:
            collectionView.setCollectionViewLayout(horizontalCollectionViewLayout, animated: animated)
        }
        setNeedsLayout()
    }

    // MARK: Handlers

    private func didSetAxis () {
        setAxis(axis, animated: true)
    }
}


// MARK: -

public extension UITimelineView {
    @objc enum Alignment: Int {
        case leading, center, trailing
    }

    @objc enum ConnectorStyle: Int {
        case solid, dashed
    }
}


// MARK: -

extension UITimelineView: UICollectionViewDataSource {

    public final func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfMilestones(self) ?? 0
    }

    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let milestone = dataSource?.timelineView(self, milestoneForItemAt: indexPath.row) else {
            fatalError("No UITimelineViewMilestone found")
        }

        milestone.axis = axis.perpendicular
        milestone.orthogonalAlignment = alignment

        milestone.leadingViewSize = leadingViewSize
        milestone.accessoryViewSize = accessoryViewSize
        milestone.trailingViewSize = trailingViewSize

        milestone.leadingViewSpacing = leadingViewSpacing
        milestone.trailingViewSpacing = trailingViewSpacing

        milestone.translatesAutoresizingMaskIntoConstraints = false

        guard let collectionViewCell = dequeuedMilestoneCells.removeValue(forKey: indexPath),
              collectionViewCell.milestone === milestone else {
            fatalError("Timeline View Milestone must be an instance created with dequeueReusableMilestone.")
        }

        return collectionViewCell
    }
}


// MARK: -

extension UITimelineView: UICollectionViewDelegateFlowLayout {
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        milestoneSpacing
    }
}
