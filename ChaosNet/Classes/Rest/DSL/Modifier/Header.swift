//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Header: RestRequestModifier {

    private let name: String

    private let value: Any?

    public init(name: String, value: Any?) {
        self.name = name
        self.value = value
    }

    public func apply(to request: RestRequest) {
        guard let value = value else {
            return
        }
        request.setHeader(name, value: "\(value)")
    }
}
