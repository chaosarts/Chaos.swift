#if canImport(UIKit)
//
//  NSLayoutAnchor+constraint.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 17.10.20.
//

import UIKit

@objc
public extension NSLayoutAnchor {

    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }

    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor)
        constraint.identifier = identifier
        return constraint
    }

    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, priority: priority)
        constraint.identifier = identifier
        return constraint
    }
}

#endif