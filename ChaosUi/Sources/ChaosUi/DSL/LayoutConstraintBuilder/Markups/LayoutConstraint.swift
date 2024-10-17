#if canImport(UIKit)
//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

public struct LayoutConstraint {
    internal let attribute: NSLayoutConstraint.Attribute?

    internal let relation: NSLayoutConstraint.Relation

    internal let otherViewIdentifier: String?

    internal let otherAttribute: NSLayoutConstraint.Attribute?

    internal let multiplier: CGFloat?

    internal let constant: CGFloat?

    internal let identifier: String?

    internal let priority: UILayoutPriority?
    
    public init(anchor: KeyPath<UIView, NSLayoutXAxisAnchor>,
                relation: NSLayoutConstraint.Relation = .equal,
                otherIdentifier: String? = nil,
                otherAnchor: KeyPath<UIView, NSLayoutXAxisAnchor>? = nil,
                multiplier: CGFloat? = nil,
                constant: CGFloat? = nil,
                identifier: String? = nil,
                priority: UILayoutPriority? = nil) {
        let otherAnchor = otherAnchor ?? anchor

        self.relation = relation
        self.attribute = anchor.layoutAttribute
        self.otherViewIdentifier = otherIdentifier
        self.otherAttribute = otherAnchor.layoutAttribute
        self.multiplier = multiplier
        self.constant = constant
        self.identifier = identifier
        self.priority = priority
    }
    
    public init(anchor: KeyPath<UIView, NSLayoutYAxisAnchor>,
                relation: NSLayoutConstraint.Relation = .equal,
                otherIdentifier: String,
                otherAnchor: KeyPath<UIView, NSLayoutYAxisAnchor>? = nil,
                multiplier: CGFloat? = nil,
                constant: CGFloat? = nil,
                identifier: String? = nil,
                priority: UILayoutPriority? = nil) {
        let otherAnchor = otherAnchor ?? anchor
        
        self.attribute = anchor.layoutAttribute
        self.relation = relation
        self.otherViewIdentifier = otherIdentifier
        self.otherAttribute = otherAnchor.layoutAttribute
        self.multiplier = multiplier
        self.constant = constant
        self.identifier = identifier
        self.priority = priority
    }
    
    public init(anchor: KeyPath<UIView, NSLayoutDimension>,
                relation: NSLayoutConstraint.Relation = .equal,
                otherIdentifier: String,
                otherAnchor: KeyPath<UIView, NSLayoutDimension>? = nil,
                multiplier: CGFloat? = nil,
                constant: CGFloat? = nil,
                identifier: String? = nil,
                priority: UILayoutPriority? = nil) {
        let otherAnchor = otherAnchor ?? anchor
        
        self.attribute = anchor.layoutAttribute
        self.relation = relation
        self.otherViewIdentifier = otherIdentifier
        self.otherAttribute = otherAnchor.layoutAttribute
        self.multiplier = multiplier
        self.constant = constant
        self.identifier = identifier
        self.priority = priority
    }
    
    public static func topAnchor(relation: NSLayoutConstraint.Relation,
                                 otherIdentifier: String,
                                 otherAnchor: KeyPath<UIView, NSLayoutYAxisAnchor>? = nil,
                                 multiplier: CGFloat? = nil,
                                 constant: CGFloat? = nil,
                                 identifier: String? = nil,
                                 priority: UILayoutPriority? = nil) -> LayoutConstraint {
        LayoutConstraint(anchor: \.topAnchor,
                         relation: relation,
                         otherIdentifier: otherIdentifier,
                         otherAnchor: otherAnchor,
                         multiplier: multiplier,
                         constant: constant,
                         identifier: identifier,
                         priority: priority)
    }
}

#endif