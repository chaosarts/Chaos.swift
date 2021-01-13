//
//  ApiError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation
import ChaosCore

/// Base class for api related errors.
open class ApiError<Code: RawRepresentable>: ChaosError where Code.RawValue == Int  {

    /// Provides the code of the error to differ between different types.
    public let code: Code

    /// Provides the api request to which the error is related to.
    public let request: ApiRequest

    /// Provides the optional error that caused the api error.
    public let previous: Error?

    /// Initializes the api error.
    internal init (code: Code, request: ApiRequest, previous: Error? = nil) {
        self.code = code
        self.request = request
        self.previous = previous
    }
}
