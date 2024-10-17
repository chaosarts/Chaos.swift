//
//  AlgorithmError.swift
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

import Foundation
import ChaosCore

public class AlgorithmError: ChaosError {
    public enum Code: Int {
        case matrixSizeMismatch
        case invalidReduceCallback
    }

    public var code: Code

    public var previous: Error?

    public init (code: Code, previous: Error? = nil) {
        self.code = code
        self.previous = previous
    }
}
