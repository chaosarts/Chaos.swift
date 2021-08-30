//
//  RestResponseError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public struct RestResponseError {
    public let code: Code
    public let response: HTTPURLResponse
    public let data: Data?

    public init (code: Code, response: HTTPURLResponse, data: Data? = nil) {
        self.code = code
        self.response = response
        self.data = data
    }
}

extension RestResponseError: RestError {
    @objc public enum Code: Int, RawRepresentable {
        case invalidStatus
        case proprietaryError
        case clientError
        case serverError
    }
}
