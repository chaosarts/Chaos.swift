//
//  ApiRequestError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation

open class ApiRequestError: ApiError<ApiRequestError.Code> {
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
