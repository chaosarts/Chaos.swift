//
//  ChaosMetalError.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import ChaosCore

public class EnvironmentError: ChaosError {

    public enum Code: Int {
        case noCommandQueue
        case noCommandBuffer
        case noLibrary
        case functionNotFound
        case noBuffer
        case noCommandEncoder
        case invalidNumberOfBuffers
    }

    public let code: Code

    public let message: String?

    public let previous: Error?

    public init (code: Code, message: String? = nil, previous: Error? = nil) {
        self.code = code
        self.message = message
        self.previous = previous
    }
}
