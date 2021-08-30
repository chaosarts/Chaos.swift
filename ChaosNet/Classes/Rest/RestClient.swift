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


    // MARK: Intialization
    
    public init (transportEngine: RestTransportEngine, dataDecoder: RestDataDecoder, dataEncoder: RestDataEncoder) {
        self.transportEngine = transportEngine
        self.dataDecoder = dataDecoder
        self.dataEncoder = dataEncoder
    }

    public func send<D: Decodable> (request: RestRequest, relativeTo baseUrl: URL? = nil, completion: (RestResult<D>) -> Void) throws {

        delegate?.restClient(self, willSend: request)
        let urlRequest = try self.urlRequest(for: request, relativeTo: baseUrl)

        transportEngine.send(request: urlRequest, completion: { (response, error) in
            if let error = self.evaluateReponse(response, error: error) {
                completion(.failure(error))
                self.delegate?.restClient(self, didReceive: error, for: request)
                return
            }

            guard let data = response?.data else {
                let error = RestInternalError(code: .noData)
                completion(.failure(error))
                self.delegate?.restClient(self, didReceive: error, for: request)
                return
            }

            do {
                let object: D = try self.dataDecoder.decode(D.self, from: data)
                let restResponse = RestResponse(data: object, headers: [:])
                completion(.success(restResponse))
                self.delegate?.restClient(self, didReceive: restResponse, for: request)
            } catch {
                let error = RestInternalError(code: .decoding, previous: error)
                completion(.failure(error))
                self.delegate?.restClient(self, didReceive: error, for: request)
            }
        })
        delegate?.restClient(self, didSend: request)
    }

    public func send (request: RestRequest, relativeTo baseUrl: URL? = nil, completion: (RestResult<Void>) -> Void) throws {
        delegate?.restClient(self, willSend: request)
        let urlRequest = try self.urlRequest(for: request, relativeTo: baseUrl)

        transportEngine.send(request: urlRequest, completion: { (response, error) in
            if let error = self.evaluateReponse(response, error: error) {
                completion(.failure(error))
                self.delegate?.restClient(self, didReceive: error, for: request)
                return
            }

            let void: Void
            let restResponse = RestResponse(data: void, headers: [:])
            completion(.success(restResponse))
            self.delegate?.restClient(self, didReceive: restResponse, for: request)
        })
        delegate?.restClient(self, didSend: request)
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

    public func urlRequest (for request: RestRequest, relativeTo baseUrl: URL?) throws -> URLRequest {
        let url = try self.url(for: request, relativeTo: baseUrl)

        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: requestTimeout)
        request.headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpMethod = httpMethod(for: request).rawValue
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

    public func httpMethod (for request: RestRequest) -> HttpMethod {
        if let delegate = delegate {
            return delegate.restClient(self, httpMethodFor: request)
        }

        switch request.action {
        case .create:
            return .POST
        case .retrieve:
            return .GET
        case .update:
            return .PUT
        case .delete:
            return .DELETE
        }
    }
}
