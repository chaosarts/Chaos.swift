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

    public var acceptsResponse: ((RestTransportEngineResponse, RestRequest) -> Bool)?

    public var shouldRescueRequest: ((RestRequest, RestTransportEngineResponse) -> Bool)?

    public var rescueRequest: ((RestRequest, RestTransportEngineResponse) async throws -> RestTransportEngineResponse)?

    public func restClient(_ restClient: RestClient, willSend request: RestRequest) {
        callHistory.append(.willSend(request))
    }

    public func restClient(_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest) {
        callHistory.append(.sendingRequestDidFailWithError(error, request))
    }

    public func restClient(_ restClient: RestClient, didSend request: RestRequest) {
        callHistory.append(.didSend(request))
    }

    public func restClient(_ restClient: RestClient, acceptsResponse response: RestTransportEngineResponse, forRequest request: RestRequest) -> Bool {
        callHistory.append(.acceptsResponse(response, request))
        return acceptsResponse?(response, request) ?? false
    }

    public func restClient(_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) -> Bool {
        callHistory.append(.shouldRescueRequest(request, response))
        return shouldRescueRequest?(request, response) ?? false
    }

    public func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) async throws -> RestTransportEngineResponse {
        callHistory.append(.rescueRequest(request, response))
        return try await rescueRequest?(request, response) ?? response
    }

    public func restClient<D>(_ restClient: RestClient, didProduceRestResponse restReponse: RestResponse<D>, forRequest request: RestRequest) {
        callHistory.append(.didProduceRestResponse(request))
    }

    public func restClient(_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest) {
        callHistory.append(.responseProcessingDidFailWithError(error, request))
    }
}

public extension MockRestClientDelegate {
    enum CallHistoryItem {
        case willSend(RestRequest)
        case sendingRequestDidFailWithError(Error, RestRequest)
        case didSend(RestRequest)
        case acceptsResponse(RestTransportEngineResponse, RestRequest)
        case shouldRescueRequest(RestRequest, RestTransportEngineResponse)
        case rescueRequest(RestRequest, RestTransportEngineResponse)
        case didProduceRestResponse(RestRequest)
        case responseProcessingDidFailWithError(Error, RestRequest)

        public var restRequest: RestRequest {
            switch self {
            case .willSend(let request), .sendingRequestDidFailWithError(_, let request), .didSend(let request),
                    .acceptsResponse(_, let request), .shouldRescueRequest(let request, _),
                    .rescueRequest(let request, _), .didProduceRestResponse(let request),
                    .responseProcessingDidFailWithError(_, let request):
                return request
            }
        }

        public var error: Error? {
            switch self {
            case .sendingRequestDidFailWithError(let error, _),
                    .responseProcessingDidFailWithError(let error, _):
                return error
            case .willSend, .didSend, .acceptsResponse, .shouldRescueRequest, .rescueRequest,
                    .didProduceRestResponse:
                return nil
            }
        }

        public var restTransportReponse: RestTransportEngineResponse? {
            switch self {
            case .willSend, .sendingRequestDidFailWithError, .didSend, .didProduceRestResponse,
                    .responseProcessingDidFailWithError:
                return nil
            case .acceptsResponse(let restTransportEngineResponse, _),
                    .shouldRescueRequest(_, let restTransportEngineResponse),
                    .rescueRequest(_, let restTransportEngineResponse):
                return restTransportEngineResponse
            }
        }

        public var isWillSend: Bool {
            if case .willSend = self { return true }
            return false
        }

        public var isSendingRequestDidFailWithError: Bool {
            if case .sendingRequestDidFailWithError = self { return true }
            return false
        }

        public var isDidSend: Bool {
            if case .didSend = self { return true }
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

        public var isDidProduceRestResponse: Bool {
            if case .didProduceRestResponse = self { return true }
            return false
        }
        
        public var isResponseProcessingDidFailWithError: Bool {
            if case .responseProcessingDidFailWithError = self { return true }
            return false
        }
    }
}
