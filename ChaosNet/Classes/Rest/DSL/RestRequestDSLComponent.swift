//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public protocol RestRequestDSLComponent {
    func apply(to request: RestRequest)
}

extension Array: RestRequestDSLComponent where Element == RestRequestDSLComponent {
    public func apply(to request: RestRequest) {
        forEach { $0.apply(to: request) }
    }
}
