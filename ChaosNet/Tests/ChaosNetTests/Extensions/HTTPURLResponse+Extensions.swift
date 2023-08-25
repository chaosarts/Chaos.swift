//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.01.22.
//

import Foundation

public extension HTTPURLResponse {

    // MARK: Success

    static func ok(for url: URL, headers: [String: String]? = nil) -> HTTPURLResponse? {
        HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
    }

    static func ok(for urlRequest: URLRequest, headers: [String: String]? = nil) -> HTTPURLResponse? {
        guard let url = urlRequest.url else { return nil }
        return ok(for: url, headers: headers)
    }

    // MARK: Client Error

    static func unauthorized(for url: URL, headers: [String: String]? = nil) -> HTTPURLResponse? {
        HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: headers)
    }

    static func unauthorized(for urlRequest: URLRequest, headers: [String: String]? = nil) -> HTTPURLResponse? {
        guard let url = urlRequest.url else { return nil }
        return unauthorized(for: url, headers: headers)
    }
}
