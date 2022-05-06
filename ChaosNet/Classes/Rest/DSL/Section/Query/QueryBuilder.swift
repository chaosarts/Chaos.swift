//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

@resultBuilder public enum QueryBuilder {
    public static func buildBlock(_ components: [QueryItem]...) -> [QueryItem] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [QueryItem]?) -> [QueryItem] {
        component ?? []
    }

    public static func buildEither(first component: [QueryItem]) -> [QueryItem] {
        component
    }

    public static func buildEither(second component: [QueryItem]) -> [QueryItem] {
        component
    }

    public static func buildExpression(_ expression: QueryItem) -> [QueryItem] {
        [expression]
    }

    public static func buildExpression(_ expression: Void) -> [QueryItem] {
        []
    }
}
