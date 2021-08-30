//
//  RestTransportEngine.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestTransportEngine {
    typealias Response = (response: HTTPURLResponse, data: Data?)
    func send (request: URLRequest, completion: (Response?, Error?) -> Void)
}
