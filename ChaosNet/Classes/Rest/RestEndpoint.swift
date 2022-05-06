//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.05.22.
//

import Foundation

public struct RestEndpoint: ExpressibleByStringLiteral, Equatable {

    public let method: RestMethod

    public let template: String

    public init(_ method: RestMethod = .GET, at template: String) {
        self.method = method
        self.template = template
    }

    public init(stringLiteral value: String) {
        self.init(.GET, at: value)
    }

    public func path(parameters: [String: String] = [:]) -> String {
        var template = template
        parameters.forEach { key, value in
            template = template.replacingOccurrences(of: "{\(key)}", with: value)
        }
        return template
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.method == rhs.method && lhs.template == rhs.template
    }
}
