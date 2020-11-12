//
//  ApiResponseError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation

open class ApiResponseError: ApiError<ApiResponseError.Code> {
    public let httpResponse: HTTPURLResponse
    
    public let data: Data?

    internal init (code: Code, request: ApiRequest, response: HTTPURLResponse, data: Data?, previous: Error? = nil) {
        self.httpResponse = response
        self.data = data
        super.init(code: code, request: request, previous: previous)
    }
}

@objc public extension ApiResponseError {
    @objc enum Code: Int {

        /// Indicates, that there was no data to decode in the http response body.
        /// 
        case noResponseData
        case decodingError
        case clientError
        case serverError
        case `internal`
    }
}
