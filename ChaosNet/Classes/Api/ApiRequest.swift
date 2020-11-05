//
//  ApiRequest.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 30.10.20.
//

import Foundation

open class ApiRequest {

    /// Indicates what kind of action, this request will perform.
    public internal(set) var action: Action = .retrieve

    /// Provides the endpoint relative to a given base url. The base url will be
    /// passed to the method `ApiClient.send`. To use path parameters use the
    /// placeholder format *{paramName}* within your endpoint.
    public internal(set) var endpoint: String?

    /// Provides the list of headers to set for when sending the request.
    public internal(set) var headers: [Header] = []

    /// Provides a dictionary where key is the placeholder name in the endpoint
    /// string and value the value to replace the placeholder.
    public internal(set) var pathParameters: PathParameters = [:]

    /// Provides a list of parameters to append to the resulting url.
    public internal(set) var parameters: [Parameter] = []

    /// Provides the payload to send with the request.
    public internal(set) var payload: Payload? = nil

    /// Provides the url request representation of this api request.
    public internal(set) var urlRequest: URLRequest?
}


// MARK: - Nested Types

public extension ApiRequest {

    /// Describes the type for an api request header.
    public typealias Header = HttpHeader

    /// Describes the type for path parameters.
    public typealias PathParameters = [String: String]

    /// Describes the type for api request parameter.
    public typealias Parameter = (key: String, value: String?)

    /// Describes the type for payloads of an api request.
    public typealias Payload = Data

    public enum Action {
        case create, retrieve, update, delete
    }
}
