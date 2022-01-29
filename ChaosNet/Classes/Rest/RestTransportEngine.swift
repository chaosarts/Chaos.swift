//
//  RestTransportEngine.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestTransportEngine {
    typealias Response = RestTransportEngineResponse

    /// Tells the engine to perform an native request. This function should return a response, when the rest system
    /// responses regardless of the status code. For all other error cases, in which the engine is unable to reach the
    /// rest system it should throw an error.
    func send (request: URLRequest, withIdentifier identifier: String) async throws -> Response

    func cancelRequest(withIdentifier identifier: String)
}


public struct RestTransportEngineResponse {
    public let httpURLResponse: HTTPURLResponse

    public let data: Data?

    public var debugDescription: String {
        var output = httpURLResponse.debugDescription
        if let data = data, let string = String(data: data, encoding: .utf8) {
            output += "\n\(string)"
        }
        return output
    }
}
