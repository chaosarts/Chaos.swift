//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct HeaderItem: RestRequestModifier {

    private let name: String

    private let value: Any

    public init(name: String, value: Any) {
        self.name = name
        self.value = value
    }

    public func apply(to request: RestRequest) {
        request.setHeader(name, value: "\(value)")
    }
}
