//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

@resultBuilder public enum RestRequestBuilder {

    public static func buildBlock(_ components: [RestRequestDSLComponent]...) -> [RestRequestDSLComponent] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[RestRequestDSLComponent]]) -> [RestRequestDSLComponent] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ components: [RestRequestDSLComponent]?) -> [RestRequestDSLComponent] {
        components ?? []
    }

    public static func buildEither(first components: [RestRequestDSLComponent]) -> [RestRequestDSLComponent] {
        components
    }

    public static func buildEither(second components: [RestRequestDSLComponent]) -> [RestRequestDSLComponent] {
        components
    }

    public static func buildExpression(_ expression: RestRequestDSLComponent) -> [RestRequestDSLComponent] {
        [expression]
    }

    public static func buildExpression(_ expression: Void) -> [RestRequestDSLComponent] {
        []
    }

    public static func buildFinalResult(_ components: [RestRequestDSLComponent]) -> RestRequest {
        let restRequest = RestRequest()
        components.apply(to: restRequest)
        return restRequest
    }
}
