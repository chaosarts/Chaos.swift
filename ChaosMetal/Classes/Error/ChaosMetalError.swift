//
//  ChaosMetalError.swift
//  ChaosMetal
//
//  Created by Fu Lam Diep on 19.11.21.
//

import ChaosCore

public class ChaosMetalError: ChaosError {

    public enum Code: Int {
        case noCommandQueue
        case noCommandBuffer
        case noCommandEncoder
        case noLibrary
        case functionNotFound
        case noComputePipelineState
        case noBuffer
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
