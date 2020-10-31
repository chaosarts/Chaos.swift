//
//  ApiError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 31.10.20.
//

import Foundation
import ChaosCore

open class ApiError<Code: RawRepresentable>:
    ChaosError where Code.RawValue == Int  {

    public let code: Code

    public let request: ApiRequest

    public let previous: Error?

    internal init (code: Code, request: ApiRequest, previous: Error? = nil) {
        self.code = code
        self.request = request
        self.previous = previous
    }
}
