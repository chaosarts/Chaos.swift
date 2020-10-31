//
//  ApiRequestBuilder.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 30.10.20.
//

import Foundation

/// Class to create api requests.
public class ApiRequestBuilder {

    private var client: ApiClient

    /// Provides the object to use to encode objects to payload data.
    private var dataEncoder: ApiDataEncoder {
        client.dataEncoder
    }

    /// Provides the api request to return by `build`
    private var request: ApiRequest = ApiRequest()

    /// Initializes a request builder with given data encoder.
    ///
    /// For internal use only. The api client creates the api request builder
    /// and passes it the data encoder.
    internal init (client: ApiClient) {
        self.client = client
    }


    // MARK: Setting Values

    /// Sets the action for the api request
    @discardableResult
    public func setAction (_ action: ApiRequest.Action) -> ApiRequestBuilder {
        request.action = action
        return self
    }

    /// Sets the endpoint for the api request
    @discardableResult
    public func setEndpoint (_ endpoint: String, withParams params: ApiRequest.PathParameters = [:]) -> ApiRequestBuilder {
        request.endpoint = endpoint
        return self
    }

    /// Sets the value for a parameter in the endpoint template.
    @discardableResult
    public func setPathParam (_ value: String, forName name: String) -> ApiRequestBuilder {
        request.pathParameters[name] = value
        return self
    }

    /// Sets the value for a api request parameter with given name
    @discardableResult
    public func setParam (_ value: String? = nil, withName name: String) -> ApiRequestBuilder {
        request.parameters.append(ApiRequest.Parameter(name, value))
        return self
    }

    /// Sets the value for a api request header with given name
    @discardableResult
    public func setHeader (_ value: String, withName name: String) -> ApiRequestBuilder {
        request.headers.append(ApiRequest.Header(name: name, value: value))
        return self
    }

    /// Sets the data for the payload to send
    @discardableResult
    public func setPayload (_ payload: Data) -> ApiRequestBuilder {
        request.payload = payload
        return self
    }

    /// Sets the data for the payload with the given encodable object
    @discardableResult
    public func setPayload<E: Encodable> (_ encodable: E) throws -> ApiRequestBuilder {
        do {
            setPayload(try dataEncoder.encode(encodable))
            if !request.headers.contains(where: { $0.name.lowercased() == "content-type" }),
               client.requiresContentTypeForRequest {
                self.setHeader(dataEncoder.mimeType.description, withName: "Content-Type")
            }
            return self
        } catch {
            throw ApiRequestError(code: .encodingError, request: request, previous: error)
        }
    }

    // MARK: Creating the request
    
    /// Returns the api request  according to the values set and flushes these
    /// values internally.
    public func build () -> ApiRequest {
        let apiRequest = self.request
        self.request = ApiRequest()
        return apiRequest
    }
}
