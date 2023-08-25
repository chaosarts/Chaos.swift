//
//  File.swift
//  
//
//  Created by fu.lam.diep on 30.09.22.
//

import Foundation

public class DefaultRestTransportEngine: RestTransportEngine {

    private var urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func send(request: URLRequest, withIdentifier identifier: String) async throws -> Response {
        let response = try await urlSession.data(for: request)
        guard let httpUrlResponse = response.1 as? HTTPURLResponse else {
            throw RestInternalError(code: .unknown)
        }
        return Response(httpURLResponse: httpUrlResponse, data: response.0)
    }
}
