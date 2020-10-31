//
//  ApiRequestError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation

@objc open class ApiRequestError: NSObject, CustomNSError {

    public let code: Code

    public let request: ApiRequest

    public let previous: Error?
    
    internal init (code: Code, request: ApiRequest, previous: Error? = nil) {
        self.code = code
        self.request = request
        self.previous = previous
    }
}

public extension ApiRequestError {
    @objc enum Code: Int {
        case invalidEndpoint
        case invalidParameter
        case encodingError
        case cancelled
        case timedOut
        case noInternetConnection
        case serviceUnavailable
        case `internal`
    }
}
