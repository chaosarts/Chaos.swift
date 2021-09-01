//
//  RestClientHook.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 01.09.21.
//

import Foundation

public protocol RestClientHook {
    func restClient (_ restClient: RestClient, willSendRequest request: RestRequest, completion: (RestRequest) -> Void)
    func restClient (_ restClient: RestClient, didReceiveResponse response: RestTransportEngine.Response)
}
