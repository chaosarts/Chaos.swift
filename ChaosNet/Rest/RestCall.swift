//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public struct RestCall {

    public typealias Publisher = HttpRequestState.Publisher

    public let id: UUID = UUID()

    public var operation: Operation

    public var endpoint: String

    public var queries: [URLQueryItem]

    public var headers: [HttpHeader]

    public var timeout: TimeInterval?

    public var handlesCookies: Bool?

    public var cachePolicy: URLRequest.CachePolicy?

    public internal(set) var retryCount: Int = 0

    public var publisher: (any Publisher)?

    public init(_ operation: Operation = .read,
                at endpoint: String,
                queries: [URLQueryItem] = [],
                headers: [HttpHeader] = [],
                timeout: TimeInterval? = nil,
                handlesCookies: Bool? = nil,
                cachePolicy: URLRequest.CachePolicy? = nil) {
        self.operation = operation
        self.endpoint = endpoint
        self.queries = queries
        self.headers = headers
        self.timeout = timeout
        self.handlesCookies = handlesCookies
    }

    @discardableResult
    public mutating func addQuery(_ value: CustomStringConvertible? = nil, forName name: String) -> Self {
        queries.append(URLQueryItem(name: name, value: value?.description))
        return self
    }

    @discardableResult
    public mutating func addHeader(_ value: CustomStringConvertible, forName name: String) -> Self {
        headers.append(HttpHeader(name: name, value: value.description))
        return self
    }

    func urlRequest(relativeTo baseURL: URL?) throws -> URLRequest {
        guard var urlComponents = URL(string: endpoint, relativeTo: baseURL)?.components(resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queries

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = operation.httpMethod.rawValue
        request.httpBody = operation.payload

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }

        if let timeout {
            request.timeoutInterval = timeout
        }

        if let handlesCookies {
            request.httpShouldHandleCookies = handlesCookies
        }

        if let cachePolicy {
            request.cachePolicy = cachePolicy
        }

        return request
    }
}

extension RestCall {
    public enum Operation {
        case create(Data?)
        case read
        case update(Data?)
        case delete(Data?)

        var httpMethod: HttpMethod {
            switch self {
            case .create:
                .POST
            case .read:
                .GET
            case .update:
                .PUT
            case .delete:
                .DELETE
            }
        }

        var payload: Data? {
            switch self {
            case let .create(data), let .update( data), let .delete( data):
                return data
            case .read:
                return nil
            }
        }
    }
}
