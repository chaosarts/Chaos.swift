//
//  ApiClientTransportEngine.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 30.10.20.
//

import Foundation
import ChaosCore

public typealias HttpResponse = (httpResponse: HTTPURLResponse, data: Data?)

public protocol ApiClientTransportEngine: AnyObject {

    /// Tells the engine to send the given url request and return a promise, that
    /// resolves with an http response, if successful.
    func send (urlRequest: URLRequest) -> Promise<HttpResponse>
}
