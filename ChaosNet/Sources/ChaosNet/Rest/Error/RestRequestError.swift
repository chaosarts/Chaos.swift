//
//  RestEndpointError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public struct RestRequestError {
    public let code: Code
}

extension RestRequestError: RestError {
    @objc public enum Code: Int, RawRepresentable {
        case badEndpointPath
    }
}
