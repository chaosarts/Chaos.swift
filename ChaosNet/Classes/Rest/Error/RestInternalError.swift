//
//  RestInternalError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public struct RestInternalError {
    public let code: Code

    public let previous: Error?

    public init (code: Code, previous: Error? = nil) {
        self.code = code
        self.previous = previous
    }
}

extension RestInternalError: RestError {
    @objc public enum Code: Int, RawRepresentable {
        case badEngineImplementation
        case engine
        case noData
        case decoding
    }
}
