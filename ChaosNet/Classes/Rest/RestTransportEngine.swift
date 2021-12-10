//
//  RestTransportEngine.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestTransportEngine {
    typealias Response = RestTransportEngineResponse
    func send (request: URLRequest, completion: (Result<Response, Error>) -> Void)

//    @available(iOS 15, *)
//    func send (request: URLRequest) async throws -> Response
}


public struct RestTransportEngineResponse {
    public let response: HTTPURLResponse

    public let data: Data?

    public var debugDescription: String {
        var output = response.debugDescription
        if let data = data, let string = String(data: data, encoding: .utf8) {
            output += "\n\(string)"
        }
        return output
    }
}
