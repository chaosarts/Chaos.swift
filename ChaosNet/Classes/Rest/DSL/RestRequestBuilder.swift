//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

@resultBuilder public enum RestRequestBuilder {

    public static func buildBlock(_ components: [RestRequestModifier]...) -> [RestRequestModifier] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [RestRequestModifier]?) -> [RestRequestModifier] {
        component ?? []
    }

    public static func buildEither(first component: [RestRequestModifier]) -> [RestRequestModifier] {
        component
    }

    public static func buildEither(second component: [RestRequestModifier]) -> [RestRequestModifier] {
        component
    }

    public static func buildExpression(_ expression: RestRequestModifier) -> [RestRequestModifier] {
        [expression]
    }

    public static func buildExpression(_ expression: Void) -> [RestRequestModifier] {
        []
    }
}
