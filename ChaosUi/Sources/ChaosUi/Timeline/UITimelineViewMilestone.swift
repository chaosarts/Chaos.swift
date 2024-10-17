#if canImport(UIKit)
//
//  UITimelineViewMilestone.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 02.11.20.
//

import UIKit

open class UITimelineViewMilestone: UIView {

    // MARK: Appearance of the Timeline Milestone View

    /// Indicates the alignment of the leading, accessory and trailing view within
    /// the timeline milestone view along the axis of the timeline view.
    @IBInspectable
    public var alignment: Alignment = .leading {
        didSet { stackView.alignment = stackViewAlignment(for: alignment) }
    }


    // MARK: Milestone Dependent Properties

    /// Indicates the alignment of the internal views along the axis perpendicular
    /// to the timeline view axis. This can only be set by the timeline view,
    /// since all milestone need to have the same orthoognal alignment.
    internal var orthogonalAlignment: Alignment = .leading {
        didSet { setNeedsLayout() }
    }

    /// Indicates the axis along of the timeline milestone view along which the
    /// leading, accessory and leading view are aligned.
    internal var axis: NSLayoutConstraint.Axis = .vertical {
        didSet { setNeedsLayout() }
    }

    /// Provides the size of the leading view along the axis perpendicular to the
    /// timeline view.
    internal var leadingViewSize: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    /// Provides the size of the accessory view along the axis perpendicular to
    /// the timeline view.
    internal var accessoryViewSize: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    /// Provides the size of the trailing view along the axis perpendicular to the
    /// timeline view.
    internal var trailingViewSize: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    /// Provides the space between the leading and accessory view and between the
    /// accessory view and trailing view.
    internal var leadingViewSpacing: CGFloat = 8 {
        didSet { setNeedsLayout() }
    }

    /// Provides the space between the leading and accessory view and between the
    /// accessory view and trailing view.
    internal var trailingViewSpacing: CGFloat = 8 {
        didSet { setNeedsLayout() }
    }

    /// The natural size for the receiving view, considering only properties of
    /// the view itself.
    open override var intrinsicContentSize: CGSize {
        stackView.intrinsicContentSize
    }

    // MARK: Timeline View Milestone Decoration

    /// Provides the view, that is displayed first in order along the axis
    /// perpendicular to the timeline view.
    public var leadingView: UIView? {
        willSet { view(newValue, willSetForContainer: leadingViewContainer) }
    }

    /// Provides the view, that is displayed second in order along the axis
    /// perpendicular to the timeline view.
    public var accessoryView: UIView? {
        willSet { view(newValue, willSetForContainer: accessoryViewContainer) }
    }

    /// Provides the view, that is displayed last in order along the axis
    /// perpendicular to the timeline view.
    public var trailingView: UIView? {
        willSet { view(newValue, willSetForContainer: trailingViewContainer) }
    }

    // MARK: Internal View Hierarchy

    /// Provides the container consisting of the leading, accessory and trailing
    /// view.
    private let stackView: UIStackView = UIStackView()

    /// Provides the container of the leading view.
    private let leadingViewContainer: UISizableView = UISizableView()

    /// Provides the container of the accessory view.
    private let accessoryViewContainer: UISizableView = UISizableView()

    /// Provides the container of the trailing view
    private let trailingViewContainer: UISizableView = UISizableView()

    /// Provides a view that serves as a spacer between the leading and accessory
    /// view.
    private let leadingViewSpacer: UISizableView = UISizableView()

    /// Provides a view that serves as a spacer between the trailing and accessory
    /// view.
    private let trailingViewSpacer: UISizableView = UISizableView()


    // MARK: Initialization

    public convenience required init () {
        self.init(frame: .zero)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    private func prepare () {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        addSubview(stackView)
        addConstraints(stackView.constraintsToSuperviewEdges()!)

        leadingViewContainer.translatesAutoresizingMaskIntoConstraints = false
        leadingViewSpacer.translatesAutoresizingMaskIntoConstraints = false
        accessoryViewContainer.translatesAutoresizingMaskIntoConstraints = false
        trailingViewSpacer.translatesAutoresizingMaskIntoConstraints = false
        trailingViewContainer.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(leadingViewContainer)
        stackView.addArrangedSubview(leadingViewSpacer)
        stackView.addArrangedSubview(accessoryViewContainer)
        stackView.addArrangedSubview(trailingViewSpacer)
        stackView.addArrangedSubview(trailingViewContainer)

        accessoryViewContainer.setContentHuggingPriority(1500, for: .horizontal)
        accessoryViewContainer.setContentCompressionResistancePriority(1500, for: .horizontal)

        accessoryViewContainer.setContentHuggingPriority(1500, for: .vertical)
        accessoryViewContainer.setContentCompressionResistancePriority(1500, for: .vertical)

        leadingViewSpacer.setContentHuggingPriority(1500, for: .horizontal)
        leadingViewSpacer.setContentCompressionResistancePriority(1500, for: .horizontal)

        leadingViewSpacer.setContentHuggingPriority(1500, for: .vertical)
        leadingViewSpacer.setContentCompressionResistancePriority(1500, for: .vertical)

        trailingViewSpacer.setContentHuggingPriority(1500, for: .horizontal)
        trailingViewSpacer.setContentCompressionResistancePriority(1500, for: .horizontal)

        trailingViewSpacer.setContentHuggingPriority(1500, for: .vertical)
        trailingViewSpacer.setContentCompressionResistancePriority(1500, for: .vertical)
    }

    open override func layoutSubviews() {
        stackView.axis = axis
        stackView.alignment = stackViewAlignment(for: alignment)
        updateSizes()
        updateOrthogonalAlignment()
        super.layoutSubviews()
    }


    // MARK: Updates through Timeline View

    private func stackViewAlignment (for alignment: Alignment) -> UIStackView.Alignment {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }

    internal func updateSizes () {

        if axis == .horizontal {
            accessoryViewContainer.intrinsicWidth = accessoryViewSize
            leadingViewSpacer.intrinsicWidth = leadingViewSpacing
            trailingViewSpacer.intrinsicWidth = trailingViewSpacing

            accessoryViewContainer.intrinsicHeight = nil
            leadingViewSpacer.intrinsicHeight = nil
            trailingViewSpacer.intrinsicHeight = nil
        } else {
            accessoryViewContainer.intrinsicWidth = nil
            leadingViewSpacer.intrinsicWidth = nil
            trailingViewSpacer.intrinsicWidth = nil

            accessoryViewContainer.intrinsicHeight = accessoryViewSize
            leadingViewSpacer.intrinsicHeight = leadingViewSpacing
            trailingViewSpacer.intrinsicHeight = trailingViewSpacing
        }

        leadingViewContainer.intrinsicWidth = nil
        leadingViewContainer.intrinsicHeight = nil
        trailingViewContainer.intrinsicWidth = nil
        trailingViewContainer.intrinsicHeight = nil

        switch orthogonalAlignment {
        case .leading:
            if axis == .horizontal {
                leadingViewContainer.intrinsicWidth = leadingViewSize
            } else {
                leadingViewContainer.intrinsicHeight = leadingViewSize
            }
        case .trailing:
            if axis == .vertical {
                trailingViewContainer.intrinsicWidth = trailingViewSize
            } else {
                trailingViewContainer.intrinsicHeight = trailingViewSize
            }
        default:
            break
        }
    }

    private func updateOrthogonalAlignment () {
        switch orthogonalAlignment {
        case .leading:
            leadingViewContainer.setContentHuggingPriority(1250, for: .vertical)
            leadingViewContainer.setContentCompressionResistancePriority(1250, for: .vertical)

            leadingViewContainer.setContentHuggingPriority(1250, for: .horizontal)
            leadingViewContainer.setContentCompressionResistancePriority(1250, for: .horizontal)

            trailingViewContainer.setContentHuggingPriority(750, for: .vertical)
            trailingViewContainer.setContentCompressionResistancePriority(750, for: .vertical)

            trailingViewContainer.setContentHuggingPriority(750, for: .horizontal)
            trailingViewContainer.setContentCompressionResistancePriority(750, for: .horizontal)
        case .center:
            leadingViewContainer.setContentHuggingPriority(750, for: .vertical)
            leadingViewContainer.setContentCompressionResistancePriority(750, for: .vertical)

            leadingViewContainer.setContentHuggingPriority(750, for: .horizontal)
            leadingViewContainer.setContentCompressionResistancePriority(750, for: .horizontal)

            trailingViewContainer.setContentHuggingPriority(750, for: .vertical)
            trailingViewContainer.setContentCompressionResistancePriority(750, for: .vertical)

            trailingViewContainer.setContentHuggingPriority(750, for: .horizontal)
            trailingViewContainer.setContentCompressionResistancePriority(750, for: .horizontal)
        case .trailing:
            leadingViewContainer.setContentHuggingPriority(750, for: .vertical)
            leadingViewContainer.setContentCompressionResistancePriority(750, for: .vertical)

            leadingViewContainer.setContentHuggingPriority(750, for: .horizontal)
            leadingViewContainer.setContentCompressionResistancePriority(750, for: .horizontal)

            trailingViewContainer.setContentHuggingPriority(1250, for: .vertical)
            trailingViewContainer.setContentCompressionResistancePriority(1250, for: .vertical)

            trailingViewContainer.setContentHuggingPriority(1250, for: .horizontal)
            trailingViewContainer.setContentCompressionResistancePriority(1250, for: .horizontal)
        }
    }

    private func view (_ view: UIView?, willSetForContainer container: UIView) {
        container.subviews.forEach({ $0.removeFromSuperview() })
        guard let view = view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        container.addConstraints(view.constraintsToSuperviewEdges()!)
    }
}


@objc public extension UITimelineViewMilestone {
    typealias Alignment = UITimelineView.Alignment
}

#endif