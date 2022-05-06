//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

@resultBuilder public enum RestRequestBuilder {

    public static func buildBlock(_ method: RestMethod, _ path: String, _ components: RestRequestSection...) -> RestRequest {
        let restRequest = RestRequest(RestEndpoint(method, at: path))
        components.forEach { $0.apply(to: restRequest) }
        return restRequest
    }

    public static func buildBlock(_ endpoint: RestEndpoint, _ components: RestRequestSection...) -> RestRequest {
        let restRequest = RestRequest(endpoint)
        components.forEach { $0.apply(to: restRequest) }
        return restRequest
    }
}
