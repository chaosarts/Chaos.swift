//
//  RestResult.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public class RestResponse<D> {

    public let data: D
    public let headers: [String: String]

    public init (data: D, headers: [String: String] = [:]) {
        self.data = data
        self.headers = headers
    }
}
