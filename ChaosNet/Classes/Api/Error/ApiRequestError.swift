//
//  ApiRequestError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation
import ChaosCore

open class ApiRequestError: ApiError<ApiRequestError.Code> {}


// MARK: -

public extension ApiRequestError {
    @objc enum Code: Int {

        /// Indicates, that mapping the endpoint and the parameters to a relative
        /// url path failed.
        case invalidEndpoint

        /// Indicates, that parameters of an api request could not be translated
        /// to the http url request body.
        case invalidParameter

        /// Indicates, that an object could not be encoded to payload data.
        case encodingError

        /// Indicates, that the related api request has been cancelled.
        case cancelled

        /// Indicates, that the related api request has timed out.
        case timedOut

        /// Indicates, that there was no internet connection when attempting to
        /// send a the request.
        case noInternetConnection

        /// Indicates that the server is not available (host not found, dns lookup
        /// failed, etc).
        case serviceUnavailable

        /// Indicates, that an error occured that is covered, by the other cases.
        ///
        /// Certain http request errors such as certificate problems or exceeded
        /// data size should not be part of the api level to handle. Such problems
        /// should not occur on a properly setup api.
        case `internal`
    }
}
