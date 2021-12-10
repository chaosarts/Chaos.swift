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
    public var requestTimeout: TimeInterval = 30

    /// Specifies the policy to use for caching
    public var cachePolicy: RestRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    public var hooks: [RestClientHook] = []


    private let log: Log = Log(RestClient.self)


    // MARK: Intialization
    
    public init (transportEngine: RestTransportEngine, dataDecoder: RestDataDecoder, dataEncoder: RestDataEncoder) {
        self.transportEngine = transportEngine
        self.dataDecoder = dataDecoder
        self.dataEncoder = dataEncoder
    }


    // MARK: Sending Requests

//    public func send<D: Decodable> (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<D> {
//        do {
//            let response: RestTransportEngine.Response = try await send(request: request, relativeTo:  baseUrl)
//            guard let data = response.data else {
//                throw RestInternalError(code: .noData, previous: nil)
//            }
//
//            let object = try dataDecoder.decode(D.self, from: data)
//            let headers = self.headers(fromHttpUrlResponse: response.response)
//            return RestResponse(data: object, headers: headers)
//        } catch {
//            delegate?.restClient(self, didReceive: error, for: request)
//            throw error
//        }
//    }
//
//    @available(iOS 15, *)
//    public func send (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<Void> {
//        do {
//            let response: RestTransportEngine.Response = try await send(request: request, relativeTo:  baseUrl)
//            let headers = self.headers(fromHttpUrlResponse: response.response)
//            return RestResponse(data: Void(), headers: headers)
//        } catch {
//            delegate?.restClient(self, didReceive: error, for: request)
//            throw error
//        }
//    }
//
//    @available(iOS 15, *)
//    private func send (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestTransportEngine.Response {
//        delegate?.restClient(self, willSend: request)
//
//        for hook in hooks {
//            try await hook.restClient(self, for: request)
//        }
//
//        let urlRequest = try self.urlRequest(for: request, relativeTo: baseUrl)
//        let response = try await transportEngine.send(request: urlRequest)
//
//        let httpStatus = HttpStatus(response.response.statusCode)
//        let clientShouldFailForStatus: Bool
//        if httpStatus.category != .success {
//            clientShouldFailForStatus = delegate?.restClient(self, shouldFailForStatus: response.response.statusCode) ?? true
//        } else {
//            clientShouldFailForStatus = false
//        }
//
//        if clientShouldFailForStatus {
//            switch httpStatus.category {
//            case .information, .redirection:
//                throw RestResponseError(code: .invalidStatus, response: response.response, data: response.data)
//            case .clientError:
//                throw RestResponseError(code: .clientError, response: response.response, data: response.data)
//            case .serverError:
//                throw RestResponseError(code: .serverError, response: response.response, data: response.data)
//            case .proprietaryError:
//                throw RestResponseError(code: .proprietaryError, response: response.response, data: response.data)
//            default:
//                break
//            }
//        }
//
//        return response
//    }

    public func send<D: Decodable> (request: RestRequest, relativeTo baseUrl: URL? = nil, expecting: D.Type, completion: @escaping (RestResult<RestResponse<D>>) -> Void) {
        send(request: request, relativeTo: baseUrl) { (result: RestResult<RestTransportEngine.Response>) in
            switch result {
            case .success(let transportEngineResponse):
                guard let data = transportEngineResponse.data else {
                    let error = RestInternalError(code: .noData)
                    self.delegate?.restClient(self, didReceive: error, for: request)
                    completion(.failure(error))
                    return
                }

                do {
                    let headers = self.headers(fromHttpUrlResponse: transportEngineResponse.response)
                    let object: D = try self.dataDecoder.decode(D.self, from: data)
                    let restResponse = RestResponse(to: request, data: object, headers: headers)
                    self.delegate?.restClient(self, didReceive: restResponse, for: request)
                    completion(.success(restResponse))
                } catch {
                    self.log.error(format: "Unable to decode response of request %@", request.id)
                    self.delegate?.restClient(self, didReceive: error, for: request)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func send (request: RestRequest, relativeTo baseUrl: URL? = nil, completion: @escaping (RestResult<RestResponse<Void>>) -> Void) {
        send(request: request, relativeTo: baseUrl) { (result: RestResult<RestTransportEngine.Response>) in
            switch result {
            case .success(let transportEngineResponse):
                let headers = self.headers(fromHttpUrlResponse: transportEngineResponse.response)
                let restResponse = RestResponse<Void>(to: request, headers: headers)
                completion(.success(restResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func send (request: RestRequest, relativeTo baseUrl: URL?, completion: @escaping (RestResult<RestTransportEngine.Response>) -> Void) {
        do {
            delegate?.restClient(self, willSend: request)
            let urlRequest = try self.urlRequest(for: request, relativeTo: baseUrl)

            log.info(format: "Sending request %@ to %@", request.id, urlRequest.url?.absoluteString ?? "-")

            transportEngine.send(request: urlRequest, completion: { result in
                switch result {
                case .failure(let error):
                    self.log.error(format: "Rest transport engine failed to send request %@ with error %@", request.id, error as NSError)

                    self.delegate?.restClient(self, didReceive: error, for: request)
                    completion(.failure(RestInternalError(code: .engine, previous: error)))
                case .success(let transportEngineResponse):
                    let httpStatusCode = transportEngineResponse.response.statusCode

                    self.log.info(format: "Rest request %@ returned with status %@", request.id, httpStatusCode)
                    self.log.debug(format: "%@", transportEngineResponse.debugDescription)

                    guard delegate?.restClient(self, shouldFailForStatus: httpStatusCode) != true else {

                        self.log.error(format: "Rest client delegate decided to fail for request %@ returned with status %@", request.id, httpStatusCode)

                        let error = RestResponseError(code: restResponseErrorCode(forHttpStatusCode: httpStatusCode), response: transportEngineResponse.response)
                        self.delegate?.restClient(self, didReceive: error, for: request)
                        completion(.failure(error))
                        return
                    }

                    completion(.success(transportEngineResponse))
                }
            })

            delegate?.restClient(self, didSend: request)
        } catch {
            log.error(format: "Rest request failed with error %@", error as NSError)
            delegate?.restClient(self, didReceive: error, for: request)
            completion(.failure(error))
        }
    }


    // MARK: URL Request Helper

    public func urlRequest (for request: RestRequest, relativeTo baseUrl: URL?) throws -> URLRequest {
        let url = try self.url(for: request, relativeTo: baseUrl)

        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: requestTimeout)
        request.headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpShouldHandleCookies = delegate?.restClient(self, shouldUseHttpCookiesFor: request) ?? true
        urlRequest.httpBody = request.payload
        return urlRequest
    }

    public func url (for request: RestRequest, relativeTo baseURL: URL?) throws -> URL {
        guard var urlComponents = URLComponents(string: request.endpoint.path) else {
            throw RestRequestError(code: .badEndpointPath)
        }

        urlComponents.queryItems = request.queryParameters.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })

        guard let url = urlComponents.url(relativeTo: baseURL) else {
            throw RestRequestError(code: .badEndpointPath)
        }

        return url
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

    public func restResponseErrorCode(forHttpStatusCode httpStatusCode: Int) -> RestResponseError.Code {
        restResponseErrorCode(forHttpStatus: HttpStatus(httpStatusCode))
    }

    public func restResponseErrorCode(forHttpStatus httpStatus: HttpStatus) -> RestResponseError.Code {
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
