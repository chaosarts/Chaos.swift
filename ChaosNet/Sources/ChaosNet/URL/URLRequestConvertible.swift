//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 29.01.22.
//

import Foundation

public protocol URLRequestConvertible {
    func urlRequest(relativeTo baseURL: URL?) throws -> URLRequest
}

extension URLRequest: URLRequestConvertible {
    public func urlRequest(relativeTo baseURL: URL? = nil) throws -> URLRequest {
        guard let requestUrl = self.url, let url = URL(string: requestUrl.absoluteString, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var request = self
        request.url = url
        return request
    }
}
