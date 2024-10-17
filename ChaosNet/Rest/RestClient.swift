//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

@dynamicMemberLookup
public class RestClient {

    public var httpEngine: HttpEngine = .urlSession

    public var decoder: RestDataDecoder = JSONDecoder()

    public var encoder: RestDataEncoder = JSONEncoder()

    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<HttpEngine, Value>) -> Value {
        get { httpEngine[keyPath: keyPath] }
        set { httpEngine[keyPath: keyPath] = newValue }
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<HttpEngine, Value>) -> Value {
        httpEngine[keyPath: keyPath]
    }

    public init() {}

    public func data<Data>(for restCall: RestCall, relativeTo baseURL: URL? = nil) async throws -> RestResponse<Data> where Data: Decodable {
        let urlRequest = try restCall.urlRequest(relativeTo: baseURL)
        let response = try await httpEngine.data(for: urlRequest, publisher: restCall.publisher)
        let data = try decoder.decode(Data.self, from: response.0)
        return RestResponse(data, httpResponse: response.1)
    }

    public func data(for restCall: RestCall, relativeTo baseURL: URL? = nil) async throws -> RestResponse<Void> {
        let urlRequest = try restCall.urlRequest(relativeTo: baseURL)
        let response = try await httpEngine.data(for: urlRequest, publisher: restCall.publisher)
        return RestResponse(httpResponse: response.1)
    }


    public func create<Input, Output>(at endpoint: String, with input: Input, relativeTo baseURL: URL? = nil) async throws -> RestResponse<Output> where Input: Encodable, Output: Decodable {
        try await data(for: RestCall(.create(encoder.encode(input)),
                                     at: endpoint,
                                     queries: [],
                                     headers: []),
                       relativeTo: baseURL)
    }
}
