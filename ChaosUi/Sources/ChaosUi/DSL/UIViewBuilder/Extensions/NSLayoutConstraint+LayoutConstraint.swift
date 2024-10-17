#if canImport(UIKit)
//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 04.06.22.
//

import UIKit

public extension NSLayoutConstraint {

    convenience init?(from constraint: LayoutConstraint, view: UIView, otherView: UIView?) {
        guard let attribute = constraint.attribute,
                let otherAttribute = constraint.otherAttribute else {
            return nil
        }
        self.init(item: view,
                  attribute: attribute,
                  relatedBy: constraint.relation,
                  toItem: otherView,
                  attribute: otherAttribute,
                  multiplier: constraint.multiplier ?? 1,
                  constant: constraint.constant ?? 0)
        identifier = constraint.identifier
        priority = constraint.priority ?? .defaultHigh
    }
}

#endif