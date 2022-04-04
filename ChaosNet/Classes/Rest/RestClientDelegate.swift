//
//  RestClientDelegate.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestClientDelegate: AnyObject {

    /// Tells the delegate, that it is about to send the given request.
    ///
    /// Delegates can modify the request at this point before the client sends it.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter request: The request that is about to be sent by the given rest client.
    func restClient (_ restClient: RestClient, willSend request: RestRequest)

    /// Tells the delegate to perform a pre request before sending the actual request.
    ///
    func restClient (_ restClient: RestClient, performPreRequestFor request: RestRequest) async throws

    /// Tells the delegate that the rest client did fail to send the given request (e.g.: no internet connection).
    ///
    /// - Parameter restClient: The rest client that sent the request
    /// - Parameter request: The request that the rest client failed to send.
    func restClient (_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest)

    /// Tells the delegate that it did send the given request.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter request: The request that has been by the given rest client.
    func restClient (_ restClient: RestClient, didSend request: RestRequest)

    /// Asks the delegate if the request should fail for the given response.
    ///
    /// When the transport engine returns a response for the request, which has not a succes status code, the client
    /// will ask the delegate if it should fail or not.
    ///
    /// - Parameter response: The response received by the transport engine
    /// - Parameter request: The request associated with the response
    /// - Returns: True if the rest client should fail, otherwise false
    func restClient (_ restClient: RestClient, acceptsResponse response: RestTransportEngineResponse, forRequest request: RestRequest) -> Bool

    /// Asks the delegate if the client should attempt to rescue the failed request.
    ///
    /// When `restClient (_:, shouldFailWithResponse:, forRequest:)` returns true for a response, the client ask the
    /// delegate if the client should attempt to rescue unless the count of attemptes rescues of this request
    /// `RestRequest.rescueCount` exceeds the maximum count of rescues allowed by the client
    /// `RestClient.maxRescueCount`. If the delegate returns `true`, the client will tell the delegate to attempt to
    /// rescue the request. This will increase the rescue count for the request.
    ///
    /// - Parameter restClient: The rest client asking the delegate
    /// - Parameter request: The request that has failed
    /// - Parameter response: The response by the transport engine associated with the request
    /// - Returns: True if the client should attempt to rescue the request, otherwise false
    func restClient (_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) -> Bool

    /// Tells the delegate to rescue the request associated with the given response.
    ///
    /// The delegate should return a transport engine response that is accepted by the client and its own
    /// implementation (`restClient(_:, shouldFailWithResponse:, forRequest:)`).
    func restClient (_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) async throws -> RestTransportEngineResponse

    /// Tells the delegate, that the client has produced successfully a response for the user of the client.
    func restClient<D> (_ restClient: RestClient, didProduceRestResponse restReponse: RestResponse<D>, forRequest request: RestRequest)

    /// Tells the delegate that the client has failed to process the response of the transport engine.
    func restClient (_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest)
}

public extension RestClientDelegate {
    func restClient(_ restClient: RestClient, willSend request: RestRequest) {}
    func restClient(_ restClient: RestClient, performPreRequestFor request: RestRequest) async throws { }
    func restClient(_ restClient: RestClient, sendingRequestDidFailWithError error: Error, forRequest request: RestRequest) {}
    func restClient(_ restClient: RestClient, didSend request: RestRequest) {}
    func restClient(_ restClient: RestClient, acceptsResponse response: RestTransportEngineResponse, forRequest request: RestRequest) -> Bool { true }
    func restClient(_ restClient: RestClient, shouldRescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) -> Bool { false }
    func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, withResponse response: RestTransportEngineResponse) async throws -> RestTransportEngineResponse { response }
    func restClient<D>(_ restClient: RestClient, didProduceRestResponse restReponse: RestResponse<D>, forRequest request: RestRequest) {}
    func restClient(_ restClient: RestClient, responseProcessingDidFailWithError error: Error, forRequest request: RestRequest) {}
}
