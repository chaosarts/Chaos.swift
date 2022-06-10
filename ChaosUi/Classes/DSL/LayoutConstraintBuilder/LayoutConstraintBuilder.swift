//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

@resultBuilder
public enum LayoutConstraintBuilder {
    public static func buildBlock(_ components: [LayoutConstraint]...) -> [LayoutConstraint] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[LayoutConstraint]]) -> [LayoutConstraint] {
        components.flatMap { $0 }
    }

    public static func buildEither(first component: [LayoutConstraint]) -> [LayoutConstraint] {
        component.compactMap { $0 }
    }

    public static func buildEither(second component: [LayoutConstraint]) -> [LayoutConstraint] {
        component.compactMap { $0 }
    }

    public static func buildOptional(_ component: [LayoutConstraint]?) -> [LayoutConstraint] {
        component ?? []
    }

    public static func buildExpression(_ expression: LayoutConstraint) -> [LayoutConstraint] {
        [expression]
    }
}
