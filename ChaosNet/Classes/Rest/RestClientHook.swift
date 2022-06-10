//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 02.06.22.
//

import Foundation

public protocol PreRequestHook {
    func restClient(_ restClient: RestClient, willSendRequest request: RestRequest, relativeTo baseUrl: URL?) async
}

public protocol RescueRequestHook {
    func restClient(_ restClient: RestClient, rescueRequest request: RestRequest, relativeTo baseUrl: URL?) async throws -> RestTransportEngineResponse
}
