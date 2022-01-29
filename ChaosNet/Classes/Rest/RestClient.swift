//
//  RestClient.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation
import ChaosCore

/// Client class for rest calls, that is intended to be positioned on top of the network transport layer (e.g.: http). The class attempts
/// to simplify the process of sending requests and receiving responses. For example does it evaluate the http status
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

    private let log: Log = Log(RestClient.self)


    // MARK: Intialization
    
    public init (transportEngine: RestTransportEngine,
                 dataDecoder: RestDataDecoder = JSONDecoder(),
                 dataEncoder: RestDataEncoder = JSONEncoder()) {
        self.transportEngine = transportEngine
        self.dataDecoder = dataDecoder
        self.dataEncoder = dataEncoder
    }


    // MARK: Sending Requests Synchronous

    private func response (for request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestTransportEngine.Response {
        do {
            request.timeoutInterval = request.timeoutInterval ?? defaultTimeoutInterval
            request.cachePolicy = request.cachePolicy ?? defaultCachePolicy
            request.shouldUseHttpCookies = request.shouldUseHttpCookies ?? shouldUseHttpCookies

            delegate?.restClient(self, willSend: request)
            let urlRequest = try request.urlRequest(relativeTo: baseUrl)
            log.info(format: "Sending request %@ to %@", request.id, urlRequest.url?.absoluteString ?? "-")

            var transportEngineResponse = try await transportEngine.send(request: urlRequest, withIdentifier: request.id)
            delegate?.restClient(self, didSend: request)

            self.log.info(format: "Rest request %@ returned with status %@", request.id, transportEngineResponse.httpURLResponse.statusCode)
            self.log.debug(format: "%@", transportEngineResponse.debugDescription)

            while HttpStatus(transportEngineResponse.httpURLResponse.statusCode).category != .success &&
                    delegate?.restClient(self, shouldFailWithResponse: transportEngineResponse, forRequest: request) == true &&
                    request.rescueCount < maxRescueCount &&
                    delegate?.restClient(self, shouldRescueRequest: request, withResponse: transportEngineResponse) == true {

                request.rescueCount += 1
                self.log.info(format: "Rest client delegate decided to fail for request %@. Try to rescue with attempt %@", request.id, request.rescueCount)
                transportEngineResponse = try await delegate!.restClient(self, rescueRequest: request, withResponse: transportEngineResponse)
            }

            if HttpStatus(transportEngineResponse.httpURLResponse.statusCode).category != .success {
                if delegate?.restClient(self, shouldFailWithResponse: transportEngineResponse, forRequest: request) == true {
                    throw RestResponseError(code: restResponseErrorCode(forHttpStatusCode: transportEngineResponse.httpURLResponse.statusCode),
                                            response: transportEngineResponse.httpURLResponse,
                                            data: transportEngineResponse.data)
                }
            }

            return transportEngineResponse
        } catch let error where !(error is RestError) {
            self.log.error(format: "Rest transport engine failed to send request %@ with error %@", request.id, error as NSError)
            let restError = RestInternalError(code: .engine, previous: error)
            delegate?.restClient(self, sendingRequestDidFailWithError: restError, forRequest: request)
            throw restError
        }
    }

    public func send<D: Decodable> (request: RestRequest, relativeTo baseUrl: URL? = nil, expecting type: D.Type) async throws -> RestResponse<D> {
        let transportEngineResponse = try await response(for: request, relativeTo:  baseUrl)

        guard let data = transportEngineResponse.data else {
            let restError = RestInternalError(code: .noData, previous: nil)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request)
            throw restError
        }

        do {
            let object = try dataDecoder.decode(D.self, from: data)
            let headers = self.headers(fromHttpUrlResponse: transportEngineResponse.httpURLResponse)
            let restResponse = RestResponse(to: request, data: object, headers: headers)
            delegate?.restClient(self, didProduceRestResponse: restResponse, forRequest: request)
            return restResponse
        } catch {
            let restError = RestInternalError(code: .decoding, previous: error)
            delegate?.restClient(self, responseProcessingDidFailWithError: restError, forRequest: request)
            throw restError
        }
    }

    public func send (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<Void> {
        let transportEngineResponse = try await response(for: request, relativeTo:  baseUrl)
        let headers = self.headers(fromHttpUrlResponse: transportEngineResponse.httpURLResponse)
        let restResponse = RestResponse(to: request, data: Void(), headers: headers)
        delegate?.restClient(self, didProduceRestResponse: restResponse, forRequest: request)
        return restResponse
    }

    public func cancelRequest (_ request: RestRequest) {
        cancelRequest(withIdentifier: request.id)
    }

    public func cancelRequest (withIdentifier id: String) {
        transportEngine.cancelRequest(withIdentifier: id)
    }

    // MARK: HTTPURLResponse Helper

    private func headers (fromHttpUrlResponse response: HTTPURLResponse) -> [String: String] {
        var headers: [String: String] = [:]
        for header in response.allHeaderFields {
            guard let key = header.key as? String, let value = header.value as? String else {
                continue
            }
            headers[key] = value
        }
        return headers
    }

    private func restResponseErrorCode (forHttpStatusCode httpStatusCode: Int) -> RestResponseError.Code {
        restResponseErrorCode(forHttpStatus: HttpStatus(httpStatusCode))
    }

    private func restResponseErrorCode (forHttpStatus httpStatus: HttpStatus) -> RestResponseError.Code {
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
