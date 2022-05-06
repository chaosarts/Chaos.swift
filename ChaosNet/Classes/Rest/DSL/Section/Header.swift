//
//  File.swift
//
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct Header: RestRequestSection {

    private let items: [HeaderItem]

    public init(@HeaderBuilder _ build: () -> [HeaderItem]) {
        items = build()
    }

    public init() {
        items = []
    }

    public func apply(to request: RestRequest) {
        items.forEach { $0.apply(to: request) }
    }
}
