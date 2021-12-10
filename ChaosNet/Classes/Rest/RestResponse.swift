//
//  RestResult.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public class RestResponse<D> {

    public let request: RestRequest

    public let data: D

    public let headers: [String: String]

    public init (to request: RestRequest, data: D, headers: [String: String] = [:]) {
        self.request = request
        self.data = data
        self.headers = headers
    }
}

public extension RestResponse where D == Void {
    public convenience init (to request: RestRequest, headers: [String: String] = [:]) {
        let void: Void
        self.init(to: request, data: void, headers: headers)
    }
}
