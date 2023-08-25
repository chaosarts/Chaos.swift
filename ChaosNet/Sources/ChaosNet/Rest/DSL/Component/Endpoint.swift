//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Endpoint: RestRequestDSLComponent {

    private let endpoint: RestEndpoint

    public init(_ endpoint: RestEndpoint) {
        self.endpoint = endpoint
    }

    public init(_ method: RestMethod, path: String) {
        self.init(RestEndpoint(method, at: path))
    }

    public func apply(to request: RestRequest) {
        request.endpoint = endpoint
    }
}
