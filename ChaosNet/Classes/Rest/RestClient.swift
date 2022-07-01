//
//  RestClient.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation
import ChaosCore

/// Client class for rest calls, that is intended to be positioned on top of the network transport layer (e.g.: http).
/// The class attempts to simplify the process of sending requests and receiving responses. For example does it evaluate
/// the http status.
public class RestClient {

    /// An optional delegate object that is notified or asked at certain events of a request.
    public weak var delegate: RestClientDelegate?

    /// Abstraction object for transporting requests.
    public let transportEngine: RestTransportEngine

    /// An object to decode response data
    public let dataDecoder: RestDataDecoder

    /// Provides the object to be used to encode payload data
    public let dataEncoder: RestDataEncoder

    /// Indicates the time interval to use for request timeouts
    public var defaultTimeoutInterval: TimeInterval = 30

    /// Specifies the policy to use for caching by default. Request objects can specify
    public var defaultCachePolicy: RestRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    /// Specifies whether a request should use cookies or not. This behaviour can be overwritten by a request object
    /// itself.
    public var shouldUseHttpCookies: Bool = true

    public var maxRescueCount: Int = 1

    private var hooks: [RestClientHook] = []

    public var preRequestHooks: [PreRequestHook] {
        hooks.compactMap { $0 as? PreRequestHook }
    }

    public var postRequestHooks: [PostRequestHook] {
        hooks.compactMap { $0 as? PostRequestHook }
    }

    public var preRawResponseProcessHooks: [PreRawResponseProcessHook] {
        hooks.compactMap { $0 as? PreRawResponseProcessHook }
    }

    public var postRawResponseProcessHooks: [PostRawResponseProcessHook] {
        hooks.compactMap { $0 as? PostRawResponseProcessHook }
    }

    private let log: Log = Log(RestClient.self)


    // MARK: Intialization
    
    public init (transportEngine: RestTransportEngine, dataDecoder: RestDataDecoder, dataEncoder: RestDataEncoder) {
        self.transportEngine = transportEngine
        self.dataDecoder = dataDecoder
        self.dataEncoder = dataEncoder
    }


    // MARK: Managing Hooks

    public func insertHook(_ hook: RestClientHook, at index: Int? = nil) {
        let index = min(hooks.count, max(0, index ?? hooks.endIndex))
        hooks.insert(hook, at: index)
    }

    public func insertHook(_ hook: RestClientHook, before otherHook: RestClientHook?) {
        if let otherHook = otherHook,
           let index = hooks.firstIndex(where: { $0 === otherHook }) {
            insertHook(hook, at: index - 1)
        } else {
            insertHook(hook)
        }
    }

    public func insertHook(_ hook: RestClientHook, after otherHook: RestClientHook?) {
        if let otherHook = otherHook,
           let index = hooks.firstIndex(where: { $0 === otherHook }) {
            insertHook(hook, at: index)
        } else {
            insertHook(hook)
        }
    }


    // MARK: Data Helper

    public func encode<E: Encodable>(_ encodable: E) throws -> Data? {
        return try dataEncoder.encode(encodable)
    }

    public func encode(_ encode: @escaping (Encoder) throws -> Void) throws -> Data? {
        let encoder = DeferredEncoder(callback: encode)
        return try dataEncoder.encode(encoder)
    }

    // MARK: Sending requests and handling responses

    private func acceptsResponse(_ response: RestRawResponse, for request: RestRequest, relativeTo baseUrl: URL?) -> Bool {
        HttpStatus.isSuccessStatusCode(response.httpURLResponse.statusCode) ||
        delegate?.restClient(self, acceptsResponse: response, forRequest: request, relativeTo: baseUrl) ?? false
    }

    private func processRawResponse(_ rawResponse: RestRawResponse, for request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestRawResponse {
        do {
            var rawResponse = rawResponse
            for hook in preRawResponseProcessHooks {
                rawResponse = try await hook.restClient(self,
                                                        willProcessRawResponse: rawResponse,
                                                        for: request,
                                                        relativeTo: baseUrl)
            }
            return rawResponse
        } catch {
            let restError = RestInternalError(code: .hook, previous: error)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request, relativeTo: baseUrl)
            throw restError
        }
    }


    private func processRestResponse<D>(_ restResponse: RestResponse<D>, for request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestResponse<D> {
        do {
            var restResponse = restResponse
            for hook in postRawResponseProcessHooks {
                restResponse = try await hook.restClient(self, didProcessRawResponseTo: restResponse, for: request, relativeTo: baseUrl)
            }
            return restResponse
        } catch {
            let restError = RestInternalError(code: .hook, previous: error)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request, relativeTo: baseUrl)
            throw restError
        }
    }

    public func response(forRequest request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestTransportEngine.Response {
        do {
            request.timeoutInterval.setIfNil(defaultTimeoutInterval)
            request.cachePolicy.setIfNil(defaultCachePolicy)
            request.shouldUseHttpCookies.setIfNil(shouldUseHttpCookies)

            for hook in preRequestHooks {
                try await hook.restClient(self, willSendRequest: request, relativeTo: baseUrl)
            }

            let urlRequest = try request.urlRequest(relativeTo: baseUrl)
            log.info(format: "Sending request %@ to %@", request.id, urlRequest.url?.absoluteString ?? "-")

            var response = try await transportEngine.send(request: urlRequest,
                                                          withIdentifier: request.id)

            for hook in postRequestHooks {
                response = try await hook.restClient(self,
                                                     didReceiveRawResponse: response,
                                                     for: request,
                                                     relativeTo: baseUrl)
            }

            log.info(format: "Rest request %@ returned with status %i", request.id, response.httpURLResponse.statusCode)
            log.debug(format: "%@", response.debugDescription)

            while !acceptsResponse(response, for: request, relativeTo: baseUrl) {
                guard request.rescueCount < maxRescueCount,
                      (delegate?.restClient(self, shouldRescueRequest: request, withResponse: response, relativeTo: baseUrl) ?? false) else {
                    throw RestResponseError(code: restResponseErrorCode(forHttpStatusCode: response.httpURLResponse.statusCode),
                                            response: response.httpURLResponse,
                                            data: response.data)
                }

                response = try await delegate!.restClient(self, rescueRequest: request, withResponse: response, relativeTo: baseUrl)
                request.rescueCount += 1
            }

            return response
        } catch let error where !(error is RestError) {
            log.error(format: "Rest transport engine failed to send request %@ with error %@", request.id, error as NSError)
            let restError = RestInternalError(code: .engine, previous: error)
            delegate?.restClient(self, sendingRequestDidFailWithError: restError, forRequest: request, relativeTo: baseUrl)
            throw restError
        }
    }


    public func send<D: Decodable>(request: RestRequest, relativeTo baseUrl: URL? = nil, expecting type: D.Type = D.self) async throws -> RestResponse<D> {
        var rawResponse = try await response(forRequest: request, relativeTo:  baseUrl)
        rawResponse = try await processRawResponse(rawResponse, for: request, relativeTo: baseUrl)

        guard let data = rawResponse.data else {
            let restError = RestInternalError(code: .noData, previous: nil)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request, relativeTo: baseUrl)
            throw restError
        }

        do {
            let decoder = request.decoder ?? dataDecoder
            let object = try decoder.decode(D.self, from: data)
            let headers = headers(fromHttpUrlResponse: rawResponse.httpURLResponse)
            let restResponse = RestResponse(to: request, data: object, headers: headers)
            return try await processRestResponse(restResponse, for: request, relativeTo: baseUrl)
        } catch {
            let restError = RestInternalError(code: .decoding, previous: error)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request, relativeTo: baseUrl)
            throw restError
        }
    }

    public func send(request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<Void> {
        var rawResponse = try await response(forRequest: request, relativeTo:  baseUrl)
        rawResponse = try await processRawResponse(rawResponse, for: request, relativeTo: baseUrl)

        let headers = headers(fromHttpUrlResponse: rawResponse.httpURLResponse)
        let restResponse = RestResponse(to: request, data: Void(), headers: headers)

        return try await processRestResponse(restResponse, for: request, relativeTo: baseUrl)
    }


    public func request(@RestRequestBuilder _ build: () throws -> RestRequest) rethrows -> RestRequest {
        try build()
    }

    public func response(relativeTo baseUrl: URL? = nil, @RestRequestBuilder _ build: () throws -> RestRequest) async throws -> RestRawResponse {
        return try await response(forRequest: try build(), relativeTo: baseUrl)
    }

    public func send<D: Decodable>(relativeTo baseUrl: URL? = nil, expecting: D.Type = D.self, @RestRequestBuilder _ build: () throws -> RestRequest) async throws -> RestResponse<D> {
        return try await send(request: try build(), relativeTo: baseUrl, expecting: D.self)
    }

    public func send(relativeTo baseUrl: URL? = nil, @RestRequestBuilder _ build: () throws -> RestRequest) async throws -> RestResponse<Void> {
        return try await send(request: try build(), relativeTo: baseUrl)
    }


    // MARK: Request Cancellation

    public func cancelRequest(_ request: RestRequest) {
        cancelRequest(withIdentifier: request.id)
    }

    public func cancelRequest(withIdentifier id: String) {
        transportEngine.cancelRequest(withIdentifier: id)
    }


    // MARK: HTTPURLResponse Helper

    private func headers(fromHttpUrlResponse response: HTTPURLResponse) -> [String: String] {
        var headers: [String: String] = [:]
        for header in response.allHeaderFields {
            guard let key = header.key as? String, let value = header.value as? String else {
                continue
            }
            headers[key] = value
        }
        return headers
    }

    private func restResponseErrorCode(forHttpStatusCode httpStatusCode: Int) -> RestResponseError.Code {
        restResponseErrorCode(forHttpStatus: HttpStatus(httpStatusCode))
    }

    private func restResponseErrorCode(forHttpStatus httpStatus: HttpStatus) -> RestResponseError.Code {
        switch httpStatus.category {
        case .information, .redirection, .success:
            return .invalidErrorCode
        case .clientError:
            return .clientError
        case .serverError:
            return .serverError
        case .proprietaryError:
            return .proprietaryError
        case .unknown:
            return .unknown
        }
    }
}
