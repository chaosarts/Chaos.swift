//
//  File.swift
//
//
//  Created by Fu Lam Diep on 28.01.22.
//

import Foundation
import ChaosNet

public class MockRestClientDelegate: RestClientDelegate {

    public var callHistory: [CallHistoryItem] = []

    public var acceptsResponse: ((RestRawResponse, RestRequest) -> Bool)?

    public var shouldRescueRequest: ((RestRequest, RestRawResponse) -> Bool)?

    public var rescueRequest: ((RestRequest, RestRawResponse) async throws -> RestRawResponse)?

    public func restClient(_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?) {
        callHistory.append(.sendingRequestDidFailWithError(error, request))
    }

    public func restClient(_ restClient: RestClient, acceptsResponse response: RestRawResponse, forRequest request: RestRequest, relativeTo url: URL?) -> Bool {
        callHistory.append(.acceptsResponse(response, request))
        return acceptsResponse?(response, request) ?? false
    }

    public func restClient(_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) -> Bool {
        callHistory.append(.shouldRescueRequest(request, response))
        return shouldRescueRequest?(request, response) ?? false
    }

    public func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) async throws -> RestRawResponse {
        callHistory.append(.rescueRequest(request, response))
        return try await rescueRequest?(request, response) ?? response
    }

    public func restClient(_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?) {
        callHistory.append(.responseProcessingDidFailWithError(error, request))
    }
}

public extension MockRestClientDelegate {
    enum CallHistoryItem {
        case sendingRequestDidFailWithError(Error, RestRequest)
        case acceptsResponse(RestRawResponse, RestRequest)
        case shouldRescueRequest(RestRequest, RestRawResponse)
        case rescueRequest(RestRequest, RestRawResponse)
        case responseProcessingDidFailWithError(Error, RestRequest)

        public var restRequest: RestRequest {
            switch self {
            case .sendingRequestDidFailWithError(_, let request), .acceptsResponse(_, let request),
                    .shouldRescueRequest(let request, _), .rescueRequest(let request, _),
                    .responseProcessingDidFailWithError(_, let request):
                return request
            }
        }

        public var error: Error? {
            switch self {
            case .sendingRequestDidFailWithError(let error, _),
                    .responseProcessingDidFailWithError(let error, _):
                return error
            case .acceptsResponse, .shouldRescueRequest, .rescueRequest:
                return nil
            }
        }

        public var restTransportReponse: RestRawResponse? {
            switch self {
            case .sendingRequestDidFailWithError, .responseProcessingDidFailWithError:
                return nil
            case .acceptsResponse(let restTransportEngineResponse, _),
                    .shouldRescueRequest(_, let restTransportEngineResponse),
                    .rescueRequest(_, let restTransportEngineResponse):
                return restTransportEngineResponse
            }
        }

        public var isSendingRequestDidFailWithError: Bool {
            if case .sendingRequestDidFailWithError = self { return true }
            return false
        }

        public var isAcceptsResponse: Bool {
            if case .acceptsResponse = self { return true }
            return false
        }

        public var isShouldRescueRequest: Bool {
            if case .shouldRescueRequest = self { return true }
            return false
        }

        public var isRescueRequest: Bool {
            if case .rescueRequest = self { return true }
            return false
        }
        
        public var isResponseProcessingDidFailWithError: Bool {
            if case .responseProcessingDidFailWithError = self { return true }
            return false
        }
    }
}
