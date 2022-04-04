//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 04.04.22.
//

import Foundation

public struct RestEndpoint {

    public let method: RestRequest.Method

    public let template: String

    public func path(parameters: [String: String] = [:]) -> String {
        var template = template
        parameters.forEach { key, value in
            template = template.replacingOccurrences(of: "{\(key)}", with: value)
        }
        return template
    }
}
