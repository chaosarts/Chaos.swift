//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Method: RestRequestModifier {

    private let value: RestMethod

    public init(_ value: RestMethod) {
        self.value = value
    }

    public func apply(to request: RestRequest) {
        request.endpoint = RestEndpoint(value, at: request.path)
    }
}
