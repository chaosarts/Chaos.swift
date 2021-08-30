//
//  RestRequest.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public class RestRequest {

    public let action: Action

    public let endpoint: Endpoint

    public var headers: [String: String] = [:]

    public var payload: Data?

    public var queryParameters: [String: String?] {
        get { endpoint.parameters }
        set { endpoint.parameters = newValue }
    }

    public init (_ endpoint: Endpoint, action: Action = .retrieve) {
        self.endpoint = endpoint
        self.action = action
    }

    @discardableResult
    public func setHeader (_ name: String, value: String) -> Self {
        headers.updateValue(value, forKey: name)
        return self
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
    public func setPayload (_ payload: Data?) -> Self {
        self.payload = payload
        return self
    }
}


public extension RestRequest {
    
    typealias CachePolicy = URLRequest.CachePolicy

    enum Action {
        case create
        case retrieve
        case update
        case delete
    }

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
