#if canImport(UIKit)
//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

@resultBuilder
public enum UIViewBuilder {
    public static func buildBlock(_ components: [UIViewBuilderMarkup]...) -> [UIViewBuilderMarkup] {
        components.flatMap { $0 }
    }

    public static func buildBlock(_ components: [UIView]...) -> [UIViewBuilderMarkup] {
        buildArray(components)
    }

    public static func buildArray(_ components: [[UIViewBuilderMarkup]]) -> [UIViewBuilderMarkup] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[UIView]]) -> [UIViewBuilderMarkup] {
        components.flatMap { $0.map { UIViewBuilderMarkup(view: $0, constraints: []) } }
    }

    public static func buildEither(first component: [UIViewBuilderMarkup]) -> [UIViewBuilderMarkup] {
        component.compactMap { $0 }
    }

    public static func buildEither(first component: [UIView]) -> [UIViewBuilderMarkup] {
        component.map { UIViewBuilderMarkup(view: $0, constraints: []) }
    }

    public static func buildEither(second component: [UIViewBuilderMarkup]) -> [UIViewBuilderMarkup] {
        component.compactMap { $0 }
    }

    public static func buildEither(second component: [UIView]) -> [UIViewBuilderMarkup] {
        component.map { UIViewBuilderMarkup(view: $0, constraints: []) }
    }

    public static func buildOptional(_ component: [UIViewBuilderMarkup]?) -> [UIViewBuilderMarkup] {
        component ?? []
    }

    public static func buildOptional(_ component: [UIView]?) -> [UIViewBuilderMarkup] {
        component?.map { UIViewBuilderMarkup(view: $0, constraints: []) } ?? []
    }

    public static func buildExpression(_ expression: UIViewBuilderMarkup) -> [UIViewBuilderMarkup] {
        [expression]
    }

    public static func buildExpression(_ expression: UIView) -> [UIViewBuilderMarkup] {
        [UIViewBuilderMarkup(view: expression, constraints: [])]
    }
}

#endif