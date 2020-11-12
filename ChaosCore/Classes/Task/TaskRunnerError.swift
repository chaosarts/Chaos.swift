//
//  TaskRunnerError.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

public class TaskRunnerError: CustomNSError {

    public let code: Code

    public let message: String?

    public let previous: Error?

    public var errorCode: Int { code.rawValue }

    public init (code: Code, message: String? = nil, previous: Error? = nil) {
        self.code = code
        self.message = message
        self.previous = previous
    }
}


public extension TaskRunnerError {
    @objc enum Code: Int {
        case noTaskSource
    }
}
