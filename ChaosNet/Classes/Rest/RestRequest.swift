//
//  RestRequest.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public class RestRequest {

    // MARK: - Nested Types

    public typealias CachePolicy = URLRequest.CachePolicy

    public typealias Method = HttpMethod


    // MARK: - Properties

    /// The id of the request. This is used by the rest client in order to distinguish requests for cancellation.
    public let id: String = UUID().uuidString

    /// The method to use for this request.
    public var method: Method

    /// The target endpoint to send the request to.
    public var endpoint: Endpoint

    /// Headers to enrich the request. This will be used for the resulting url request.
    public var headers: [String: String] = [:]

    public var payload: Data?

    public var queryParameters: [String: String?] {
        get { endpoint.parameters }
        set { endpoint.parameters = newValue }
    }

    /// Indicates, how many retries has been performed on this request.
    public internal(set) var rescueCount: Int = 0

    /// Spacifies in which way to consider caches, this will overwrite the default behaviour of the rest client, that
    /// sends this request.
    public var cachePolicy: CachePolicy?

    /// Specifies whether the reqest request should use cookies for the resulting url request or not. If not specified
    /// the default of the rest client is taken into account.
    public var shouldUseHttpCookies: Bool?

    /// Provides the time interval to wait before the request should timeout. If not set, the default timeout of the
    /// rest client sending the request will be used.
    public var timeoutInterval: TimeInterval?

    private let encoder: RestDataEncoder

    public init (_ endpoint: Endpoint, method: Method = .GET, encoder: RestDataEncoder) {
        self.endpoint = endpoint
        self.method = method
        self.encoder = encoder
    }

    @discardableResult
    public func setHeader (_ name: String, value: String) -> Self {
        headers.updateValue(value, forKey: name)
        return self
    }

    @discardableResult
    public func setContentType (_ contentType: String) -> Self {
        setHeader("Content-Type", value: contentType)
    }

    @discardableResult
    public func setHeaders (_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }

    @discardableResult
    public func mergeHeaders (_ headers: [String: String]) -> Self {
        self.headers.merge(headers, uniquingKeysWith: { current, _ in current })
        return self
    }

    @discardableResult
    public func overrideHeaders (_ headers: [String: String]) -> Self {
        self.headers.merge(headers, uniquingKeysWith: { _, new in new })
        return self
    }

    @discardableResult
    public func removeHeader (_ name: String) -> String? {
        headers.removeValue(forKey: name)
    }

    public func containsHeader (_ name: String) -> Bool {
        headers.contains(where: { $0.key == name })
    }

    @discardableResult
    public func setQueryParameter (_ name: String, value: String?) -> Self {
        endpoint.setParameter(name, value: value)
        return self
    }

    @discardableResult
    public func setQueryParameters (_ parameters: [String: String?]) -> Self {
        endpoint.setParameters(parameters)
        return self
    }

    @discardableResult
    public func mergeQueryParameters (_ parameters: [String: String?]) -> Self {
        endpoint.mergeParameters(parameters)
        return self
    }

    @discardableResult
    public func overrideQueryParameters (_ parameters: [String: String?]) -> Self {
        endpoint.overrideParameters(parameters)
        return self
    }

    @discardableResult
    public func removeQueryParameter (_ name: String) -> Self {
        endpoint.removeParameter(name)
        return self
    }

    public func containsQueryParameter (_ name: String) -> Bool {
        endpoint.containsParameter(name)
    }

    @discardableResult
    public func setPayload<E: Encodable> (_ encodable: E) -> Self {
        self.payload = try? encoder.encode(encodable)
        return self
    }

    @discardableResult
    public func setPayload (_ payload: Data) -> Self {
        self.payload = payload
        return self
    }

    public func setPayload(withParameters parameters: [String: String], files: [String]) {
        
    }
}


public extension RestRequest {

    class Endpoint: ExpressibleByStringLiteral {

        public let path: String

        public var parameters: [String: String?]

        public init (_ path: String, parameters: [String: String?] = [:]) {
            self.path = path
            self.parameters = parameters
        }

        public required convenience init(stringLiteral value: String) {
            self.init(value)
        }

        @discardableResult
        public func setParameter (_ name: String, value: String? = nil) -> Self {
            parameters.updateValue(value, forKey: name)
            return self
        }

        @discardableResult
        public func setParameters (_ parameters: [String: String?]) -> Self {
            self.parameters = parameters
            return self
        }

        @discardableResult
        public func mergeParameters (_ parameters: [String: String?]) -> Self {
            self.parameters.merge(parameters) { current, _ in current }
            return self
        }

        @discardableResult
        public func overrideParameters (_ parameters: [String: String?]) -> Self {
            self.parameters.merge(parameters) { _, new in new }
            return self
        }

        @discardableResult
        public func removeParameter (_ name: String) -> Self {
            parameters.removeValue(forKey: name)
            return self
        }

        public func containsParameter (_ name: String) -> Bool {
            parameters.contains(where: { $0.key == name })
        }
    }
}

extension RestRequest: URLRequestConvertible {
    public func urlRequest(relativeTo baseURL: URL? = nil) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw URLError(.badURL)
        }

        if !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map({
                URLQueryItem(name: $0.key, value: $0.value)
            })
        }

        guard let url = urlComponents.url(relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        let defaultURLRequest = URLRequest(url: url)
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: cachePolicy ?? defaultURLRequest.cachePolicy,
                                    timeoutInterval: timeoutInterval ?? defaultURLRequest.timeoutInterval)

        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpShouldHandleCookies = shouldUseHttpCookies ?? true
        urlRequest.httpBody = payload
        return urlRequest
    }
}
