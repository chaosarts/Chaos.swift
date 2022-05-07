//
//  File.swift
//
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Query: RestRequestModifier {

    private let name: String

    private let value: Any?

    private let ignoreWhenNil: Bool

    public init(name: String, value: Any? = nil, ignoreWhenNil: Bool = false) {
        self.name = name
        self.value = value
        self.ignoreWhenNil = ignoreWhenNil
    }

    public func apply(to request: RestRequest) {
        guard !ignoreWhenNil || value != nil else {
            return
        }
        request.setQueryParameter(name, value: value.map({ "\($0)"}))
    }
}
