//
//  File.swift
//
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

@resultBuilder public enum HeaderBuilder {
    public static func buildBlock(_ components: [HeaderItem]...) -> [HeaderItem] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [HeaderItem]?) -> [HeaderItem] {
        component ?? []
    }

    public static func buildEither(first component: [HeaderItem]) -> [HeaderItem] {
        component
    }

    public static func buildEither(second component: [HeaderItem]) -> [HeaderItem] {
        component
    }

    public static func buildExpression(_ expression: HeaderItem) -> [HeaderItem] {
        [expression]
    }

    public static func buildExpression(_ expression: Void) -> [HeaderItem] {
        []
    }
}
