//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 02.06.22.
//

import Foundation

public protocol RestClientHook: AnyObject {
    var identifier: String? { get }
}

public extension RestClientHook {
    var identifier: String? { nil }
}

public protocol PreRequestHook: RestClientHook {
    func restClient(_ restClient: RestClient, willSendRequest request: RestRequest, relativeTo baseUrl: URL?) async throws
}

public protocol PostRequestHook: RestClientHook {
    func restClient(_ restClient: RestClient, didReceiveRawResponse request: RestRawResponse, for request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestRawResponse
}

public protocol PreRawResponseProcessHook: RestClientHook {
    func restClient(_ restClient: RestClient, willProcessRawResponse response: RestRawResponse, for request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestRawResponse
}

public protocol PostRawResponseProcessHook: RestClientHook {
    func restClient<D>(_ restClient: RestClient, didProcessRawResponseTo response: RestResponse<D>, for request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestResponse<D>
}
