//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 01.07.22.
//

import Foundation

public struct RestRawResponse {
    public let httpURLResponse: HTTPURLResponse

    public let data: Data?

    public init (httpURLResponse: HTTPURLResponse, data: Data? = nil) {
        self.httpURLResponse = httpURLResponse
        self.data = data
    }

    public var debugDescription: String {
        var output = httpURLResponse.debugDescription
        if let data = data, let string = String(data: data, encoding: .utf8) {
            output += "\n\(string)"
        }
        return output
    }
}
