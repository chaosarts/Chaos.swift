//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Query: RestRequestSection {

    private let items: [QueryItem]

    public init(@QueryBuilder _ build: () -> [QueryItem]) {
        items = build()
    }

    public init() {
        items = []
    }

    public func apply(to request: RestRequest) {
        items.forEach { $0.apply(to: request) }
    }
}
