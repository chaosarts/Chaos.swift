//
//  UIView+NSLayoutConstraint.swift
//  Chaos
//
//  Created by Fu Lam Diep on 02.11.20.
//

import UIKit

public extension UIView {
    func constraintToSuperviewTopEdge (constant: CGFloat = .zero) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.topAnchor.constraint(equalTo: topAnchor, constant: constant)
    }

    func constraintToSuperviewRightEdge (constant: CGFloat = .zero) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.rightAnchor.constraint(equalTo: rightAnchor, constant: constant)
    }

    func constraintToSuperviewBottomEdge (constant: CGFloat = .zero) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant)
    }

    func constraintToSuperviewLeftEdge (constant: CGFloat = .zero) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.leftAnchor.constraint(equalTo: leftAnchor, constant: constant)
    }

    /// When contained in a superview, this method returns a list of four
    /// constraints, binding the edges of this view to the edges of its
    /// superview with an optional offset. The constraints will not be activated.
    /// Its the users responsibility to add it with `addConstraints`.
    func constraintsToSuperviewEdges (constants: UIEdgeInsets = .zero) -> [NSLayoutConstraint]? {
        guard let topConstraint = constraintToSuperviewTopEdge(),
              let rightConstraint = constraintToSuperviewRightEdge(),
              let bottomConstraint = constraintToSuperviewBottomEdge(),
              let leftCOnstraint = constraintToSuperviewLeftEdge() else {
            return nil
        }
        return [topConstraint, rightConstraint, bottomConstraint, leftCOnstraint]
    }

    /// Generates a layout constraint, that binds the horizontal centers of this
    /// view and its superview, if present.
    ///
    /// The resulting constraint is not activated. Its the users responsibility
    /// to activate or add the constraint to the super view.
    func constraintToSuperviewCenterX (constant: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant)
    }

    /// Generates a layout constraint, that binds the vertical centers of this
    /// view and its superview, if present.
    ///
    /// The resulting constraint is not activated. Its the users responsibility
    /// to activate or add the constraint to the super view.
    func constraintToSuperviewCenterY (constant: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant)
    }

    /// Generates layout constraints, that binds the horizontal and vertical
    /// centers to the center of its superview, if present.
    ///
    /// The resulting constraints is not activated. Its the users responsibility
    /// to activate or add the constraints to the super view.
    func constraintToSuperviewCenter (constants: CGPoint = .zero) -> [NSLayoutConstraint]? {
        guard let centerXConstraint = constraintToSuperviewCenterX(constant: constants.x),
              let centerYConstraint = constraintToSuperviewCenterY(constant: constants.y) else {
            return nil
        }
        return [centerXConstraint, centerYConstraint]
    }


    func constraintToSuperviewHeight (constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier, constant: constant)
    }

    func constraintToSuperviewWidth (constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return superview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier, constant: constant)
    }


    func constraintToSuperviewSize (constants: CGSize = .zero, multipliers: CGSize = CGSize(width: 1, height: 1)) -> [NSLayoutConstraint]? {
        guard let heightConstraint = constraintToSuperviewHeight(constant: constants.height, multiplier: multipliers.height),
              let widthConstraint = constraintToSuperviewWidth(constant: constants.width, multiplier: multipliers.width) else {
            return nil
        }

        return [widthConstraint, heightConstraint]
    }
}
