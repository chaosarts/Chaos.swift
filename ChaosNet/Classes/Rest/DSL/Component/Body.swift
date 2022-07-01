//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Body: RestRequestDSLComponent {

    private let content: Data?

    public init(_ content: @autoclosure () throws -> Data?) rethrows {
        self.content = try content()
    }

    public func apply(to request: RestRequest) {
        request.setPayload(content)
    }
}
