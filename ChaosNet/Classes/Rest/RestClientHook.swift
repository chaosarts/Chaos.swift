//
//  RestClientHook.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 01.09.21.
//

import Foundation

@available(iOS 15, *)
public protocol RestClientHook {

    var identifier: String { get }

    func restClient (_ restClient: RestClient, for request: RestRequest) async throws
}
