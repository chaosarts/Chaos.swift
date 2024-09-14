//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 11.01.22.
//

@testable import ChaosNet
import Foundation

enum MockLegacyRestTransportEngineError: Error {
    case misconfiguration
}

class MockLegacyRestTransportEngine: LegacyRestTransportEngine {


    private(set) var requests: [URLRequest] = []

    var results: [Result<Response, Error>] = []

    var lastRequest: URLRequest? {
        requests.last
    }

    func send(request: URLRequest, withIdentifier identifier: String) async throws -> Response {
        requests.append(request)
        guard !results.isEmpty else {
            let httpURLResponse: HTTPURLResponse = .ok(for: request) ?? HTTPURLResponse()
            return Response(httpURLResponse: httpURLResponse, data: nil)
        }
        let result = results.removeFirst()
        switch result {
        case .failure(let error):
            throw error
        case .success(let response):
            return response
        }
    }

    func cancelRequest(withIdentifier identifier: String) {

    }

    func reset() {
        requests = []
        results = []
    }
}
