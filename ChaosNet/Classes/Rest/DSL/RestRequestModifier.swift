//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public protocol RestRequestModifier {
    func apply(to request: RestRequest)
}

extension Array: RestRequestModifier where Element == RestRequestModifier {
    public func apply(to request: RestRequest) {
        forEach { $0.apply(to: request) }
    }
}
