//
//  RestClientDelegate.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestClientDelegate: AnyObject {

    /// Tells the delegate that the rest client did fail to send the given request (e.g.: no internet connection).
    ///
    /// - Parameter restClient: The rest client that sent the request
    /// - Parameter request: The request that the rest client failed to send.
    func restClient(_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?)


    /// Asks the delegate if the request should fail for the given response.
    ///
    /// When the transport engine returns a response for the request, which has not a succes status code, the client
    /// will ask the delegate if it should fail or not.
    ///
    /// - Parameter response: The response received by the transport engine
    /// - Parameter request: The request associated with the response
    /// - Returns: True if the rest client should fail, otherwise false
    func restClient(_ restClient: RestClient, acceptsResponse response: RestRawResponse, forRequest request: RestRequest, relativeTo url: URL?) -> Bool

    /// Asks the delegate if the client should attempt to rescue the failed request.
    ///
    /// When `restClient(_:, shouldFailWithResponse:, forRequest:)` returns true for a response, the client ask the
    /// delegate if the client should attempt to rescue unless the count of attemptes rescues of this request
    /// `RestRequest.rescueCount` exceeds the maximum count of rescues allowed by the client
    /// `RestClient.maxRescueCount`. If the delegate returns `true`, the client will tell the delegate to attempt to
    /// rescue the request. This will increase the rescue count for the request.
    ///
    /// - Parameter restClient: The rest client asking the delegate
    /// - Parameter request: The request that has failed
    /// - Parameter response: The response by the transport engine associated with the request
    /// - Returns: True if the client should attempt to rescue the request, otherwise false
    func restClient(_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) -> Bool

    /// Tells the delegate to rescue the request associated with the given response.
    ///
    /// The delegate should return a transport engine response that is accepted by the client and its own
    /// implementation (`restClient(_:, shouldFailWithResponse:, forRequest:)`).
    func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) async throws -> RestRawResponse

    /// Tells the delegate that the client has failed to process the response of the transport engine.
    func restClient(_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?)
}

public extension RestClientDelegate {
    func restClient(_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?) {}
    func restClient(_ restClient: RestClient, acceptsResponse response: RestRawResponse, forRequest request: RestRequest, relativeTo url: URL?) -> Bool { true }
    func restClient(_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) -> Bool { false }
    func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestRawResponse, relativeTo url: URL?) async throws -> RestRawResponse { response }
    func restClient(_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest, relativeTo url: URL?) {}
}
