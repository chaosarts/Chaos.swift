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

    @discardableResult
    public func rawData(for restCall: RestCall, relativeTo baseURL: URL? = nil) async throws -> HttpEngine.DataResponse {
        let urlRequest = try restCall.urlRequest(relativeTo: baseURL)
        return try await httpEngine.data(for: urlRequest, publisher: restCall.publisher)
    }

    public func data<Data>(for restCall: RestCall, relativeTo baseURL: URL? = nil) async throws(RestError) -> RestResponse<Data> where Data: Decodable {
        let response: HttpEngine.DataResponse
        do {
            response = try await rawData(for: restCall, relativeTo: baseURL)
        } catch {
            throw RestError.engineError(error)
        }

        do {
            let data = try decoder.decode(Data.self, from: response.0)
            return RestResponse(data, httpResponse: response.1)
        } catch {
            throw .invalidDataResponse(response)
        }
    }

    public func data(for restCall: RestCall, relativeTo baseURL: URL? = nil) async throws -> RestResponse<Void> {
        do {
            let response = try await rawData(for: restCall, relativeTo: baseURL)
            return RestResponse(httpResponse: response.1)
        } catch {
            throw RestError.engineError(error)
        }
    }

    public func create<Input, Output>(at endpoint: String, with input: Input, relativeTo baseURL: URL? = nil) async throws -> RestResponse<Output> where Input: Encodable, Output: Decodable {
        try await data(for: RestCall(.create(encoder.encode(input)),
                                     at: endpoint,
                                     queries: [],
                                     headers: []),
                       relativeTo: baseURL)
    }
}
