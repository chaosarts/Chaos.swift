//
//  UITimelineView.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 17.10.20.
//

import Foundation

private let kUITimelineViewCellReuseIdentfier = UUID().uuidString
private let kContentHeightConstraint: String = "ContentHeightConstraint"
private let kContentWidthConstraint: String = "ContentWidthConstraint"

@IBDesignable
open class UITimelineView: UIView {


    // MARK: Appearance

    @IBInspectable
    public dynamic var axis: Axis = .vertical


    // MARK: Helpers

    public weak var dataSource: UITimelineViewDataSource?

    public weak var delegate: UITimelineViewDelegate?


    // MARK: Subview and Layout Porperties

    private var collectionView: UICollectionView = UICollectionView()


    // MARK: Initialization

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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        addConstraints([
            topAnchor.constraint(equalTo: collectionView.topAnchor),
            rightAnchor.constraint(equalTo: collectionView.rightAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            leftAnchor.constraint(equalTo: collectionView.leftAnchor)
        ])

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kUITimelineViewCellReuseIdentfier)
    }
}


// MARK: - Nested Types

public extension UITimelineView {
    public typealias Axis = NSLayoutConstraint.Axis

    @objc
    public enum Alignment: Int {
        case leading
        case center
        case trailing
    }
}


extension UITimelineView: UICollectionViewDataSource {

    public final func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfMilestones(self) ?? 0
    }

    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else { return UICollectionViewCell() }
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kUITimelineViewCellReuseIdentfier, for: indexPath)
        let milestone = dataSource.timelineView(self, milestoneAt: indexPath.row)

        collectionViewCell.prepareForReuse()
        collectionViewCell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        collectionViewCell.addSubview(milestone)
        collectionViewCell.addConstraints([
            collectionView.topAnchor.constraint(equalTo: milestone.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: milestone.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: milestone.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: milestone.leftAnchor)
        ])

        return collectionViewCell
    }

}
