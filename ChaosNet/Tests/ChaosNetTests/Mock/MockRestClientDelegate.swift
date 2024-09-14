//
//  File.swift
//
//
//  Created by Fu Lam Diep on 28.01.22.
//

import Foundation
import ChaosNet

public class MockRestClientDelegate: LegacyRestClientDelegate {

    public var callHistory: [CallHistoryItem] = []

    public var acceptsResponse: ((RestRawResponse, LegacyRestRequest) -> Bool)?

    public var shouldRescueRequest: ((LegacyRestRequest, RestRawResponse) -> Bool)?

    public var rescueRequest: ((LegacyRestRequest, RestRawResponse) async throws -> RestRawResponse)?

    public func restClient(_ restClient: LegacyRestClient, sendingRequestDidFailWithError error: Error, forRequest request: LegacyRestRequest, relativeTo url: URL?) {
        callHistory.append(.sendingRequestDidFailWithError(error, request))
    }

    public func restClient(_ restClient: LegacyRestClient, acceptsResponse response: RestRawResponse, forRequest request: LegacyRestRequest, relativeTo url: URL?) -> Bool {
        callHistory.append(.acceptsResponse(response, request))
        return acceptsResponse?(response, request) ?? false
    }

    public func restClient(_ restClient: LegacyRestClient, shouldRescueRequest request: LegacyRestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) -> Bool {
        callHistory.append(.shouldRescueRequest(request, response))
        return shouldRescueRequest?(request, response) ?? false
    }

    public func restClient(_ restClient: LegacyRestClient, rescueRequest request: LegacyRestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) async throws -> RestRawResponse {
        callHistory.append(.rescueRequest(request, response))
        return try await rescueRequest?(request, response) ?? response
    }

    public func restClient(_ restClient: LegacyRestClient, responseProcessingDidFailWithError error: Error, forRequest request: LegacyRestRequest, relativeTo url: URL?) {
        callHistory.append(.responseProcessingDidFailWithError(error, request))
    }
}

public extension MockRestClientDelegate {
    enum CallHistoryItem {
        case sendingRequestDidFailWithError(Error, LegacyRestRequest)
        case acceptsResponse(RestRawResponse, LegacyRestRequest)
        case shouldRescueRequest(LegacyRestRequest, RestRawResponse)
        case rescueRequest(LegacyRestRequest, RestRawResponse)
        case responseProcessingDidFailWithError(Error, LegacyRestRequest)

        public var restRequest: LegacyRestRequest {
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
