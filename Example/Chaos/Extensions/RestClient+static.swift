//
//  RestClient+static.swift
//  Webservice
//
//  Created by Fu Lam Diep on 01.09.21.
//

import Foundation
import ChaosNet

public extension RestClient {
    static let `default`: RestClient = {
        let transportEngine = AlamofireRestTransportEngine()
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        return RestClient(transportEngine: transportEngine,
                          dataDecoder: decoder,
                          dataEncoder:encoder)
    }()
}
