//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Body: RestRequestSection {

    private let content: Data?

    public init(_ content: Data?) {
        self.content = content
    }

    public func apply(to request: RestRequest) {
        request.setPayload(content)
    }
}
