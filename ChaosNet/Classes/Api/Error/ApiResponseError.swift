//
//  ApiResponseError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation

@objc open class ApiResponseError: NSObject, CustomNSError {
    public let code: Code
    public let request: ApiRequest
    public let httpResponse: HTTPURLResponse
    public let data: Data?
    public let previous: Error?

    internal init (code: Code, request: ApiRequest, response: HTTPURLResponse, data: Data?, previous: Error? = nil) {
        self.code = code
        self.request = request
        self.httpResponse = response
        self.data = data
        self.previous = previous
    }
}

@objc public extension ApiResponseError {
    @objc enum Code: Int {
        case noResponseData
        case decodingError
        case clientError
        case serverError
        case `internal`
    }
}
