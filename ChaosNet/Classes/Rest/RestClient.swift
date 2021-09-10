//
//  RestClient.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

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


    // MARK: Intialization
    
    public init (transportEngine: RestTransportEngine, dataDecoder: RestDataDecoder, dataEncoder: RestDataEncoder) {
        self.transportEngine = transportEngine
        self.dataDecoder = dataDecoder
        self.dataEncoder = dataEncoder
    }


    // MARK: Sending Requests

    @available(iOS 15, *)
    public func send<D: Decodable> (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<D> {
        do {
            let response: RestTransportEngine.Response = try await send(request: request, relativeTo:  baseUrl)
            guard let data = response.data else {
                throw RestInternalError(code: .noData, previous: nil)
            }

            let object = try dataDecoder.decode(D.self, from: data)
            let headers = self.headers(fromHttpUrlResponse: response.response)
            return RestResponse(data: object, headers: headers)
        } catch {
            delegate?.restClient(self, didReceive: error, for: request)
            throw error
        }
    }

    @available(iOS 15, *)
    public func send (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestResponse<Void> {
        do {
            let response: RestTransportEngine.Response = try await send(request: request, relativeTo:  baseUrl)
            let headers = self.headers(fromHttpUrlResponse: response.response)
            return RestResponse(data: Void(), headers: headers)
        } catch {
            delegate?.restClient(self, didReceive: error, for: request)
            throw error
        }
    }

    @available(iOS 15, *)
    private func send (request: RestRequest, relativeTo baseUrl: URL? = nil) async throws -> RestTransportEngine.Response {
        delegate?.restClient(self, willSend: request)

        for hook in hooks {
            try await hook.restClient(self, for: request)
        }

        let urlRequest = try self.urlRequest(for: request, relativeTo: baseUrl)
        let response = try await transportEngine.send(request: urlRequest)

        let httpStatus = HttpStatus(response.response.statusCode)
        let clientShouldFailForStatus: Bool
        if httpStatus.category != .success {
            clientShouldFailForStatus = delegate?.restClient(self, shouldFailForStatus: response.response.statusCode) ?? true
        } else {
            clientShouldFailForStatus = false
        }

        if clientShouldFailForStatus {
            switch httpStatus.category {
            case .information, .redirection:
                throw RestResponseError(code: .invalidStatus, response: response.response, data: response.data)
            case .clientError:
                throw RestResponseError(code: .clientError, response: response.response, data: response.data)
            case .serverError:
                throw RestResponseError(code: .serverError, response: response.response, data: response.data)
            case .proprietaryError:
                throw RestResponseError(code: .proprietaryError, response: response.response, data: response.data)
            default:
                break
            }
        }

        return response
    }

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
                    let restResponse = RestResponse(data: object, headers: headers)
                    self.delegate?.restClient(self, didReceive: restResponse, for: request)
                    completion(.success(restResponse))
                } catch {
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
                let data: Void
                let headers = self.headers(fromHttpUrlResponse: transportEngineResponse.response)
                let restResponse = RestResponse<Void>(data: data, headers: headers)
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

            transportEngine.send(request: urlRequest, completion: { (response, error) in
                if let error = self.evaluateReponse(response, error: error) {
                    self.delegate?.restClient(self, didReceive: error, for: request)
                    completion(.failure(error))
                    return
                }

                guard let response = response else {
                    completion(.failure(RestInternalError(code: .badEngineImplementation)))
                    return
                }

                completion(.success(response))
            })

            delegate?.restClient(self, didSend: request)
        } catch {
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

    public func evaluateReponse (_ response: RestTransportEngine.Response?, error: Error?) -> Error? {
        if let error = error {
            return RestInternalError(code: .engine, previous: error)
        }

        guard let response = response else {
            return RestInternalError(code: .badEngineImplementation)
        }

        guard delegate?.restClient(self, shouldFailForStatus: response.response.statusCode) ?? true else {
            return nil
        }

        let httpStatus = HttpStatus(response.response.statusCode)
        switch httpStatus.category {
        case .information, .redirection:
            return RestResponseError(code: .invalidStatus, response: response.response, data: response.data)
        case .clientError:
            return RestResponseError(code: .clientError, response: response.response, data: response.data)
        case .serverError:
            return RestResponseError(code: .serverError, response: response.response, data: response.data)
        case .proprietaryError:
            return RestResponseError(code: .proprietaryError, response: response.response, data: response.data)
        default:
            return nil
        }
    }
}
