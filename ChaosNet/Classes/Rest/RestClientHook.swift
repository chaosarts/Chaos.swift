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

public protocol PostRequestHook {
    func restClient(_ restClient: RestClient, didReceiveResponse response: RestTransportEngineResponse, for request: RestRequest, relativeTo baseUrl: URL?)
}

public protocol ProcessResponseHook {
    func restClient<D>(_ restClient: RestClient, didProduceResponse response: RestResponse<D>) -> RestResponse<D>
}
