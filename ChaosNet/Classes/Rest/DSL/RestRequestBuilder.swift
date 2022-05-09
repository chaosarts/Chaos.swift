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

    public static func buildArray(_ components: [[RestRequestModifier]]) -> [RestRequestModifier] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ components: [RestRequestModifier]?) -> [RestRequestModifier] {
        components ?? []
    }

    public static func buildEither(first components: [RestRequestModifier]) -> [RestRequestModifier] {
        components
    }

    public static func buildEither(second components: [RestRequestModifier]) -> [RestRequestModifier] {
        components
    }

    public static func buildExpression(_ expression: RestRequestModifier) -> [RestRequestModifier] {
        [expression]
    }

    public static func buildExpression(_ expression: Void) -> [RestRequestModifier] {
        []
    }

    public static func buildFinalResult(_ components: [RestRequestModifier]) -> RestRequest {
        let restRequest = RestRequest()
        components.apply(to: restRequest)
        return restRequest
    }
}
