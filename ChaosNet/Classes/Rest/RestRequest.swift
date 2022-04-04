//
//  RestRequest.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public class RestRequest: CustomStringConvertible {

    // MARK: - Nested Types

    public typealias CachePolicy = URLRequest.CachePolicy

    public typealias Method = HttpMethod


    // MARK: - Properties

    /// The id of the request. This is used by the rest client in order to distinguish requests for cancellation.
    public let id: String = UUID().uuidString

    /// The target endpoint to send the request to.
    public let endpoint: Endpoint

    /// The method to use for this request.
    public var method: Method {
        endpoint.method
    }

    /// Provides a dictionary where key is the placeholder name in the endpoint template and value is the value to set
    /// in place.
    public private (set) var parameters: [String: String] = [:]

    /// Returns the endpoint where placeholders are replaced with the values of `parameters`.
    public var path: String {
        endpoint.path(parameters: parameters)
    }

    /// Headers to enrich the request. This will be used for the resulting url request.
    private var headersByNames: [String: HttpHeader] = [:]

    ///
    public var headers: [String: String] {
        var headers: [String: String] = [:]
        for (_, header) in headersByNames {
            headers[header.name] = header.value
        }
        return headers
    }

    public private(set) var queryParameters: [String: String?] = [:]

    /// Provides the payload to be sent
    public private(set) var payload: Data?

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

    public var description: String {
        var lines: [String] = [method.rawValue]
        lines += headersByNames.values.map { $0.description }

        var path = path
        if !queryParameters.isEmpty {
            path += "?" + queryParameters.map { key, value in
                var string = key
                if let value = value {
                    string += "=\(value)"
                }
                return string
            }.joined(separator: "&")
        }
        lines.append(path)

        if let data = payload, let string = String(data: data, encoding: .utf8) {
            lines.append(string)
        }

        return lines.joined(separator: "\n")
    }

    // MARK: Initialization

    public init (_ endpoint: Endpoint, encoder: RestDataEncoder) {
        self.endpoint = endpoint
        self.encoder = encoder
    }

    public convenience init (_ method: Method = .GET, at path: String, encoder: RestDataEncoder) {
        self.init(Endpoint(method, at: path), encoder: encoder)
    }


    // MARK: Manage Headers

    @discardableResult
    public func setHeader (_ name: String, value: String) -> Self {
        headersByNames.updateValue(HttpHeader(name: name, value: value), forKey: name.lowercased())
        return self
    }

    @discardableResult
    public func setHeaders (_ headers: [String: String]) -> Self {
        headersByNames = [:]
        headers.forEach { name, value in
            self.setHeader(name, value: value)
        }
        return self
    }

    @discardableResult
    public func mergeHeaders (_ headers: [String: String]) -> Self {
        headers.forEach { name, value in
            let key = name.lowercased()
            guard headersByNames[key] == nil else { return }
            headersByNames[key] = HttpHeader(name: name, value: value)
        }
        return self
    }

    @discardableResult
    public func overrideHeaders (_ headers: [String: String]) -> Self {
        headers.forEach { name, value in
            let key = name.lowercased()
            headersByNames[key] = HttpHeader(name: name, value: value)
        }
        return self
    }

    @discardableResult
    public func removeHeader (_ name: String) -> String? {
        headersByNames.removeValue(forKey: name.lowercased())?.value
    }

    public func header (forName name: String) -> String? {
        headersByNames[name.lowercased()]?.value
    }

    public func containsHeader (_ name: String) -> Bool {
        headersByNames.contains { key, _ in
            key == name.lowercased()
        }
    }

    @discardableResult
    public func setContentType (_ contentType: String) -> Self {
        setHeader("Content-Type", value: contentType)
    }

    public func contentType () -> String? {
        header(forName: "Content-Type")
    }


    // MARK: Managing Query Parameters

    @discardableResult
    public func setQueryParameter (_ name: String, value: String?) -> Self {
        queryParameters.updateValue(value, forKey: name)
        return self
    }

    @discardableResult
    public func setQueryParameters (_ parameters: [String: String?]) -> Self {
        queryParameters = parameters
        return self
    }

    @discardableResult
    public func mergeQueryParameters (_ parameters: [String: String?]) -> Self {
        queryParameters.merge(parameters) { current, _ in current }
        return self
    }

    @discardableResult
    public func overrideQueryParameters (_ parameters: [String: String?]) -> Self {
        queryParameters.merge(parameters) { _, new in new }
        return self
    }

    @discardableResult
    public func removeQueryParameter (_ name: String) -> Self {
        queryParameters.removeValue(forKey: name)
        return self
    }

    public func containsQueryParameter (_ name: String) -> Bool {
        queryParameters.contains { key, _ in name == key }
    }

    @discardableResult
    public func setParameter (_ name: String, value: String) -> Self {
        parameters.updateValue(value, forKey: name)
        return self
    }

    @discardableResult
    public func setParameters (_ parameters: [String: String]) -> Self {
        self.parameters = parameters
        return self
    }

    @discardableResult
    public func setPayload<E: Encodable> (_ encodable: E) -> Self {
        setPayload(try? encoder.encode(encodable))
    }

    @discardableResult
    public func setPayload (_ payload: Data? = nil) -> Self {
        self.payload = payload
        return self
    }

    public func setPayload(withParameters parameters: [String: String], files: [String]) {
        
    }
}


public extension RestRequest {

    struct Endpoint: ExpressibleByStringLiteral {

        public let method: Method

        public let template: String

        public init(_ method: Method = .GET, at template: String) {
            self.method = method
            self.template = template
        }

        public init(stringLiteral value: String) {
            self.init(.GET, at: value)
        }

        public func path(parameters: [String: String] = [:]) -> String {
            var template = template
            parameters.forEach { key, value in
                template = template.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return template
        }
    }
}

extension RestRequest: URLRequestConvertible {
    public func urlRequest(relativeTo baseURL: URL? = nil) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: path) else {
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
