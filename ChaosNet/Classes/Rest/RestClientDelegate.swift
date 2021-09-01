//
//  RestClientDelegate.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestClientDelegate: AnyObject {

    /// Asks the delegate if the rest client should use cookies for the given request.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter request: The request that is about to be sent by the given rest client.
    func restClient (_ restClient: RestClient, shouldUseHttpCookiesFor request: RestRequest) -> Bool

    /// Tells the delegate, that it is about to send the given request.
    ///
    /// Delegates can modify the request at this point before the client sends it.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter request: The request that is about to be sent by the given rest client.
    func restClient (_ restClient: RestClient, willSend request: RestRequest)

    /// Tells the delegate that it did send the given request.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter request: The request that has been by the given rest client.
    func restClient (_ restClient: RestClient, didSend request: RestRequest)

    /// Tells the delegate, that the rest client did receive an error when sending the request.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter error: The error received by the client.
    /// - Parameter request: The request that has been by the given rest client.
    func restClient (_ restClient: RestClient, didReceive error: Error, for request: RestRequest)

    /// Asks the delegate, if the rest client should fail the request for the given http status code.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter statusCode: The status code received by the client.
    func restClient (_ restClient: RestClient, shouldFailForStatus statusCode: Int) -> Bool

    /// Tells the delegate, that the rest client did receive a valid response.
    /// - Parameter restClient: The client calling this method.
    /// - Parameter response: The response received and decoded by the client.
    /// - Parameter request: The request that has been by the given rest client.
    func restClient<D> (_ restClient: RestClient, didReceive response: RestResponse<D>, for request: RestRequest)
}

public extension RestClientDelegate {
    func restClient (_ restClient: RestClient, shouldUseHttpCookiesFor request: RestRequest) -> Bool { true }
    func restClient (_ restClient: RestClient, willSend request: RestRequest) {}
    func restClient (_ restClient: RestClient, didSend request: RestRequest) {}
    func restClient (_ restClient: RestClient, didReceive error: Error, for request: RestRequest) {}
    func restClient (_ restClient: RestClient, shouldFailForStatus statusCode: Int) -> Bool { true }
    func restClient<D> (_ restClient: RestClient, didReceive response: RestResponse<D>, for request: RestRequest) {}
}
