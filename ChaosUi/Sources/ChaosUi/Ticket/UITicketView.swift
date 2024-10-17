#if canImport(UIKit)
//
//  UITicketView.swift
//  Chaos
//
//  Created by Fu Lam Diep on 02.12.20.
//

import UIKit

private let kTicketViewInsetTopConstraint = "kTicketViewInsetTopConstraint"
private let kTicketViewInsetRightConstraint = "kTicketViewInsetRightConstraint"
private let kTicketViewInsetBottomConstraint = "kTicketViewInsetBottomConstraint"
private let kTicketViewInsetLeftConstraint = "kTicketViewInsetLeftConstraint"

open class UITicketView: UIView {

    // MARK: Appearance

    /// Provides the space between the leading and the trailing view.
    @objc dynamic var spacing: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }

    /// Provides the axis along which to arrange the leading and trailing view
    @objc dynamic var axis: NSLayoutConstraint.Axis {
        get { stackView.axis }
        set { stackView.axis = newValue }
    }

    /// Provides the edge insets sourounding the content.
    @objc dynamic var contentInsets: UIEdgeInsets = .zero {
        didSet { setNeedsUpdateConstraints() }
    }

    @objc dynamic var cornerRadius: CGFloat = 14 {
        didSet { setNeedsLayout() }
    }

    @objc dynamic var tearOffCapSize: CGFloat = 8 {
        didSet { setNeedsLayout() }
    }

    // MARK: Layer Properties

    private var shapeLayer: CAShapeLayer = CAShapeLayer()


    // MARK: View Hierarchy

    public var leadingView: UIView? {
        didSet { didSetView(leadingView, forContainer: leadingViewContainer) }
    }

    public var trailingView: UIView? {
        didSet { didSetView(trailingView, forContainer: trailingViewContainer) }
    }

    private let leadingViewContainer: UISizableView = UISizableView()

    private let trailingViewContainer: UISizableView = UISizableView()

    /// Provides the content view that manages to arrange the trailing and leading
    /// view.
    private let stackView: UIStackView = UIStackView()



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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        var constraint = topAnchor.constraint(equalTo: stackView.topAnchor)
        constraint.identifier = kTicketViewInsetTopConstraint
        addConstraint(constraint)

        constraint = rightAnchor.constraint(equalTo: stackView.rightAnchor)
        constraint.identifier = kTicketViewInsetRightConstraint
        addConstraint(constraint)

        constraint = bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        constraint.identifier = kTicketViewInsetBottomConstraint
        addConstraint(constraint)

        constraint = leftAnchor.constraint(equalTo: stackView.leftAnchor)
        constraint.identifier = kTicketViewInsetLeftConstraint
        addConstraint(constraint)

        stackView.addArrangedSubview(leadingViewContainer)
        stackView.addArrangedSubview(trailingViewContainer)
    }


    // MARK: View Lifecycle


    open override func layoutSubviews() {
        super.layoutSubviews()
    }

    open override func updateConstraints() {
        super.updateConstraints()
        constraints.first(where: { $0.identifier == kTicketViewInsetTopConstraint })?.constant = contentInsets.top
        constraints.first(where: { $0.identifier == kTicketViewInsetRightConstraint })?.constant = contentInsets.right
        constraints.first(where: { $0.identifier == kTicketViewInsetBottomConstraint })?.constant = contentInsets.bottom
        constraints.first(where: { $0.identifier == kTicketViewInsetLeftConstraint })?.constant = contentInsets.left
    }

    private func layoutShapeLayer () {

        let offset: CGFloat

        switch axis {
        case .horizontal:
            offset = (trailingViewContainer.frame.minX + leadingViewContainer.frame.maxX) / 2
        default:
            offset = (trailingViewContainer.frame.minY + leadingViewContainer.frame.maxY) / 2
        }

        let ticketShape = UIBezierPath.ticketShape(frame: frame,
                                                   axis: axis,
                                                   tearOffOffset: offset,
                                                   tearOffRadius: tearOffCapSize)

        shapeLayer.path = ticketShape.cgPath
    }

    // MARK: Handler Methods

    private func didSetView (_ view: UIView?, forContainer container: UIView) {
        container.subviews.forEach({ $0.removeFromSuperview() })
        if let view = view {
            container.addSubview(view)
            container.addConstraints(view.constraintToSuperviewSize())
        }
    }
}

#endif