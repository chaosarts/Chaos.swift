//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Path: RestRequestDSLComponent, ExpressibleByStringLiteral {

    private let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    public func apply(to request: RestRequest) {
        request.endpoint = RestEndpoint(request.method, at: value)
    }
}
